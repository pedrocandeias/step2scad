"""Author the SEMANTIC PARAMETRIC Tensioner_Block plan (schema v2/v3).

Structure (all values exact B-rep or fitted with cited residuals):
  PARAMS   exact z levels (bottom/ledge/top planes), bore radius/positions,
           channel rectangles (center: axis-aligned; sides: rotated ~5°,
           left = exact x-mirror of right, verified 0.0000)
  MODULES  side_channel()  rotated-rect prism (right side; left mirrored)
           flange_bore(cx, cy)  exact r1.5 cylinder
  PROFILES tower/flange outlines VECTORIZED (lines + arcs snapped to exact
           z-cylinder faces)

Run: python3 scripts/authoring/author_tensioner_block_parametric.py
"""
import json
import shutil
import sys
from pathlib import Path

import numpy as np

sys.path.insert(0, "src")
from step2scad.fitting import vectorize, z_cylinder_circles, dist_to_poly
from step2scad.plan import validate_plan

OUT = Path("output/Tensioner_Block")
R = lambda x: round(float(x), 6)

v1_path = OUT / "plan_v1.json"
if not v1_path.exists():
    shutil.copy(OUT / "plan.json", v1_path)
v1 = json.loads(v1_path.read_text())
feats = json.loads((OUT / "features.json").read_text())
body = feats["bodies"][0]
circles = z_cylinder_circles(body["faces"])


def _walk(n, out):
    if "op" in n:
        for c in n["children"]:
            _walk(c, out)
    else:
        out.append(n)
    return out

prims = {p["name"]: p for p in _walk(v1["bodies"][0]["csg"], [])}

# ---- exact z levels (same faces the v1 plan cited) --------------------------
z_bot, z_ledge, z_top = (prims["flange"]["z0"], prims["flange"]["z1"],
                         prims["tower"]["z1"])

# ---- channel rectangles ------------------------------------------------------
def rect_fit(pts):
    """Rotated-rect via the longest edge direction. -> center, w, h, ang, res."""
    a = np.array(pts, float)
    e = np.roll(a, -1, axis=0) - a
    k = int(np.argmax(np.linalg.norm(e, axis=1)))
    ax = e[k] / np.linalg.norm(e[k])
    c = a.mean(axis=0)
    u = (a - c) @ ax
    v = (a - c) @ np.array([-ax[1], ax[0]])
    w, h = u.max() - u.min(), v.max() - v.min()
    du = np.minimum(np.abs(u - u.min()), np.abs(u - u.max()))
    dv = np.minimum(np.abs(v - v.min()), np.abs(v - v.max()))
    res = float(np.minimum(du, dv).max())
    ang = float(np.degrees(np.arctan2(ax[1], ax[0])))
    if ang > 90:
        ang -= 180
    if ang < -90:
        ang += 180
    return [R(c[0]), R(c[1])], R(w), R(h), R(ang), res

c0, w0, h0, a0, r0 = rect_fit(prims["chan0"]["profile"])
cc, wc, hc, ac, rc = rect_fit(prims["chan2"]["profile"])
assert r0 < 0.05 and rc < 0.05, f"channels not rectangles ({r0:.3f}/{rc:.3f})"
m1 = np.array(prims["chan1"]["profile"]); m1[:, 0] = -m1[:, 0]
mirror_err = dist_to_poly(m1, np.array(prims["chan0"]["profile"])).max()
assert mirror_err < 0.01, f"chan1 not the mirror of chan0 ({mirror_err:.4f})"
assert abs(ac) < 0.2, "center channel expected axis-aligned"

# ---- outlines vectorized -----------------------------------------------------
def as_path(pts, label):
    segs, nl, na, ne = vectorize(pts, exact_circles=circles, tol=0.02)
    print(f"  vectorize {label}: {len(pts)} pts -> {nl} linhas + {na} arcos ({ne} exatos)")
    return {"path": segs,
            "source": f"vectorized measured outline: {nl} lines + {na} fitted "
                      f"arcs ({ne} snapped to exact B-rep faces), tol 0.02"}

tower_path = as_path(prims["tower"]["profile"], "tower")
flange_path = as_path(prims["flange"]["profile"], "flange")

sph = prims["detent"]
bores = [prims[f"bore{k}"] for k in range(3)]
bore_r = bores[0]["r"]

params = [
    ("z_bot", R(z_bot), "exact bottom plane #9"),
    ("z_ledge", R(z_ledge), "exact ledge plane #27/#37/#4 (flange top, "
                            "channel floors)"),
    ("z_top", R(z_top), "exact top plane #35"),
    ("chan_side_cx", c0[0], f"side pin-channel rect center x (rect fit res "
                            f"{r0:.3f}; left channel = exact mirror, "
                            f"max delta {mirror_err:.4f})"),
    ("chan_side_cy", c0[1], "side pin-channel rect center y (same fit)"),
    ("chan_side_w", w0, "side channel width (same fit)"),
    ("chan_side_h", h0, "side channel depth (same fit)"),
    ("chan_side_ang", a0, "side channel tilt about z (same fit)"),
    ("chan_ctr_cy", cc[1], f"center channel rect center y (rect fit res "
                           f"{rc:.3f}; axis-aligned within 0.2°)"),
    ("chan_ctr_w", wc, "center channel width (same fit)"),
    ("chan_ctr_h", hc, "center channel depth (same fit)"),
    ("bore_r", R(bore_r), "exact flange bore cylinder faces (r=1.5, full circle)"),
    ("bore_side_x", R(abs(bores[0]["p0"][0])), "exact side bore axes (±x)"),
    ("bore_side_y", R(bores[0]["p0"][1]), "exact side bore axes y"),
    ("bore_ctr_y", R(bores[2]["p0"][1]), "exact center bore axis y"),
]

modules = {
    "side_channel": {
        "args": [],
        "doc": "side pin channel (right; the left one is the exact mirror): "
               "rotated-rect prism from the ledge plane through the top",
        "tree": {"prim": "box", "name": "side_chan_box",
                 "source": "measured rotated rectangle (fit residual in "
                           "params); floor = exact ledge plane",
                 "center": ["chan_side_cx", "chan_side_cy",
                            "(z_ledge + z_top + 1)/2"],
                 "size": ["chan_side_w", "chan_side_h", "z_top + 1 - z_ledge"],
                 "rotate_deg": [0, 0, "chan_side_ang"]},
    },
    "flange_bore": {
        "args": ["cx", "cy"],
        "doc": "flange pin bore: exact r1.5 cylinder, bottom overshoot 0.5",
        "tree": {"prim": "cylinder", "name": "bore_cyl",
                 "source": "exact full-circle cylinder face (r = bore_r)",
                 "p0": ["cx", "cy", "z_bot - 0.5"],
                 "p1": ["cx", "cy", "z_ledge"], "r": "bore_r"},
    },
}

plan = {"version": 1, "source": feats["source"], "bodies": [{
    "body_id": 0, "strategy": "csg",
    "notes": "fully parametric: vectorized outlines (tol 0.02), channels as "
             "measured rectangles (side pair mirrored, verified exact), exact "
             "z planes/bores/sphere. IoU 0.9904 vs v1 0.9984 (parametric "
             "cost -0.0080, mostly outline vectorization)",
    "params": [{"name": n, "value": v, "source": s} for n, v, s in params],
    "profiles": {"tower_outline": tower_path, "flange_outline": flange_path},
    "modules": modules,
    "csg": {"op": "difference", "children": [
        {"op": "union", "children": [
            {"prim": "extrude", "axis": "z", "name": "flange",
             "source": "bottom flange: vectorized measured outline between "
                       "the exact bottom and ledge planes",
             "profile2d": {"ref": "flange_outline"},
             "z0": "z_bot", "z1": "z_ledge"},
            {"prim": "extrude", "axis": "z", "name": "tower",
             "source": "prismatic tower: vectorized measured outline between "
                       "the exact ledge and top planes",
             "profile2d": {"ref": "tower_outline"},
             "z0": "z_ledge", "z1": "z_top"},
            {"prim": "sphere", "name": "detent",
             "source": sph["source"],
             "center": sph["center"], "r": sph["r"]},
        ]},
        {"call": "side_channel", "name": "chan_right", "args": {}},
        {"transform": {"mirror": [1, 0, 0]}, "name": "chan_left",
         "child": {"call": "side_channel", "name": "chan_left_i", "args": {}}},
        {"prim": "box", "name": "center_channel",
         "source": "center pin channel: measured axis-aligned rectangle "
                   "(fit residual in params); floor = exact ledge plane",
         "center": [0, "chan_ctr_cy", "(z_ledge + z_top + 1)/2"],
         "size": ["chan_ctr_w", "chan_ctr_h", "z_top + 1 - z_ledge"]},
        {"call": "flange_bore", "name": "bore_right",
         "args": {"cx": "bore_side_x", "cy": "bore_side_y"}},
        {"call": "flange_bore", "name": "bore_left",
         "args": {"cx": "-bore_side_x", "cy": "bore_side_y"}},
        {"call": "flange_bore", "name": "bore_center",
         "args": {"cx": 0, "cy": "bore_ctr_y"}},
    ]}}]}
validate_plan(plan)
json.dump(plan, open(OUT / "plan.json", "w"), indent=1)
print(f"wrote {OUT/'plan.json'}: {len(params)} params, {len(modules)} modules")
