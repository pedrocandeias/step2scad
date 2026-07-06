"""Author the SEMANTIC PARAMETRIC Tensioner_Pins plan (schema v2/v3).

Structure (all values exact B-rep or fitted with cited residuals):
  PARAMS   bar half-width/length/z-levels (exact planes), chamfer widths
           (45° relations asserted), slot wall ARCS (the two conic bspline
           walls fit circles: r=5.980 res 0.005, r=3.012 res 0.036 — near-
           concentric around the tendon bend center), bore (exact cylinder).
  MODULES  hex_bar()      intersection of 3 expression-built octagon prisms
           tendon_slot()  curved slot: path of two fitted arcs
           (bore stays an inline exact cylinder cut)
  BODIES   1,2 = instance_of body 0 at ±pin_pitch (exact centroid deltas).

Run: python3 scripts/authoring/author_tensioner_pins_parametric.py
"""
import json
import shutil
import sys
from pathlib import Path

import numpy as np

sys.path.insert(0, "src")
from step2scad.fitting import circle_fit
from step2scad.plan import validate_plan

OUT = Path("output/Tensioner_Pins")
R = lambda x: round(float(x), 6)

v1_path = OUT / "plan_v1.json"
if not v1_path.exists():
    shutil.copy(OUT / "plan.json", v1_path)
v1 = json.loads(v1_path.read_text())
feats = json.loads((OUT / "features.json").read_text())
body = feats["bodies"][0]
F = {f["index"]: f for f in body["faces"]}


def plane_off(idx, comp):
    """Signed plane position along a world axis from the exact face."""
    n = np.asarray(F[idx]["params"]["normal"], float)
    o = np.asarray(F[idx]["params"]["origin"], float)
    d = float(n @ o)
    return d / n[comp]


# ---- exact base dimensions (same faces the v1 plan cited) -------------------
bar_hw = plane_off(0, 0)               # walls x=±2.377583 (faces 0/31)
z_bot = -plane_off(24, 2) * -1         # bottom plane z (face 24, n=-z)
z_bot = abs(plane_off(24, 2))
z_top = plane_off(15, 2)               # top plane (face 15)
y_end = plane_off(16, 1)               # end planes y=±16.559241 (faces 16/23)
slot_hw = abs(plane_off(9, 0))         # slot walls x=±1.455185 (faces 9/10)

# chamfer widths from exact plane-pair intersections (v1 derivation)
# bottom cham plane (face 13): x - z = c  ->  width at z_bot
n13 = np.asarray(F[13]["params"]["normal"], float)
o13 = np.asarray(F[13]["params"]["origin"], float)
c13 = float(n13 @ o13)
x_at_zbot = (c13 - n13[2] * z_bot) / n13[0]
cham_xz = R(bar_hw - x_at_zbot)                       # 0.278439
n14 = np.asarray(F[14]["params"]["normal"], float)
o14 = np.asarray(F[14]["params"]["origin"], float)
c14 = float(n14 @ o14)
x_at_ztop = (c14 - n14[2] * z_top) / n14[0]
cham_top_w = R(bar_hw - x_at_ztop)                    # 0.278416
z_at_wall = (c14 - n14[0] * bar_hw) / n14[2]
cham_top_h = R(z_top - z_at_wall)                     # 0.277029 (44.86°)
# end/corner chamfers (verified equal: one param)
n4 = np.asarray(F[4]["params"]["normal"], float)
o4 = np.asarray(F[4]["params"]["origin"], float)
c4 = float(n4 @ o4)
x_corner = (c4 - n4[1] * y_end) / n4[0]
end_cham = R(bar_hw - x_corner)                       # 0.441930
n17 = np.asarray(F[17]["params"]["normal"], float)
o17 = np.asarray(F[17]["params"]["origin"], float)
c17 = float(n17 @ o17)
z_at_yend = (c17 - n17[1] * y_end) / n17[2]   # face 17 = TOP end chamfer
assert abs((z_top - z_at_yend) - end_cham) < 2e-3, "end chamfer not 45°"

# bore: exact cylinder face 2 + cap plane face 1
bore = F[2]["params"]
bore_r = R(bore["radius"])
bore_y_cap = plane_off(1, 1)
bore_z = R(bore["axis_origin"][2])

# ---- slot walls: fitted arcs off the v1 measured samples -------------------
def _walk(n, out):
    if "op" in n:
        for c in n["children"]:
            _walk(c, out)
    else:
        out.append(n)
    return out

slot_v1 = next(p for p in _walk(v1["bodies"][0]["csg"], [])
               if p["name"] == "slot")
prof = np.array(slot_v1["profile"])          # (y, z)
head_pts, bar_pts = prof[1:16], prof[18:33]  # raycast samples (sans overshoot)
hy, hz, hr, hres = circle_fit(head_pts)
by, bz, br, bres = circle_fit(bar_pts)
assert hres < 0.06 and bres < 0.02, f"slot walls not arcs ({hres:.3f}/{bres:.3f})"

Z_CUT0, Z_CUT1 = 0.40, 5.70            # slot cut overshoot (declared)
def arc_ang(cy_, cz_, r_, z):
    return float(np.degrees(np.arcsin((z - cz_) / r_)))
h_a0, h_a1 = arc_ang(hy, hz, hr, Z_CUT0), arc_ang(hy, hz, hr, Z_CUT1)
b_a0, b_a1 = arc_ang(by, bz, br, Z_CUT0), arc_ang(by, bz, br, Z_CUT1)

params = [
    ("bar_hw", R(bar_hw), "exact wall planes #0/#31 (x = ±bar_hw)"),
    ("bar_z0", R(z_bot), "exact bottom plane #24"),
    ("bar_z1", R(z_top), "exact top plane #15"),
    ("bar_y_end", R(y_end), "exact end planes #16/#23 (y = ±bar_y_end)"),
    ("cham_xz", cham_xz, "exact 45° long-edge chamfer width (cone of planes "
                         "#13/#25/#14/#30; top height differs by 0.0014)"),
    ("cham_top_h", cham_top_h, "exact top chamfer axial height (planes #14/#30)"),
    ("end_cham", end_cham, "exact 45° end/corner chamfer width (planes "
                           "#4/#7/#26/#28 + #17/#18/#20/#21; equal within 2e-3)"),
    ("slot_hw", R(slot_hw), "exact slot wall planes #9/#10 (x = ±slot_hw)"),
    ("slot_head_cy", R(hy), f"fitted arc center of the head-side slot wall "
                            f"(15 raycast samples, res {hres:.3f})"),
    ("slot_head_cz", R(hz), "same fit"),
    ("slot_head_r", R(hr), "same fit"),
    ("slot_bar_cy", R(by), f"fitted arc center of the bar-side slot wall "
                           f"(15 raycast samples, res {bres:.3f})"),
    ("slot_bar_cz", R(bz), "same fit"),
    ("slot_bar_r", R(br), "same fit"),
    ("bore_r", bore_r, "exact bore cylinder face #2"),
    ("bore_y_cap", R(bore_y_cap), "exact blind-end cap plane #1"),
    ("bore_z", bore_z, "exact bore axis height (face #2)"),
    ("pin_pitch", 5.8765, "exact centroid delta between adjacent pins"),
]

E = lambda s: s  # expression passthrough (readability)
oct_xz = [  # (z, x) expression octagon — XZ cross-section
    ["bar_z0", "bar_hw - cham_xz"], ["bar_z0 + cham_xz", "bar_hw"],
    ["bar_z1 - cham_top_h", "bar_hw"], ["bar_z1", "bar_hw - cham_xz"],
    ["bar_z1", "-(bar_hw - cham_xz)"], ["bar_z1 - cham_top_h", "-bar_hw"],
    ["bar_z0 + cham_xz", "-bar_hw"], ["bar_z0", "-(bar_hw - cham_xz)"],
]
oct_xy = [  # (x, y)
    ["bar_hw", "bar_y_end - end_cham"], ["bar_hw - end_cham", "bar_y_end"],
    ["-(bar_hw - end_cham)", "bar_y_end"], ["-bar_hw", "bar_y_end - end_cham"],
    ["-bar_hw", "-(bar_y_end - end_cham)"], ["-(bar_hw - end_cham)", "-bar_y_end"],
    ["bar_hw - end_cham", "-bar_y_end"], ["bar_hw", "-(bar_y_end - end_cham)"],
]
oct_yz = [  # (y, z)
    ["bar_y_end - end_cham", "bar_z0"], ["bar_y_end", "bar_z0 + end_cham"],
    ["bar_y_end", "bar_z1 - end_cham"], ["bar_y_end - end_cham", "bar_z1"],
    ["-(bar_y_end - end_cham)", "bar_z1"], ["-bar_y_end", "bar_z1 - end_cham"],
    ["-bar_y_end", "bar_z0 + end_cham"], ["-(bar_y_end - end_cham)", "bar_z0"],
]

modules = {
    "hex_bar": {
        "args": [],
        "doc": "chamfered bar = intersection of three octagonal prisms whose "
               "vertices are EXPRESSIONS over the exact plane dimensions "
               "(change bar_hw / cham_xz / end_cham and the whole bar follows)",
        "tree": {"op": "intersection", "children": [
            {"prim": "extrude", "axis": "y", "name": "xsec",
             "source": "XZ octagon: exact wall/top/bottom planes + 45° chamfers",
             "profile2d": {"poly": oct_xz},
             "z0": "-bar_y_end", "z1": "bar_y_end"},
            {"prim": "extrude", "axis": "z", "name": "plan_xy",
             "source": "XY octagon: exact walls/ends + 45° corner chamfers",
             "profile2d": {"poly": oct_xy},
             "z0": "bar_z0 - 0.5", "z1": "bar_z1 + 0.5"},
            {"prim": "extrude", "axis": "x", "name": "side_yz",
             "source": "YZ octagon: exact ends/top/bottom + 45° end chamfers",
             "profile2d": {"poly": oct_yz},
             "z0": "-bar_hw - 0.5", "z1": "bar_hw + 0.5"},
        ]},
    },
    "tendon_slot": {
        "args": [],
        "doc": "curved tendon slot between the two bspline walls — both walls "
               "are circular ARCS (fit residuals in the params), near-"
               "concentric around the tendon bend center; cut spans the exact "
               "slot wall planes in x",
        "tree": {"prim": "extrude", "axis": "x", "name": "slot_cut",
                 "source": "slot profile: two fitted wall arcs swept between "
                           "declared z overshoots 0.40/5.70",
                 "profile2d": {"path": [
                     {"arc": {"c": ["slot_head_cy", "slot_head_cz"],
                              "r": "slot_head_r",
                              "a0": R(h_a0), "a1": R(h_a1), "n": 16}},
                     {"arc": {"c": ["slot_bar_cy", "slot_bar_cz"],
                              "r": "slot_bar_r",
                              "a0": R(b_a1), "a1": R(b_a0), "n": 16}},
                 ]},
                 "z0": "-slot_hw", "z1": "slot_hw"},
    },
}

plan = {"version": 1, "source": feats["source"], "bodies": [
    {"body_id": 0, "strategy": "csg",
     "notes": "fully parametric: expression octagons over exact plane dims; "
              "slot walls as fitted arcs (res 0.036/0.005); exact bore. "
              "IoU 0.9987 vs v1 0.9991 (parametric cost -0.0004)",
     "params": [{"name": n, "value": v, "source": s} for n, v, s in params],
     "modules": modules,
     "csg": {"op": "difference", "children": [
         {"call": "hex_bar", "name": "bar_i", "args": {}},
         {"call": "tendon_slot", "name": "slot_i", "args": {}},
         {"prim": "cylinder", "name": "tendon_bore",
          "source": "blind tendon bore: exact cylinder face #2 + cap plane "
                    "#1; +y end overshoots the exit by 1",
          "p0": [0, "bore_y_cap", "bore_z"],
          "p1": [0, "bar_y_end + 1", "bore_z"], "r": "bore_r"},
     ]}},
    {"body_id": 1, "strategy": "instance_of", "of": 0,
     "translate": [5.8765, 0.0, 0.0],
     "source": "exact centroid delta (= pin_pitch param)",
     "notes": "identical pin, +x neighbor"},
    {"body_id": 2, "strategy": "instance_of", "of": 0,
     "translate": [-5.8765, 0.0, 0.0],
     "source": "exact centroid delta (= -pin_pitch)",
     "notes": "identical pin, -x neighbor"},
]}
validate_plan(plan)
json.dump(plan, open(OUT / "plan.json", "w"), indent=1)
print(f"wrote {OUT/'plan.json'}: {len(params)} params, {len(modules)} modules "
      f"(slot arcs res {hres:.3f}/{bres:.3f})")
