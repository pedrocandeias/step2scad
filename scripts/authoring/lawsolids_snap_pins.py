"""Law-solid stage for the Snap_Pins head plates (chained from
author_snap_pins_parametric.py — one run produces the final plan).

Replaces the hull-every-adjacent-pair strategy over the head/profile
stations with the crownlaws pattern:

  - profile stations split into CONTIGUOUS runs (a gap along the pin axis
    means unrelated features — never hull across it);
  - each run decimated to CONTROL slices (`fitting.decimate_stations`,
    support-function interpolation, tol cited);
  - constant spans (adjacent control slices identical within tol) collapse
    to ONE extrude — and when the constant section is a 4-vertex
    axis-aligned rectangle, to ONE `box` prim (`head_plate`) with the
    measured plate dimensions in the source;
  - genuinely tapered spans stay as hulls BETWEEN CONTROL SLICES.

Family features across pins are collected in FAMILY and reported.
"""
from __future__ import annotations

import numpy as np

from step2scad.fitting import decimate_stations, dist_to_poly

DECIM_TOL = 0.05     # control-slice interp error (mm) — conservative
SAME_TOL = 0.05      # adjacent control slices closer than this = constant
RUN_GAP = 1.0        # s-gap that separates unrelated profile runs (mm)

FAMILY: list[tuple] = []   # (body, w, h, span) of recognized head plates


def _axis_rect(profile, tol=0.02):
    """4-vertex axis-aligned rectangle -> (u0, v0, u1, v1), else None."""
    a = np.asarray(profile, float)
    if len(a) != 4:
        return None
    for i in range(4):
        d = a[(i + 1) % 4] - a[i]
        if min(abs(d[0]), abs(d[1])) > tol:
            return None
    return (float(a[:, 0].min()), float(a[:, 1].min()),
            float(a[:, 0].max()), float(a[:, 1].max()))


def build_head_nodes(pin, R, head_slab, report):
    """Law-solid replacement for the pairwise head hulls of one pin."""
    prof = pin["prof"]
    if not prof:
        return []
    bid = pin["bid"]

    runs, cur = [], [0]
    for i in range(1, len(prof)):
        if prof[i][0] - prof[i - 1][0] > RUN_GAP:
            runs.append(cur)
            cur = []
        cur.append(i)
    runs.append(cur)

    kids = []
    for run in runs:
        sts = [(prof[i][0], prof[i][1]["profile"]) for i in run]
        kept_local, err = decimate_stations(sts, tol=DECIM_TOL)
        kept = [run[k] for k in kept_local]
        report.append(f"   b{bid} head run s=[{sts[0][0]}, {sts[-1][0]}]: "
                      f"{len(run)} estações -> {len(kept)} fatias de controlo "
                      f"(erro interp. {err:.3f} <= {DECIM_TOL})")
        if len(kept) == 1:
            kids.append(head_slab(kept[0], ""))
            continue
        for a, b in zip(kept, kept[1:]):
            pa = np.asarray(prof[a][1]["profile"], float)
            pb = np.asarray(prof[b][1]["profile"], float)
            same = max(dist_to_poly(pa, pb).max(),
                       dist_to_poly(pb, pa).max()) < SAME_TOL
            s0, s1 = R(prof[a][0]), R(prof[b][0] + 0.02)
            if not same:                      # measured taper: hull of slices
                kids.append({"op": "hull", "children": [
                    head_slab(a, "a"), head_slab(b, "b")]})
                continue
            h = prof[a][1]
            ax = h.get("axis", "z")
            rect = _axis_rect(h["profile"])
            if rect is not None:              # constant rectangle -> box prim
                u0, v0, u1, v1 = rect
                w, hh = u1 - u0, v1 - v0
                if ax == "x":                 # profile (y, z)
                    mn = [s0, R(u0), R(v0)]
                    sz = [R(s1 - s0), R(w), R(hh)]
                elif ax == "y":               # profile (z, x)
                    mn = [R(v0), s0, R(u0)]
                    sz = [R(hh), R(s1 - s0), R(w)]
                else:                         # profile (x, y)
                    mn = [R(u0), R(v0), s0]
                    sz = [R(w), R(hh), R(s1 - s0)]
                FAMILY.append((bid, R(min(w, hh)), R(max(w, hh)),
                               R(s1 - s0)))
                kids.append({
                    "prim": "box", "name": f"head_plate_{a}",
                    "source": f"head plate: constant axis-aligned rectangular "
                              f"section {w:.2f} x {hh:.2f} over "
                              f"{len([i for i in run if a <= i <= b])} measured "
                              f"stations (identical within {SAME_TOL}; "
                              f"control-slice interp err <= {DECIM_TOL}) — "
                              + h["source"],
                    "min": mn, "size": sz})
            else:                             # constant profile -> one extrude
                base = head_slab(a, f"const{b}")
                base["z1"] = s1
                base["name"] = f"head_const_{a}_{b}"
                base["source"] = ("constant measured head section over "
                                  f"s=[{s0}, {s1}] (adjacent control slices "
                                  f"identical within {SAME_TOL}) — "
                                  + base["source"])
                kids.append(base)
    return kids


def family_report():
    if not FAMILY:
        return []
    from collections import Counter
    dims = Counter((w, h) for _, w, h, _ in FAMILY)
    out = ["   placas de cabeça reconhecidas (família):"]
    for (w, h), n in dims.most_common():
        bods = [b for b, ww, hh, _ in FAMILY if (ww, hh) == (w, h)]
        out.append(f"     {w} x {h}: corpos {bods}"
                   + ("  <- FAMILY feature" if n > 1 else ""))
    return out
