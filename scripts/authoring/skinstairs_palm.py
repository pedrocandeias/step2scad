"""Stairs -> ruled skin (author's binding rule, Palm_left).

Wherever the model presents as stairs, the smooth form is the ruled surface
connecting the TOP EDGES of consecutive steps: for each tower of contiguous
y-band slabs, loft band_i's outline to band_{i+1}'s (sections at band
midpoints, end sections at the tower's outer edges) instead of stacking
vertical-walled slabs. Constant runs were already collapsed upstream (first
pass, kept); slabs remain only where a chain breaks (topology change /
correspondence jump — measured, logged).

Mechanics per chain:
  - profiles resampled to a fixed point count by arclength, normalized CCW,
    consecutive rings aligned by cyclic shift (min squared distance) —
    correspondence is established HERE, at authoring time, so the emitted
    `skin` polyhedron is deterministic;
  - a chain BREAKS where the aligned ring distance jumps (> BREAK_DIST
    median point move): that is a topology/shape discontinuity — those
    boundaries keep the honest slab representation.

Chained from author_palm_left_parametric.py after planetrims_palm.
"""
import json
import shutil
from pathlib import Path

import numpy as np

OUT = Path("output/Palm_left")
BREAK_DIST = 6.0     # p90 aligned point move (mm) that breaks a chunk
CONTIG = 0.03        # max y gap between consecutive slabs of one tower
MIN_CHAIN = 2        # chains shorter than this stay as slabs
CHUNK = 6            # max sections per skin (bounds param drift + union size)
PTOL = 0.0015        # vertex-parameter dedupe tolerance (fraction of perimeter)

plan = json.loads((OUT / "plan.json").read_text())
body = plan["bodies"][0]
if not (OUT / "plan_pre_skinstairs.json").exists():
    shutil.copy(OUT / "plan.json", OUT / "plan_pre_skinstairs.json")


def path_points(p2d):
    """Expand a profile2d path/poly (or raw profile) to a point list."""
    if isinstance(p2d, list):
        return [list(map(float, q)) for q in p2d]
    if "poly" in p2d:
        return [list(map(float, q)) for q in p2d["poly"]]
    pts = []
    for s in p2d["path"]:
        if "to" in s:
            pts.append(list(map(float, s["to"])))
        else:
            a = s["arc"]
            for k in range(1, a["n"] + 1):
                ang = np.radians(a["a0"] + k * (a["a1"] - a["a0"]) / a["n"])
                pts.append([a["c"][0] + a["r"] * np.cos(ang),
                            a["c"][1] + a["r"] * np.sin(ang)])
    return pts


def norm_ccw(poly, anchor=None):
    """CCW closed polygon, rotated to start at the vertex nearest `anchor`
    (or the topmost vertex). Corners are PRESERVED exactly."""
    a = np.asarray(poly, float)
    if a[0].tolist() == a[-1].tolist():
        a = a[:-1]
    area2 = np.sum(a[:, 0] * np.roll(a[:, 1], -1) - np.roll(a[:, 0], -1) * a[:, 1])
    if area2 < 0:
        a = a[::-1]
    if anchor is None:
        k = int(np.lexsort((a[:, 1], -a[:, 0]))[0])
    else:
        k = int(np.argmin(np.linalg.norm(a - anchor, axis=1)))
    return np.roll(a, -k, axis=0)


def vparams(a):
    """Normalized arclength parameter of each vertex (from the start)."""
    seg = np.linalg.norm(np.roll(a, -1, axis=0) - a, axis=1)
    cum = np.concatenate([[0.0], np.cumsum(seg)])
    return cum[:-1] / max(cum[-1], 1e-12)


def sample_at(a, params):
    """Points of polygon `a` at normalized arclength params (vertices land
    exactly on themselves; other params interpolate along edges)."""
    seg = np.linalg.norm(np.roll(a, -1, axis=0) - a, axis=1)
    cum = np.concatenate([[0.0], np.cumsum(seg)])
    total = max(cum[-1], 1e-12)
    closed = np.vstack([a, a[:1]])
    out = np.empty((len(params), 2))
    for k, pv in enumerate(params):
        tv = pv * total
        i = int(np.searchsorted(cum, tv, side="right") - 1)
        i = min(max(i, 0), len(a) - 1)
        f = (tv - cum[i]) / max(seg[i], 1e-12)
        out[k] = closed[i] * (1 - f) + closed[i + 1] * f
    return out


def make_rings(polys):
    """Common-param corner-preserving rings for one skin chunk.
    -> (rings, p90_step_distance)"""
    anchored = []
    anchor = None
    for pts in polys:
        a = norm_ccw(pts, anchor)
        anchored.append(a)
        anchor = a[0]
    allp = np.sort(np.concatenate([vparams(a) for a in anchored]))
    merged = [float(allp[0])]
    for v in allp[1:]:
        if v - merged[-1] > PTOL:
            merged.append(float(v))
    params = np.array(merged)
    rings = [sample_at(a, params) for a in anchored]
    worst = 0.0
    for r1, r2 in zip(rings, rings[1:]):
        d = np.linalg.norm(r2 - r1, axis=1)
        worst = max(worst, float(np.percentile(d, 90)))
    return rings, worst


def bbox(p):
    a = np.asarray(p, float)
    return a.min(axis=0), a.max(axis=0)


def overlap(p, q):
    (l1, u1), (l2, u2) = bbox(p), bbox(q)
    lo = np.maximum(l1, l2)
    hi = np.minimum(u1, u2)
    if np.any(hi <= lo):
        return 0.0
    inter = np.prod(hi - lo)
    return inter / min(np.prod(u1 - l1) + 1e-9, np.prod(u2 - l2) + 1e-9)


def skin_module(mod_name):
    mod = body["modules"][mod_name]
    kids = mod["tree"]["children"]
    slabs = [k for k in kids
             if k.get("prim") == "extrude" and k.get("axis") == "y"
             and ("profile" in k or "profile2d" in k)
             and isinstance(k.get("z0"), (int, float))
             and isinstance(k.get("z1"), (int, float))]
    others = [k for k in kids if k not in slabs]
    for s in slabs:
        s["_pts"] = path_points(s.get("profile2d", s.get("profile")))

    # towers by name prefix (shell_t00b123 -> shell_t00); overlap fallback
    import re
    towers = {}
    for s in slabs:
        m = re.match(r"(.+_t\d+)b?\d*", s["name"])
        towers.setdefault(m.group(1) if m else s["name"], []).append(s)
    chains = []
    for tname, ts in towers.items():
        ts.sort(key=lambda k: k["z0"])
        cur = [ts[0]]
        for s in ts[1:]:
            if abs(s["z0"] - cur[-1]["z1"]) < CONTIG:
                cur.append(s)
            else:
                chains.append({"slabs": cur})
                cur = [s]
        chains.append({"slabs": cur})

    new_kids, n_skinned, n_kept, n_breaks = [], 0, 0, 0
    for ci, c in enumerate(chains):
        cs = c["slabs"]
        if len(cs) < MIN_CHAIN:
            new_kids.extend(cs)
            n_kept += len(cs)
            continue
        # chunk the chain, build corner-preserving common-param rings; a
        # chunk whose ring step jumps (topology change) falls back to slabs
        ri = 0
        i0 = 0
        while i0 < len(cs):
            run = cs[i0:i0 + CHUNK]
            i0 += len(run)
            if len(run) < MIN_CHAIN:
                new_kids.extend(run)
                n_kept += len(run)
                continue
            rings, worst = make_rings([s["_pts"] for s in run])
            if worst > BREAK_DIST:
                n_breaks += 1
                new_kids.extend(run)
                n_kept += len(run)
                continue
            secs = [{"at": round(run[0]["z0"], 6),
                     "outline": [[round(float(u), 4), round(float(v), 4)]
                                 for u, v in rings[0]]}]
            for s, ring in zip(run, rings):
                secs.append({"at": round((s["z0"] + s["z1"]) / 2, 6),
                             "outline": [[round(float(u), 4),
                                          round(float(v), 4)] for u, v in ring]})
            secs.append({"at": round(run[-1]["z1"], 6),
                         "outline": secs[-1]["outline"]})
            dedup = [secs[0]]
            for s2 in secs[1:]:
                if s2["at"] > dedup[-1]["at"] + 1e-6:
                    dedup.append(s2)
            new_kids.append({
                "prim": "skin", "axis": "y",
                "name": f"{mod_name}_sk{ci:02d}{chr(97 + ri)}",
                "source": ("ruled skin through the measured band outlines "
                           f"(author's stairs rule): {len(run)} bands -> "
                           f"{len(dedup)} sections, corner-preserving "
                           "common-parameter rings (vertices exact; ring "
                           f"N={len(rings[0])})"),
                "sections": dedup})
            n_skinned += len(run)
            ri += 1
        for s in cs:
            s.pop("_pts", None)
    for s in slabs:
        s.pop("_pts", None)
    mod["tree"]["children"] = others + new_kids
    return len(slabs), n_skinned, n_kept, n_breaks


for m in ("palm_shell", "palm_cavity"):
    tot, sk, kp, br = skin_module(m)
    print(f"{m}: {tot} slabs -> {sk} em skins, {kp} mantidos, {br} quebras de topologia")

import sys
sys.path.insert(0, "src")
from step2scad.plan import validate_plan
validate_plan(plan)
json.dump(plan, open(OUT / "plan.json", "w"), indent=1)
note = " | skinstairs: band stacks -> ruled skins (author's stairs rule)"
if note.strip(" |") not in body.get("notes", ""):
    body["notes"] = body.get("notes", "") + note
    json.dump(plan, open(OUT / "plan.json", "w"), indent=1)
print("wrote plan.json (skinstairs)")
