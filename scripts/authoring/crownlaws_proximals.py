"""Crown stage: replace the Proximals measured crown loft with LAW-SOLIDS.

Decomposition in the style of the hand-tuned template
(openscad-parametric-reconstructor/templates/Proximals.scad), every value
MEASURED (residuals cited):

    crown = ( hull(4 vectorized control slabs)      # tapered body envelope
              INTERSECT dome_clip                   # lengthwise ceiling arc
                (box - x-axis cylinder: the arc's center sits ABOVE the part,
                 so the ceiling is the circle's LOWER branch)
            ) - scoop_rear - scoop_front            # underside sweep-ups
            + fin_lip                               # rear clip lip (sloped top)

The hull + scoop pair reconstructs the underside by construction: the hull
bridges below the real shelf and the measured scoop cylinder carves exactly
that bridge back off.

Runs AFTER author_proximals_parametric.py (consumes output/Proximals/plan.json,
patches body 3 in place; bodies 0/1/4 follow via instance_of).
"""
import json
import shutil
import sys
from pathlib import Path

import numpy as np
import trimesh
from scipy.spatial import ConvexHull

sys.path.insert(0, "src")
from step2scad.fitting import circle_fit, line_fit, vectorize
from step2scad.plan import validate_plan

OUT = Path("output/Proximals")
FIN_X = (0.4, 3.4)           # rear-lip x window (measured @y=-6: [0.351, 3.342])
BEAM = (-0.74943, 4.45057)
SLAB_YS = (-8.0, -3.4, 3.4, 6.82)
CROWN_Y = (-8.040772, 6.87)  # exact plane levels of the crown region (from v1)
R = lambda v: round(float(v), 6)

mesh = trimesh.load(OUT / "body3_ref.stl", force="mesh")


def allpts(y):
    s = mesh.section(plane_origin=[0, y, 0], plane_normal=[0, 1, 0])
    return np.vstack([L[:, [0, 2]] for L in s.discrete])


# ---- 1. dome ceiling: max z outside the fin window, arc fit in (y,z) -------
dome = []
for y in np.arange(-7.9, 6.85, 0.25):
    P = allpts(round(y, 3))
    out = P[(P[:, 0] < FIN_X[0]) | (P[:, 0] > FIN_X[1])]
    dome.append((y, out[:, 1].max()))
dome = np.array(dome)
dome_cy, dome_cz, dome_r, dome_res = circle_fit(dome)
assert dome_res < 0.35, f"dome arc res {dome_res:.3f}"
def dome_z(y):
    return dome_cz - np.sqrt(dome_r**2 - (y - dome_cy)**2)   # lower branch

# ---- 2. rear fin lip: linear top law where the lip rises above the dome ----
fin = []
for y in np.arange(-7.9, -4.0, 0.15):
    P = allpts(round(y, 3))
    inw = P[(P[:, 0] > FIN_X[0]) & (P[:, 0] < FIN_X[1])]
    if len(inw) and inw[:, 1].max() > dome_z(y) + 0.15:
        fin.append((y, inw[:, 1].max()))
fin = np.array(fin)
fin_m, fin_b, fin_res = line_fit(fin[:, 0], fin[:, 1])
assert fin_res < 0.15, f"fin lip line res {fin_res:.3f}"

# ---- 3. underside scoops: shelf height under the wings, circle in (y,z) ----
def shelf_pts(y_range):
    pts = []
    for y in y_range:
        P = allpts(round(y, 3))
        w = P[P[:, 0] < BEAM[0] - 0.4]
        if len(w) and w[:, 1].min() > 0.05:
            pts.append((y, w[:, 1].min()))
    return np.array(pts)

rear = shelf_pts(np.arange(-7.9, -3.9, 0.2))
front = shelf_pts(np.arange(3.7, 6.85, 0.2))
sc_r = circle_fit(rear)
sc_f = circle_fit(front)
assert sc_r[3] < 0.35 and sc_f[3] < 0.05, f"scoop res {sc_r[3]:.3f}/{sc_f[3]:.3f}"

# ---- 4. control slabs: convex-hull sections (fin excluded), vectorized -----
def ctrl_path(y):
    P = allpts(round(y, 3))
    keep = P[(P[:, 0] < FIN_X[0]) | (P[:, 0] > FIN_X[1])
             | (P[:, 1] < dome_z(y) - 0.1)]
    hull = ConvexHull(keep)
    prof = keep[hull.vertices][:, [1, 0]]            # (z, x) for axis-y extrude
    segs, nl, na, _ = vectorize(prof, tol=0.05)
    return segs, nl, na

slabs = {}
for y in SLAB_YS:
    slabs[y], nl, na = ctrl_path(y)
    print(f"  fatia de controlo y={y}: {nl} linhas + {na} arcos")

print(f"  domo r={dome_r:.2f} c=(y={dome_cy:.2f},z={dome_cz:.2f}) res={dome_res:.3f}")
print(f"  scoop tras r={sc_r[2]:.2f} c=({sc_r[0]:.2f},{sc_r[1]:.2f}) res={sc_r[3]:.3f}"
      f" | frente r={sc_f[2]:.2f} c=({sc_f[0]:.2f},{sc_f[1]:.2f}) res={sc_f[3]:.3f}")
print(f"  pala: z={fin_m:.4f}*y+{fin_b:.3f} res={fin_res:.3f}"
      f" ({np.degrees(np.arctan(fin_m)):.1f} deg)")

# ---- 5. patch the plan ------------------------------------------------------
plan = json.loads((OUT / "plan.json").read_text())
shutil.copy(OUT / "plan.json", OUT / "plan_pre_crownlaws.json")
e3 = [b for b in plan["bodies"] if b["body_id"] == 3][0]

params = e3.setdefault("params", [])
params += [
    {"name": "dome_r", "value": R(dome_r),
     "source": f"lengthwise ceiling arc radius (fit over 60 stations, res {dome_res:.3f}; "
               "the hand-tuned template guessed 60)"},
    {"name": "dome_cy", "value": R(dome_cy), "source": "ceiling arc center y (same fit)"},
    {"name": "dome_cz", "value": R(dome_cz),
     "source": "ceiling arc center z — ABOVE the part: the ceiling is the circle's lower branch"},
    {"name": "scoop_rear_r", "value": R(sc_r[2]),
     "source": f"rear underside scoop cylinder (x-axis) radius: circle fit to the wing shelf "
               f"heights, res {sc_r[3]:.3f} (template: 13.7 hand-tuned)"},
    {"name": "scoop_rear_cy", "value": R(sc_r[0]), "source": "rear scoop center y (same fit)"},
    {"name": "scoop_rear_cz", "value": R(sc_r[1]), "source": "rear scoop center z (same fit)"},
    {"name": "scoop_front_r", "value": R(sc_f[2]),
     "source": f"front underside scoop radius, res {sc_f[3]:.3f} — nearly exact circle; "
               "the real part is asymmetric (template reused 13.7 on both ends)"},
    {"name": "scoop_front_cy", "value": R(sc_f[0]), "source": "front scoop center y (same fit)"},
    {"name": "scoop_front_cz", "value": R(sc_f[1]), "source": "front scoop center z (same fit)"},
    {"name": "fin_top_m", "value": R(fin_m),
     "source": f"rear clip-lip top slope (linear fit res {fin_res:.3f}; -6.4 deg — the "
               "template hand-tuned -6.0)"},
    {"name": "fin_top_b", "value": R(fin_b), "source": "rear clip-lip top intercept (same fit)"},
]

def slab_node(y, i):
    return {"prim": "extrude", "axis": "y", "name": f"crown_ctrl_{i}",
            "source": f"parametric CONTROL section at y={y} (convex hull of the measured "
                      "section, fin excluded, vectorized lines+arcs tol 0.05)",
            "profile2d": {"path": slabs[y]},
            "z0": R(y), "z1": R(y + 0.02)}

crown_new = {"op": "union", "children": [
    {"op": "difference", "children": [
        {"op": "intersection", "children": [
            {"op": "hull", "children": [slab_node(y, i) for i, y in enumerate(SLAB_YS)]},
            {"op": "difference", "children": [
                {"prim": "box", "name": "dome_below",
                 "source": "everything below the ceiling-arc center plane",
                 "min": [-10, -12, -1], "size": [22, 24, "dome_cz + 1"]},
                {"prim": "cylinder", "name": "dome_arc",
                 "source": "lengthwise ceiling: x-axis cylinder, LOWER branch "
                           "(center above the part) — residual in dome_r param",
                 "p0": [-10, "dome_cy", "dome_cz"], "p1": [12, "dome_cy", "dome_cz"],
                 "r": "dome_r"},
            ]},
        ]},
        {"prim": "cylinder", "name": "scoop_rear",
         "source": "rear underside scoop: measured x-axis cylinder (see scoop_rear_* params)",
         "p0": [-10, "scoop_rear_cy", "scoop_rear_cz"],
         "p1": [12, "scoop_rear_cy", "scoop_rear_cz"], "r": "scoop_rear_r"},
        {"prim": "cylinder", "name": "scoop_front",
         "source": "front underside scoop: measured x-axis cylinder (see scoop_front_* params)",
         "p0": [-10, "scoop_front_cy", "scoop_front_cz"],
         "p1": [12, "scoop_front_cy", "scoop_front_cz"], "r": "scoop_front_r"},
    ]},
    {"prim": "sweep", "axis": "y", "name": "fin_lip",
     "source": "rear clip lip: measured x-window, sloped top law (fin_top_* params)",
     "u0": 0.351, "u1": 3.342, "s0": R(CROWN_Y[0]), "s1": -4.55,
     "z0": 13.4, "h_max": 15.9, "steps": 8,
     "law": {"kind": "linear", "m": "fin_top_m", "b": "fin_top_b"}},
]}

sub = e3["csg"]["children"][0]["children"]
assert sub[3].get("op") == "union", "unexpected crown subtree"
sub[3] = crown_new
e3["notes"] = (e3.get("notes", "") +
               " | crown REPLACED by law-solids (template-style): hull of 4 vectorized "
               "control slabs INTERSECT measured ceiling arc MINUS measured underside "
               "scoops PLUS sloped fin lip — every law fitted with residual cited")

validate_plan(plan)
(OUT / "plan.json").write_text(json.dumps(plan, indent=1))
print("plan.json patched (crown law-solids); backup em plan_pre_crownlaws.json")
