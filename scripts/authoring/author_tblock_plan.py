"""Author output/Tensioner_Block/plan.json.

STRATEGY: part is a z-prismatic tower (plan sections identical z=5..27.5) on a
bottom flange, so: flange extrude (measured outline @z=0.6) + tower extrude
(measured outer outline @z=15) + exact sphere boss, MINUS the three measured
pin-channel extrusions (inner loops @z=15) and the three exact r1.5 flange
bores. Exact z planes: bottom 0.001 (f9), ledge 1.2979 (f27/37/4), top 27.9996
(f35) — all from features.json.
"""
import json
import numpy as np
import sys
sys.path.insert(0, "src")
from step2scad.ingest import read_step, shape_to_trimesh

R = lambda x: round(float(x), 6)
feats = json.load(open("output/Tensioner_Block/features.json"))
b = feats["bodies"][0]
mesh = shape_to_trimesh(read_step("models/phoenix_components/Tensioner_Block.step"), linear_deflection=0.008)


def decimate(loop, tol=0.008):
    loop = [np.asarray(p, float) for p in loop]
    out = list(loop)
    changed = True
    while changed and len(out) > 8:
        changed = False
        for i in range(len(out)):
            a, bb, c = out[i - 1], out[i], out[(i + 1) % len(out)]
            ab = c - a
            n = np.linalg.norm(ab)
            if n < 1e-9:
                continue
            if abs(float(np.cross(ab, bb - a))) / n < tol:
                out.pop(i)
                changed = True
                break
    return [[R(p[0]), R(p[1])] for p in out]


def loops_at(z):
    sec = mesh.section(plane_origin=[0, 0, z], plane_normal=[0, 0, 1])
    loops = []
    for d in sec.discrete:
        pts = d[:, :2]
        if np.allclose(pts[0], pts[-1]):
            pts = pts[:-1]
        area = 0.5 * abs(np.sum(pts[:, 0] * np.roll(pts[:, 1], -1)
                                - np.roll(pts[:, 0], -1) * pts[:, 1]))
        loops.append((area, pts))
    loops.sort(key=lambda t: -t[0])
    return loops


tower_loops = loops_at(15.0)
outer_tower = decimate(tower_loops[0][1])
channels = [decimate(l[1], tol=0.008) for l in tower_loops[1:4]]
flange_loops = loops_at(0.6)
outer_flange = decimate(flange_loops[0][1])
print(f"tower outer: {len(outer_tower)} pts; channels: {[len(c) for c in channels]}; "
      f"flange outer: {len(outer_flange)} pts")

# exact z planes
z_bot, z_ledge, z_top = 0.001, 1.29785, 27.999635
# exact planes from features: recompute precisely
for f in b["faces"]:
    if f["type"] != "plane":
        continue
    n = np.asarray(f["params"]["normal"]); o = np.asarray(f["params"]["origin"])
    d = float(n @ o)
    if f["index"] == 9: z_bot = -d
    if f["index"] == 35: z_top = d
    if f["index"] == 27: z_ledge = d
sph = [f for f in b["faces"] if f["type"] == "sphere"][0]["params"]
bores = [f for f in b["faces"] if f["type"] == "cylinder"]

kids = [{
    "op": "union",
    "children": [
        {"prim": "extrude", "axis": "z", "name": "flange",
         "source": "bottom flange: measured plan outline at z=0.6; exact bottom "
                   "plane #9 (z=%s), exact ledge plane #27/#37/#4 (z=%s)" % (R(z_bot), R(z_ledge)),
         "profile": outer_flange, "z0": R(z_bot), "z1": R(z_ledge)},
        {"prim": "extrude", "axis": "z", "name": "tower",
         "source": "prismatic tower: measured plan outline at z=15 (sections "
                   "identical z=5..27.5); exact top plane #35",
         "profile": outer_tower, "z0": R(z_ledge), "z1": R(z_top)},
        {"prim": "sphere", "name": "detent",
         "source": "snap-detent boss: exact sphere face #0",
         "center": [R(v) for v in sph["center"]], "r": R(sph["radius"])},
    ]}]
for k, ch in enumerate(channels):
    kids.append({"prim": "extrude", "axis": "z", "name": f"chan{k}",
                 "source": "pin channel: measured inner loop at z=15 (prismatic); "
                           "starts exactly at the ledge plane",
                 "profile": ch, "z0": R(z_ledge), "z1": R(z_top + 1)})
for k, f in enumerate(bores):
    p = f["params"]
    kids.append({"prim": "cylinder", "name": f"bore{k}",
                 "source": f"flange pin bore: exact cylinder face #{f['index']} "
                           f"(r={R(p['radius'])}, full circle)",
                 "p0": [R(p["axis_origin"][0]), R(p["axis_origin"][1]), R(z_bot - 0.5)],
                 "p1": [R(p["axis_origin"][0]), R(p["axis_origin"][1]), R(z_ledge)],
                 "r": R(p["radius"])})

plan = {"version": 1, "source": feats["source"], "bodies": [{
    "body_id": 0, "strategy": "csg",
    "notes": "prismatic tower + flange (measured outlines) + exact sphere detent, "
             "minus 3 prismatic pin channels + 3 exact flange bores",
    "csg": {"op": "difference", "children": kids}}]}
json.dump(plan, open("output/Tensioner_Block/plan.json", "w"), indent=1)
print("wrote output/Tensioner_Block/plan.json; z_bot", z_bot, "ledge", z_ledge, "top", z_top)
