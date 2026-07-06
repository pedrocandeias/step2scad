"""Semanticize the Snap_Pins plan (v1 hull-lofts -> parametric primitives).

Measured discovery: every unique pin's loft stations are CIRCLES on a
colinear axis (centers std 0.0002 except body 0's off-axis head) — the pins
are revolution solids in disguise. Semantic form per pin:

  - radius sequence r(s) segmented into PLATEAUS (cylinders, snapped to
    exact B-rep cylinder faces when radii agree) and TRANSITIONS (frustums)
  - semantic segment names: tip / barb / shaft / collar / head
  - non-circular head stations: vectorized profile extrudes
  - fork-slot / barb-notch cutters: vectorized paths (lines + fitted arcs)

Engraved digit labels remain excluded (documented in the plan notes).
Run:  python3 scripts/authoring/author_snap_pins_parametric.py
"""
import json
import shutil
import sys
from pathlib import Path

import numpy as np
import trimesh

sys.path.insert(0, "src")
from step2scad.fitting import circle_fit, vectorize, z_cylinder_circles
from step2scad.plan import validate_plan

OUT = Path("output/Snap_Pins")
R = lambda v: round(float(v), 6)

v1_path = OUT / "plan_v1.json"
if not v1_path.exists():
    shutil.copy(OUT / "plan.json", v1_path)
v1 = json.load(open(v1_path))
REF = trimesh.load(OUT / "Snap_Pins_ref.stl", force="mesh")


def exact_z_slab(bid):
    """The pins are revolve chains CLIPPED by exact z-plane flats: every
    vertex of a flat-topped section still lies ON the fitted circle (the
    flats are edges, invisible to vertex fits) — the ref sections and the
    exact +-z plane faces reveal them."""
    zs = sorted(round(f["params"]["origin"][2], 6) for f in faces_by_body[bid]
                if f["type"] == "plane"
                and abs(abs(f["params"]["normal"][2]) - 1) < 1e-3)
    return (zs[0], zs[-1]) if len(zs) >= 2 else None


def barb_slab(pin):
    """Measure z flats on 'fat' segments: section the ref solid at each fat
    segment midpoint; if the true z-extent is smaller than the fitted
    diameter, the bulge is clipped by a slab (the v1 hull stations
    circumscribed it as fat circles -> FP above/below the real pin)."""
    if not pin["segs"]:
        return None, []
    rmin = min(g["r"] for g in pin["segs"])
    fat = [k for k, g in enumerate(pin["segs"]) if g["r"] > rmin + 0.12]
    if not fat:
        return None, []
    ax = pin["axis"]
    zs = []
    for k in fat:
        g = pin["segs"][k]
        smid = (g["s0"] + g["s1"]) / 2 + 0.011
        org = [smid, 0, 0] if ax == "x" else [0, smid, 0]
        nrm = [1, 0, 0] if ax == "x" else [0, 1, 0]
        sec = REF.section(plane_origin=org, plane_normal=nrm)
        if sec is None:
            continue
        v = sec.vertices
        lat = v[:, 1] if ax == "x" else v[:, 0]
        a_lat = pin["med"][0] if ax == "x" else pin["med"][1]
        near = v[np.abs(lat - a_lat) < g["r"] + 0.6]
        zloc = near[:, 2]
        a_z = pin["med"][1] if ax == "x" else pin["med"][0]
        zloc = zloc[np.abs(zloc - a_z) < g["r"] + 0.6]
        if len(zloc):
            zs.append((zloc.min(), zloc.max(), g["r"], a_z))
    if not zs:
        return None, fat
    z0 = float(np.median([q[0] for q in zs]))
    z1 = float(np.median([q[1] for q in zs]))
    rfat = max(q[2] for q in zs)
    if (z1 - z0) < 2 * rfat - 0.12:
        return (R(z0), R(z1)), fat
    return None, fat
feats = json.load(open(OUT / "features.json"))
faces_by_body = {b["id"]: b["faces"] for b in feats["bodies"]}

UNIQUE = [0, 1, 5, 6, 7, 10, 12]
AXIS_IDX = {"x": 0, "y": 1}


def exact_radii(bid, axis):
    """Exact cylinder-face radii along the pin axis, for plateau snapping."""
    out = []
    ai = AXIS_IDX[axis]
    for f in faces_by_body[bid]:
        if f["type"] != "cylinder":
            continue
        d = f["params"]["axis_dir"]
        if abs(abs(d[ai]) - 1) < 1e-3:
            out.append((f["index"], f["params"]["radius"]))
    return out


def pin_semantics(bid):
    b = next(x for x in v1["bodies"] if x["body_id"] == bid)
    tree = b["csg"]
    body_solid = tree["children"][0] if tree["op"] == "difference" else tree
    cut_roots = tree["children"][1:] if tree["op"] == "difference" else []

    hulls = []
    def walk(n, ih=False):
        if "op" in n:
            for c in n["children"]:
                walk(c, ih or n["op"] == "hull")
        elif ih:
            hulls.append(n)
    walk(body_solid)
    axis = hulls[0].get("axis", "z")
    stations = {}
    for h in hulls:
        stations.setdefault(round(h["z0"], 4), h)
    ss = sorted(stations)

    # classify stations: circular on-axis vs profile (head)
    def is_circle(a):
        """Vertices on a circle is NOT enough: a rectangle's 4 corners lie
        exactly on its circumscribed circle (res=0.000!). Decimated true
        circles keep >= 6 vertices; rect/square stations decimate to 4-5."""
        if len(a) < 6:
            return None
        cx, cy, r, res = circle_fit(a)
        return (cx, cy, r) if res < 0.08 else None

    circ, prof = [], []
    for s in ss:
        a = np.array(stations[s]["profile"])
        fit = is_circle(a)
        circ.append((s, *fit) if fit else None)
        if not fit:
            prof.append((s, stations[s]))
    circs = [c for c in circ if c]
    if len(circs) < 3:                    # no revolve core: pure vectorized loft
        prof = [(s, stations[s]) for s in ss]
        return dict(bid=bid, axis=axis, med=(0.0, 0.0), segs=[], names=[],
                    prof=prof, cuts=cut_roots, notes=b.get("notes", ""))
    med = np.median([[c[1], c[2]] for c in circs], axis=0)
    onaxis = [c for c in circs
              if abs(c[1] - med[0]) < 0.05 and abs(c[2] - med[1]) < 0.05]
    for c in circs:                      # off-axis circles -> profile stations
        if c not in onaxis:
            prof.append((c[0], stations[c[0]]))
    prof.sort(key=lambda q: q[0])

    # segment the on-axis radius sequence into plateaus + transitions
    onaxis.sort(key=lambda c: c[0])
    runs = []                            # (s0, s1, r_mean) plateaus
    i = 0
    while i < len(onaxis):
        j = i
        while (j + 1 < len(onaxis)
               and abs(onaxis[j + 1][3] - onaxis[i][3]) < 0.012):
            j += 1
        runs.append((onaxis[i][0], onaxis[j][0],
                     float(np.mean([c[3] for c in onaxis[i:j + 1]])), j - i + 1))
        i = j + 1

    exact = exact_radii(bid, axis)
    segs = []
    for k, (s0, s1, r, cnt) in enumerate(runs):
        src = f"plateau of {cnt} measured station circles (r spread < 0.012)"
        for fi, fr in exact:
            if abs(fr - r) < 0.03:
                r, src = fr, f"EXACT cylinder face #{fi} (r={fr})"
                break
        segs.append({"s0": s0, "s1": s1, "r": R(r), "src": src})

    # semantic names
    lengths = [g["s1"] - g["s0"] for g in segs]
    names = [f"seg{k}" for k in range(len(segs))]
    if segs:
        names[int(np.argmax(lengths))] = "shaft"
        rmax = int(np.argmax([g["r"] for g in segs]))
        if names[rmax] == f"seg{rmax}":
            names[rmax] = "barb"
        if names[0].startswith("seg"):
            names[0] = "tip"
        if len(segs) > 1 and names[-1].startswith("seg"):
            names[-1] = "collar"

    return dict(bid=bid, axis=axis, med=med, segs=segs, names=names,
                prof=prof, cuts=cut_roots, notes=b.get("notes", ""))


def seg_cyl(pin, name, g, nxt, nxt_name, params):
    """Plateau cylinder + transition frustum, referencing NAMED params."""
    ax = pin["axis"]
    def P(s_expr):
        return ([s_expr, "axis_y", "axis_z"] if ax == "x"
                else ["axis_x", s_expr, "axis_z"])
    params.append({"name": f"{name}_r", "value": g["r"], "source": g["src"]})
    params.append({"name": f"{name}_s0", "value": R(g["s0"]),
                   "source": "measured plateau start along the pin axis"})
    params.append({"name": f"{name}_s1", "value": R(g["s1"]),
                   "source": "measured plateau end along the pin axis"})
    prims = []
    if g["s1"] - g["s0"] > 1e-6:
        prims.append({"prim": "cylinder", "name": name,
                      "source": g["src"],
                      "p0": P(f"{name}_s0"), "p1": P(f"{name}_s1"),
                      "r": f"{name}_r"})
    if nxt is not None:
        prims.append({"prim": "cylinder", "name": f"{name}_blend",
                      "source": "measured transition between adjacent "
                                "station plateaus (frustum)",
                      "p0": P(f"{name}_s1"), "p1": P(f"{nxt_name}_s0"),
                      "r": f"{name}_r", "r2": f"{nxt_name}_r"})
    return prims


new_bodies = []
report = []
for bid in UNIQUE:
    pin = pin_semantics(bid)
    kids = []
    # cyclic profile coords: axis "x" -> (y,z); axis "y" -> (z,x) — the
    # circle-fit center components map accordingly (this once placed the
    # y-axis pins at swapped (x,z): measure, then check the overlay!)
    if pin["axis"] == "x":
        a_lat, a_z = pin["med"][0], pin["med"][1]      # (y, z)
        lat_name = "axis_y"
    else:
        a_z, a_lat = pin["med"][0], pin["med"][1]      # (z, x)
        lat_name = "axis_x"
    params = [
        {"name": lat_name, "value": R(a_lat),
         "source": "pin axis position (median of measured station centers, "
                   "std < 0.001)"},
        {"name": "axis_z", "value": R(a_z),
         "source": "pin axis height (median of measured station centers)"},
    ]
    for k, g in enumerate(pin["segs"]):
        nxt = pin["segs"][k + 1] if k + 1 < len(pin["segs"]) else None
        nxt_name = pin["names"][k + 1] if nxt else None
        kids += seg_cyl(pin, pin["names"][k], g, nxt, nxt_name, params)
    # head / off-axis stations: vectorized profile extrudes (hull between
    # consecutive stations preserves the measured taper)
    # head / rect stations: thin vectorized slabs HULLED pairwise, so the
    # measured tapers stay smooth (piecewise-constant steps cost ~230 mm3)
    def head_slab(i, tag):
        s, h = pin["prof"][i]
        segs2, nl, na, ne = vectorize(h["profile"])
        p2d = ({"path": segs2} if len(segs2) >= 2
               else {"poly": [[R(q[0]), R(q[1])] for q in h["profile"]]})
        return {"prim": "extrude", "axis": h.get("axis", "z"),
                "name": f"head_{i}{tag}",
                "source": f"head station (vectorized: {nl} lines + {na} arcs) — "
                          + h["source"],
                "profile2d": p2d, "z0": h["z0"], "z1": R(h["z0"] + 0.02)}
    for i in range(len(pin["prof"]) - 1):
        kids.append({"op": "hull", "children": [head_slab(i, "a"),
                                                head_slab(i + 1, "b")]})
    if len(pin["prof"]) == 1:
        kids.append(head_slab(0, ""))
    # bridge the head block to the revolve chain (the 0.4mm inter-station
    # gap was ~6 mm3 FN per pin): hull(edge head slab, thin disc at the
    # nearest plateau boundary)
    if pin["prof"] and pin["segs"]:
        ax = pin["axis"]
        p_lo, p_hi = pin["prof"][0][0], pin["prof"][-1][0]
        cands = []
        for k, g in enumerate(pin["segs"]):
            for pi, ps in ((0, p_lo), (-1, p_hi)):
                for key in ("s0", "s1"):
                    if 1e-6 < abs(g[key] - ps) < 1.0:
                        cands.append((abs(g[key] - ps), k, pi, key))
        done = set()
        for _, k, pi, key in sorted(cands):
            g = pin["segs"][k]
            if pi in done:
                continue
            done.add(pi)
            if True:
                if True:
                    if True:
                        nm = pin["names"][k]
                        disc = {"prim": "cylinder",
                                "name": f"{nm}_bridge{pi}_disc",
                                "source": "thin disc at the plateau boundary "
                                          "(bridges head block to the chain)",
                                "p0": ([f"{nm}_{key}", "axis_y", "axis_z"]
                                       if ax == "x" else
                                       ["axis_x", f"{nm}_{key}", "axis_z"]),
                                "p1": ([f"{nm}_{key} + 0.02", "axis_y", "axis_z"]
                                       if ax == "x" else
                                       ["axis_x", f"{nm}_{key} + 0.02",
                                        "axis_z"]),
                                "r": f"{nm}_r"}
                        kids.append({"op": "hull", "children": [
                            head_slab(pi, "bridge"), disc]})
    # bridge head block to the first on-axis segment when they are adjacent
    solid = {"op": "union", "children": kids}
    slab = exact_z_slab(bid)
    if slab and pin["segs"]:
        params.append({"name": "flat_z0", "value": R(slab[0]),
                       "source": "EXACT plane face (bottom flat) — pin "
                                 "sections are circles clipped by z flats"})
        params.append({"name": "flat_z1", "value": R(slab[1]),
                       "source": "EXACT plane face (top flat)"})
        s_lo = min(g["s0"] for g in pin["segs"]) - 12
        s_hi = max(g["s1"] for g in pin["segs"]) + 12
        lat0 = (pin["med"][0] if pin["axis"] == "x" else pin["med"][1])
        box = {"prim": "box", "name": "flat_slab",
               "source": "z-slab between the EXACT plane flats (vertex "
                         "circle-fits cannot see flats: all vertices lie on "
                         "the circle)",
               "min": [R(s_lo if pin["axis"] == "x" else lat0 - 12),
                       R(lat0 - 12 if pin["axis"] == "x" else s_lo),
                       "flat_z0"],
               "size": [R(s_hi - s_lo if pin["axis"] == "x" else 24),
                        R(24 if pin["axis"] == "x" else s_hi - s_lo),
                        "flat_z1 - flat_z0"]}
        solid = {"op": "intersection", "children": [solid, box]}
    cuts = []
    ci = 0
    def revec(n):
        global ci
        if "op" in n:
            return {**n, "children": [revec(c) for c in n["children"]]}
        if n.get("prim") == "extrude" and "profile" in n:
            ci += 1
            m = dict(n)
            prof_pts = m.pop("profile")
            # capsule/rect fits do NOT qualify (res 0.23-0.41 measured);
            # arc/line vectorization measured at ZERO IoU cost vs raw polys
            segs2, nl, na, ne = vectorize(prof_pts)
            m["profile2d"] = ({"path": segs2} if len(segs2) >= 2 else
                              {"poly": [[R(q[0]), R(q[1])] for q in prof_pts]})
            m["source"] = (f"vectorized cutter ({nl} lines + {na} arcs; "
                           f"capsule fit rejected, res 0.23-0.41) — "
                           + n["source"])
            return m
        return n
    for c in pin["cuts"]:
        cuts.append(revec(c))
    tree = ({"op": "difference", "children": [solid] + cuts}
            if cuts else solid)
    n_par = sum(1 for _ in pin["segs"])
    report.append(f"corpo {bid}: {len(pin['segs'])} segmentos "
                  f"({'/'.join(pin['names'])}), {len(pin['prof'])} estações "
                  f"de cabeça, {ci} cortadores vetorizados")
    mirror_note = ("; VERIFIED y-mirror of body 1 about y=-4.7474 (every "
                   "axis dim equal within 0.003) — kept own params: the plan "
                   "schema has no cross-body module refs"
                   if bid == 7 else "")
    new_bodies.append({
        "body_id": bid, "strategy": "csg",
        "params": params,
        "notes": mirror_note.lstrip("; ") + ("; " if mirror_note else "")
                 + "semantic parametric pin: measured station circles segmented "
                 "into named plateau cylinders (exact faces where they agree) "
                 "+ transition frustums; head stations and cutters vectorized; "
                 "engraved digit labels excluded by design — "
                 + pin["notes"][:120],
        "csg": tree})

for b in v1["bodies"]:
    if b["strategy"] == "instance_of":
        new_bodies.append(b)

plan = {"version": 1, "source": v1.get("source", ""), "bodies": new_bodies}
validate_plan(plan)
json.dump(plan, open(OUT / "plan.json", "w"), indent=1)
print("\n".join(report))
print(f"wrote {OUT/'plan.json'}")
