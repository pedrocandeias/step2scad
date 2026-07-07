"""Deterministic fitting/vectorizing utilities for plan authoring.

Mechanical measurement helpers (rule 7: scripts measure, the agent decides).
Every fit returns its residual — the caller MUST check it against a tolerance
before claiming the parametric form, and cite it in the plan `source`.

Proven on Arm_Guard (schema v2/v3 semanticization): see
scripts/authoring/author_armguard_parametric.py and CLAUDE.md
§ Emitted-code style.
"""

from __future__ import annotations

import numpy as np


# --------------------------------------------------------------------------
# basic fits (all return ... , residual)
# --------------------------------------------------------------------------

def circle_fit(pts: np.ndarray):
    """Algebraic (Kasa) circle fit. -> (cx, cy, r, max_residual)."""
    pts = np.asarray(pts, float)
    x, y = pts[:, 0], pts[:, 1]
    A = np.c_[2 * x, 2 * y, np.ones(len(pts))]
    (cx, cy, c), *_ = np.linalg.lstsq(A, x**2 + y**2, rcond=None)
    r = float(np.sqrt(max(c + cx**2 + cy**2, 1e-12)))
    res = float(np.abs(np.hypot(x - cx, y - cy) - r).max())
    return float(cx), float(cy), r, res


def line_fit(xs, ys):
    """y = m*x + b least squares. -> (m, b, max_residual)."""
    xs = np.asarray(xs, float); ys = np.asarray(ys, float)
    (m, b), *_ = np.linalg.lstsq(np.c_[xs, np.ones(len(xs))], ys, rcond=None)
    res = float(np.abs(ys - (m * xs + b)).max())
    return float(m), float(b), res


def capsule_fit(pts: np.ndarray):
    """Stadium fit via PCA. -> (cap_a, cap_b, r, max_residual)."""
    pts = np.asarray(pts, float)
    c = pts.mean(axis=0); q = pts - c
    _, _, vt = np.linalg.svd(q, full_matrices=False)
    ax = vt[0]
    t = q @ ax
    r = float(np.median(np.sort(np.abs(q @ np.array([-ax[1], ax[0]])))[-len(q) // 2:]))
    a, b = c + (t.min() + r) * ax, c + (t.max() - r) * ax
    AB = b - a
    tt = np.clip(((pts - a) @ AB) / (AB @ AB), 0, 1)
    d = np.linalg.norm(pts - (a + tt[:, None] * AB), axis=1)
    return a, b, r, float(np.abs(d - np.median(d)).max())


def dist_to_poly(pts: np.ndarray, poly: np.ndarray) -> np.ndarray:
    """Distance of each point to a closed polygon boundary."""
    pts = np.asarray(pts, float); poly = np.asarray(poly, float)
    a = poly; b = np.roll(poly, -1, axis=0)
    d = np.full(len(pts), np.inf)
    for A, B in zip(a, b):
        AB = B - A
        L2 = AB @ AB
        if L2 < 1e-12:
            continue
        t = np.clip(((pts - A) @ AB) / L2, 0, 1)
        d = np.minimum(d, np.linalg.norm(pts - (A + t[:, None] * AB), axis=1))
    return d


def uniform_offset(band_pts, ref_poly, std_tol=0.05):
    """Mean inset of a loop vs a reference outline, IF uniform.
    -> (mean_inset, std) ; raises AssertionError when not uniform."""
    d = dist_to_poly(band_pts, ref_poly)
    assert d.std() < std_tol, f"offset not uniform (std {d.std():.3f})"
    return float(d.mean()), float(d.std())


# --------------------------------------------------------------------------
# polygon vectorizer: measured points -> path of lines + fitted arcs
# --------------------------------------------------------------------------

def vectorize(points, exact_circles=(), tol=0.06, min_arc=4, r_max=60.0,
              gap_max=4.6, rnd=6):
    """Closed polygon -> plan `path` segments (lines + fitted arcs).

    exact_circles: [(face_id, cx, cy, r), ...] — fitted arcs snap to these
    exact B-rep circles when center+radius agree (angles are recomputed from
    the snapped center). Traps hard-learned on Arm_Guard: the walk starts at
    the sharpest corner (no wrap-around duplicate arcs), sweeps must be
    monotonic and densely sampled, and huge-radius "arcs" through straight
    runs are rejected.

    -> (segments, n_lines, n_arcs, n_exact)
    """
    R = lambda v: round(float(v), rnd)
    pts = [list(map(float, q)) for q in points]
    n = len(pts)
    P = np.array(pts)
    v1 = P - np.roll(P, 1, axis=0)
    v2 = np.roll(P, -1, axis=0) - P
    turn = np.abs(np.cross(v1, v2) / (np.linalg.norm(v1, axis=1)
                                      * np.linalg.norm(v2, axis=1) + 1e-12))
    start = int(np.argmax(turn))
    pts = pts[start:] + pts[:start]

    def ok_arc(window, fit):
        if fit is None or fit[3] > tol or fit[2] > r_max:
            return False
        gaps = np.linalg.norm(np.diff(window, axis=0), axis=1)
        if gaps.max() > gap_max:
            return False
        cx, cy, r, _ = fit
        ang = np.unwrap(np.arctan2(window[:, 1] - cy, window[:, 0] - cx))
        d = np.diff(ang)
        if not (np.all(d > 0) or np.all(d < 0)):
            return False
        amid = (ang[0] + ang[-1]) / 2
        pm = np.array([cx + r * np.cos(amid), cy + r * np.sin(amid)])
        return np.linalg.norm(window - pm, axis=1).min() <= max(0.4, 3 * tol)

    segs, i = [], 0
    n_arcs = n_exact = 0
    while i < n:
        best = None
        j = i + min_arc - 1
        while j <= n:
            window = np.array([pts[k % n] for k in range(i, j + 1)])
            try:
                fit = circle_fit(window)
            except Exception:
                fit = None
            if not ok_arc(window, fit):
                break
            best = (j, fit)
            j += 1
        if best and best[0] - i + 1 >= min_arc:
            j, (cx, cy, r, res) = best
            window = np.array([pts[k % n] for k in range(i, j + 1)])
            ang = np.unwrap(np.arctan2(window[:, 1] - cy, window[:, 0] - cx))
            for fi, fx, fy, fr in exact_circles:
                if abs(fx - cx) < 0.12 and abs(fy - cy) < 0.12 and abs(fr - r) < 0.08:
                    cx, cy, r = fx, fy, fr
                    ang = np.unwrap(np.arctan2(window[:, 1] - cy,
                                               window[:, 0] - cx))
                    n_exact += 1
                    break
            a0, a1 = float(np.degrees(ang[0])), float(np.degrees(ang[-1]))
            segs.append({"arc": {"c": [R(cx), R(cy)], "r": R(r), "a0": R(a0),
                                 "a1": R(a1),
                                 "n": max(3, int(abs(a1 - a0) // 6) + 1)}})
            n_arcs += 1
            i = j
        else:
            segs.append({"to": [R(pts[(i + 1) % n][0]), R(pts[(i + 1) % n][1])]})
            i += 1
    return segs, len(segs) - n_arcs, n_arcs, n_exact


def z_cylinder_circles(faces) -> list[tuple]:
    """(face_id, cx, cy, r) for every z-axis cylinder face — the exact-circle
    pool the vectorizer snaps to."""
    out = []
    for f in faces:
        if (f["type"] == "cylinder"
                and abs(abs(f["params"]["axis_dir"][2]) - 1) < 1e-3):
            p = f["params"]
            out.append((f["index"], p["axis_origin"][0], p["axis_origin"][1],
                        p["radius"]))
    return out

# --------------------------------------------------------------------------
# loft-station decimation: keep only CONTROL sections
# --------------------------------------------------------------------------

def _support(poly, thetas):
    """Support function h(theta) of a (convex) polygon."""
    p = np.asarray(poly, float)
    return (p[:, 0][None, :] * np.cos(thetas)[:, None]
            + p[:, 1][None, :] * np.sin(thetas)[:, None]).max(axis=1)


def decimate_stations(stations, tol=0.12, angles=180):
    """Reduce a measured loft chain to its parametric CONTROL sections.

    stations: [(s, polygon2d), ...] ordered along the loft axis. An interior
    station is dropped when the hull of its surviving neighbors reproduces it
    within `tol`: the cross-section of hull(A@sa, B@sb) at s is the Minkowski
    blend (1-t)A + tB (exact for convex profiles), whose support function is
    the linear blend of the two supports. Greedy min-error removal
    (Douglas-Peucker in profile space).

    -> (kept_indices, max_interp_error_over_dropped)
    """
    n = len(stations)
    if n <= 2:
        return list(range(n)), 0.0
    thetas = np.linspace(0, 2 * np.pi, angles, endpoint=False)
    S = [float(s) for s, _ in stations]
    H = [_support(p, thetas) for _, p in stations]

    kept = list(range(n))

    def interp_err(i_prev, i, i_next):
        t = (S[i] - S[i_prev]) / (S[i_next] - S[i_prev])
        return float(np.abs(H[i] - ((1 - t) * H[i_prev] + t * H[i_next])).max())

    worst_dropped = 0.0
    while len(kept) > 2:
        errs = [(interp_err(kept[k - 1], kept[k], kept[k + 1]), k)
                for k in range(1, len(kept) - 1)]
        e, k = min(errs)
        if e >= tol:
            break
        worst_dropped = max(worst_dropped, e)
        kept.pop(k)
    return kept, worst_dropped


# --------------------------------------------------------------------------
# ruled-section decimation: control OUTLINES for skin lofts (non-convex OK)
# --------------------------------------------------------------------------

def _norm_ccw(poly, anchor=None):
    """CCW closed polygon rotated to start nearest `anchor` (default: the
    topmost vertex). Vertices preserved exactly."""
    a = np.asarray(poly, float)
    if np.allclose(a[0], a[-1]):
        a = a[:-1]
    area2 = np.sum(a[:, 0] * np.roll(a[:, 1], -1)
                   - np.roll(a[:, 0], -1) * a[:, 1])
    if area2 < 0:
        a = a[::-1]
    if anchor is None:
        k = int(np.lexsort((a[:, 1], -a[:, 0]))[0])
    else:
        k = int(np.argmin(np.linalg.norm(a - anchor, axis=1)))
    return np.roll(a, -k, axis=0)


def _vparams(a):
    seg = np.linalg.norm(np.roll(a, -1, axis=0) - a, axis=1)
    cum = np.concatenate([[0.0], np.cumsum(seg)])
    return cum[:-1] / max(cum[-1], 1e-12)


def _sample_at(a, params):
    seg = np.linalg.norm(np.roll(a, -1, axis=0) - a, axis=1)
    cum = np.concatenate([[0.0], np.cumsum(seg)])
    total = max(cum[-1], 1e-12)
    closed = np.vstack([a, a[:1]])
    out = np.empty((len(params), 2))
    for k, pv in enumerate(params):
        tv = pv * total
        i = min(max(int(np.searchsorted(cum, tv, side="right") - 1), 0),
                len(a) - 1)
        f = (tv - cum[i]) / max(seg[i], 1e-12)
        out[k] = closed[i] * (1 - f) + closed[i + 1] * f
    return out


def pair_rings(pa, pb, ptol=0.0015):
    """Corner-preserving common-parameter rings for two outlines.
    -> (ring_a, ring_b, p90_step) — correspondence by shared arclength
    params (union of both vertex sets; uniform resampling CUTS CORNERS)."""
    a = _norm_ccw(pa)
    b = _norm_ccw(pb, anchor=a[0])
    allp = np.sort(np.concatenate([_vparams(a), _vparams(b)]))
    merged = [float(allp[0])]
    for v in allp[1:]:
        if v - merged[-1] > ptol:
            merged.append(float(v))
    params = np.array(merged)
    ra, rb = _sample_at(a, params), _sample_at(b, params)
    step = float(np.percentile(np.linalg.norm(rb - ra, axis=1), 90))
    return ra, rb, step


def decimate_sections_ruled(sections, tol=0.3, break_p90=6.0):
    """Reduce an ordered loft chain [(s, outline), ...] to CONTROL OUTLINES.

    Ruled generalization of decimate_stations for NON-convex outlines: an
    interior section is dropped when the ruled (skin) interpolation between
    its surviving neighbors reproduces it within `tol` (symmetric max
    boundary distance). Chains split where consecutive correspondence jumps
    (aligned ring p90 step > break_p90 — a topology/shape discontinuity).

    -> (segments, worst_err): segments = lists of indices into `sections`
       (each a loft chain of KEPT control outlines, >= 2 each or singleton
       to stay a slab); worst_err = max interp error over dropped sections.
    """
    n = len(sections)
    S = [float(s) for s, _ in sections]
    P = [np.asarray(p, float) for _, p in sections]

    # hard breaks: consecutive correspondence jumps
    bounds = [0]
    for i in range(n - 1):
        _, _, step = pair_rings(P[i], P[i + 1])
        if step > break_p90:
            bounds.append(i + 1)
    bounds.append(n)

    def interp_err(i, k, j):
        ra, rb, _ = pair_rings(P[i], P[j])
        t = (S[k] - S[i]) / max(S[j] - S[i], 1e-12)
        ring = ra * (1 - t) + rb * t
        d1 = dist_to_poly(ring, P[k]).max()
        d2 = dist_to_poly(P[k], ring).max()
        return float(max(d1, d2))

    segments = []
    worst = 0.0
    for b0, b1 in zip(bounds, bounds[1:]):
        idx = list(range(b0, b1))
        if len(idx) <= 2:
            segments.append(idx)
            continue
        while len(idx) > 2:
            errs = [(interp_err(idx[m - 1], idx[m], idx[m + 1]), m)
                    for m in range(1, len(idx) - 1)]
            e, m = min(errs)
            if e >= tol:
                break
            worst = max(worst, e)
            idx.pop(m)
        segments.append(idx)
    return segments, worst
