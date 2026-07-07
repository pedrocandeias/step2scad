"""Control-outline loft re-architecture (aggressive de-staircasing, Palm_left).

REPLACES the band-stack shell/cavity wholesale: slabs regroup into geometric
chains (y-contiguity + footprint overlap — tower names are too fragmented),
each chain's sections are DECIMATED to control outlines by ruled
interpolation error (fitting.decimate_sections_ruled: a section survives
only if the skin between its neighbors cannot reproduce it within TOL;
correspondence jumps break chains — honest slab fallback), and each segment
emits ONE `skin` loft. The Distals control-section treatment, generalized
to non-convex outlines.

Exact/mating features (posts, ears, sockets, tubes, grid, cuts, plane trims)
pass through verbatim. Reads plan_pre_skinstairs.json (the slab
architecture); writes plan.json. TOL via argv[1] (default 0.30).

Run: python3 scripts/authoring/controlloft_palm.py [tol]
"""
import json
import shutil
import sys
from pathlib import Path

import numpy as np

sys.path.insert(0, "src")
from step2scad.fitting import decimate_sections_ruled, pair_rings, _norm_ccw
from step2scad.plan import validate_plan

OUT = Path("output/Palm_left")
TOL = float(sys.argv[1]) if len(sys.argv) > 1 else 0.30
BREAK_P90 = 6.0          # correspondence jump that breaks a chain (mm, p90)
CONTIG = 0.05            # max y gap between chained slabs
OVERLAP_MIN = 0.5        # footprint bbox overlap to chain across towers
PTOL = 0.002             # ring vertex-param dedupe (fraction of perimeter)

src_plan = OUT / "plan_pre_skinstairs.json"
plan = json.loads(src_plan.read_text())
body = plan["bodies"][0]
if not (OUT / "plan_pre_controlloft.json").exists():
    shutil.copy(src_plan, OUT / "plan_pre_controlloft.json")


def path_points(p2d):
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


def bbox_overlap(p, q):
    (l1, u1) = np.min(p, axis=0), np.max(p, axis=0)
    (l2, u2) = np.min(q, axis=0), np.max(q, axis=0)
    lo, hi = np.maximum(l1, l2), np.minimum(u1, u2)
    if np.any(hi <= lo):
        return 0.0
    inter = float(np.prod(hi - lo))
    a1 = float(np.prod(u1 - l1)) + 1e-9
    a2 = float(np.prod(u2 - l2)) + 1e-9
    return inter / min(a1, a2)


def common_rings(polys):
    """Corner-preserving common-param rings across ALL kept outlines."""
    from step2scad.fitting import _vparams, _sample_at
    anchored = []
    anchor = None
    for pts in polys:
        a = _norm_ccw(pts, anchor)
        anchored.append(a)
        anchor = a[0]
    allp = np.sort(np.concatenate([_vparams(a) for a in anchored]))
    merged = [float(allp[0])]
    for v in allp[1:]:
        if v - merged[-1] > PTOL:
            merged.append(float(v))
    params = np.array(merged)
    return [_sample_at(a, params) for a in anchored]


def outer_sections(levels):
    """Slice the reference at each band level: depth-0 (outermost) loops in
    the (z, x) profile frame of axis-y extrudes. -> {ymid: [loop_pts...]}"""
    import trimesh
    ref = trimesh.load(str(OUT / "Palm_left_ref.stl"), force="mesh")
    out = {}
    for ym in levels:
        s = ref.section(plane_origin=[0, float(ym), 0], plane_normal=[0, 1, 0])
        if s is None:
            continue
        loops = [np.array(lp)[:, [2, 0]] for lp in s.discrete]   # (z, x)
        loops = [lp[:-1] if np.allclose(lp[0], lp[-1]) else lp for lp in loops]
        keep = []
        for i, lp in enumerate(loops):
            c = lp.mean(axis=0)
            depth = 0
            for j, other in enumerate(loops):
                if j == i:
                    continue
                # point-in-polygon (ray cast) for containment depth
                x, y = c
                inside = False
                ox, oy = other[:, 0], other[:, 1]
                for k in range(len(other)):
                    x1, y1 = ox[k], oy[k]
                    x2, y2 = ox[(k + 1) % len(other)], oy[(k + 1) % len(other)]
                    if (y1 > y) != (y2 > y):
                        if x < x1 + (y - y1) * (x2 - x1) / (y2 - y1 + 1e-12):
                            inside = not inside
                if inside:
                    depth += 1
            if depth == 0 and len(lp) >= 8:
                keep.append(lp.tolist())
        out[float(ym)] = keep
    return out


def rebuild_shell_from_slices():
    """Coherent outer-surface lofts: full depth-0 section loops re-sliced
    from the reference (fragment towers cross-hatch — measured)."""
    mod = body["modules"]["palm_shell"]
    kids = mod["tree"]["children"]
    slabs = [k for k in kids
             if k.get("prim") == "extrude" and k.get("axis") == "y"
             and isinstance(k.get("z0"), (int, float))]
    others = [k for k in kids if k not in slabs]
    bandset = sorted({(round(s["z0"], 6), round(s["z1"], 6)) for s in slabs})
    levels = [(a + b) / 2 for a, b in bandset]
    secs_by_level = outer_sections(levels)

    # tracks: match loops across consecutive levels by centroid distance
    chains = []          # each: [(band_idx, loop_pts)]
    open_ch = []         # (chain, centroid, band_idx)
    for bi, (bk, ym) in enumerate(zip(bandset, levels)):
        loops = secs_by_level.get(float(ym), [])
        cents = [np.mean(lp, axis=0) for lp in loops]
        used = set()
        nxt = []
        for ch, lc, lbi in open_ch:
            if lbi != bi - 1:
                chains.append(ch)
                continue
            best, bd = None, 8.0
            for k, c in enumerate(cents):
                if k in used:
                    continue
                d = float(np.hypot(*(c - lc)))
                if d < bd:
                    best, bd = k, d
            if best is None:
                chains.append(ch)
            else:
                used.add(best)
                ch.append((bi, loops[best]))
                nxt.append((ch, cents[best], bi))
        for k, lp in enumerate(loops):
            if k not in used:
                ch = [(bi, lp)]
                nxt.append((ch, cents[k], bi))
        open_ch = nxt
    chains += [ch for ch, _, _ in open_ch]

    new_kids = []
    n_sk = n_slab = n_sec = 0
    for ci, ch in enumerate(chains):
        if len(ch) < 3:
            for bi, lp in ch:
                y0, y1 = bandset[bi]
                new_kids.append({
                    "prim": "extrude", "axis": "y",
                    "name": f"shell_s{ci:03d}b{bi:03d}",
                    "source": "measured full-section band (chain too short "
                              "to loft)",
                    "profile": [[round(float(u), 4), round(float(v), 4)]
                                for u, v in lp],
                    "z0": y0, "z1": y1})
                n_slab += 1
            continue
        secs = [(levels[bi], lp) for bi, lp in ch]
        segments, worst = decimate_sections_ruled(secs, tol=TOL,
                                                  break_p90=BREAK_P90)
        for si, seg in enumerate(segments):
            if len(seg) < 2:
                for m in seg:
                    bi, lp = ch[m]
                    y0, y1 = bandset[bi]
                    new_kids.append({
                        "prim": "extrude", "axis": "y",
                        "name": f"shell_s{ci:03d}k{bi:03d}",
                        "source": "measured full-section band (interp break)",
                        "profile": [[round(float(u), 4), round(float(v), 4)]
                                    for u, v in lp],
                        "z0": y0, "z1": y1})
                    n_slab += 1
                continue
            polys = [ch[m][1] for m in seg]
            rings = common_rings(polys)
            y_lo = bandset[ch[seg[0]][0]][0]
            y_hi = bandset[ch[seg[-1]][0]][1]
            secs_out = [{"at": round(float(y_lo), 6),
                         "outline": [[round(float(u), 4), round(float(v), 4)]
                                     for u, v in rings[0]]}]
            for m, ring in zip(seg, rings):
                at = round(float(levels[ch[m][0]]), 6)
                if at > secs_out[-1]["at"] + 1e-6:
                    secs_out.append({"at": at,
                                     "outline": [[round(float(u), 4),
                                                  round(float(v), 4)]
                                                 for u, v in ring]})
            if round(float(y_hi), 6) > secs_out[-1]["at"] + 1e-6:
                secs_out.append({"at": round(float(y_hi), 6),
                                 "outline": secs_out[-1]["outline"]})
            new_kids.append({
                "prim": "skin", "axis": "y",
                "name": f"shell_loft{ci:03d}{chr(97 + si % 26)}",
                "source": ("coherent outer-surface loft: full re-sliced "
                           f"depth-0 sections, {len(seg)} control outlines "
                           f"from {len(ch)} levels (ruled interp <= {TOL}, "
                           f"worst dropped {worst:.3f})"),
                "sections": secs_out})
            n_sk += 1
            n_sec += len(seg)
    mod["tree"]["children"] = others + new_kids
    return len(slabs), len(chains), n_sk, n_sec, n_slab


def rebuild_module(mod_name):
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

    # geometric chaining: y-contiguity + footprint overlap (cross-tower)
    slabs.sort(key=lambda k: (k["z0"], k["name"]))
    chains = []
    for s in slabs:
        best, best_ov = None, OVERLAP_MIN
        for c in chains:
            tail = c[-1]
            if abs(s["z0"] - tail["z1"]) < CONTIG:
                ov = bbox_overlap(s["_pts"], tail["_pts"])
                if ov > best_ov:
                    best, best_ov = c, ov
        if best is None:
            chains.append([s])
        else:
            best.append(s)

    new_kids = []
    n_sk = n_slab = n_sections = 0
    for ci, cs in enumerate(chains):
        if len(cs) < 3:
            for s in cs:
                s.pop("_pts", None)
            new_kids.extend(cs)
            n_slab += len(cs)
            continue
        secs = [((s["z0"] + s["z1"]) / 2, s["_pts"]) for s in cs]
        segments, worst = decimate_sections_ruled(secs, tol=TOL,
                                                  break_p90=BREAK_P90)
        zone = cs[0]["name"].split("_t")[0]
        for si, seg in enumerate(segments):
            if len(seg) < 2:
                for m in seg:
                    cs[m].pop("_pts", None)
                    new_kids.append(cs[m])
                    n_slab += 1
                continue
            polys = [cs[m]["_pts"] for m in seg]
            rings = common_rings(polys)
            y_lo = cs[seg[0]]["z0"]
            y_hi = cs[seg[-1]]["z1"]
            secs_out = [{"at": round(float(y_lo), 6),
                         "outline": [[round(float(u), 4), round(float(v), 4)]
                                     for u, v in rings[0]]}]
            for m, ring in zip(seg, rings):
                at = round((cs[m]["z0"] + cs[m]["z1"]) / 2, 6)
                if at > secs_out[-1]["at"] + 1e-6:
                    secs_out.append({"at": at,
                                     "outline": [[round(float(u), 4),
                                                  round(float(v), 4)]
                                                 for u, v in ring]})
            if round(float(y_hi), 6) > secs_out[-1]["at"] + 1e-6:
                secs_out.append({"at": round(float(y_hi), 6),
                                 "outline": secs_out[-1]["outline"]})
            new_kids.append({
                "prim": "skin", "axis": "y",
                "name": f"{zone}_loft{ci:03d}{chr(97 + si)}",
                "source": ("control-outline ruled loft: "
                           f"{len(seg)} control sections decimated from "
                           f"{len(cs)} measured bands (ruled interp err "
                           f"<= {TOL}, worst dropped {worst:.3f}; "
                           "corner-preserving common-parameter rings)"),
                "sections": secs_out})
            n_sk += 1
            n_sections += len(seg)
        for s in cs:
            s.pop("_pts", None)
    mod["tree"]["children"] = others + new_kids
    return len(slabs), len(chains), n_sk, n_sections, n_slab


# NOTE (measured dead end): rebuild_shell_from_slices() lofts the FULL
# re-sliced depth-0 outlines — coherent in principle, but ruled skins
# between deeply CONCAVE full outlines self-intersect (Manifold resolved
# them at -10k mm3: shell 36615 vs ~46k; whole part IoU 0.7044). The v1
# fragmentation exists precisely to keep loftable pieces; kept here for a
# future monotone closest-point correspondence attempt.
for m in ("palm_shell", "palm_cavity"):
    tot, nch, nsk, nsec, nslab = rebuild_module(m)
    print(f"{m}: {tot} slabs -> {nch} cadeias -> {nsk} skins "
          f"({nsec} secções de controlo) + {nslab} slabs mantidos")

body["notes"] = (body.get("notes", "")
                 + f" | controlloft: shell/cavity re-architected as decimated"
                   f" control-outline skin lofts (ruled interp tol {TOL})")
validate_plan(plan)
json.dump(plan, open(OUT / "plan.json", "w"), indent=1)
print(f"wrote plan.json (controlloft, tol {TOL})")
