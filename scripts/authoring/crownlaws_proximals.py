"""Crown stage: replace the Proximals measured crown lofts with LAW-SOLIDS.

Decomposition in the style of the hand-tuned template
(openscad-parametric-reconstructor/templates/Proximals.scad), every value
MEASURED per body (residuals cited):

    crown = ( hull(control slabs, vectorized)       # tapered body envelope
              INTERSECT dome_clip                   # lengthwise ceiling arc
                (box - x-axis cylinder: the arc's center sits ABOVE the part,
                 so the ceiling is the circle's LOWER branch)
            ) - scoop_rear - scoop_front            # underside sweep-ups
            [+ fin_lip]                             # rear clip lip (body 3 only)

Per-body: body 3 = master finger (bodies 0/1/4 follow via instance_of);
body 2 = thumb, with its OWN measured laws (different dome/scoops; its ridge
sits distal of the crown region, so no fin-lip term). Control slabs for the
thumb are AUTO-SELECTED by support-function decimation (fitting.
decimate_stations); body 3 keeps the pilot's validated picks.

Runs AFTER author_proximals_parametric.py (consumes output/Proximals/plan.json,
patches the bodies in place).
"""
import json
import shutil
import sys
from pathlib import Path

import numpy as np
import trimesh
from scipy.spatial import ConvexHull

sys.path.insert(0, "src")
from step2scad.fitting import circle_fit, decimate_stations, line_fit, vectorize
from step2scad.plan import validate_plan

OUT = Path("output/Proximals")
R = lambda v: round(float(v), 6)

CONFIGS = [
    {   # master finger (pilot-validated constants)
        "body_id": 3, "mesh": "body3_ref.stl",
        "fin_x": (0.4, 3.4),          # rear-lip x window (measured @y=-6)
        "wings": [("lt", -0.74943 - 0.4)],   # shelf side(s): x < beam wall
        "crown_y": (-8.040772, 6.87),
        "slab_ys": (-8.0, -3.4, 3.4, 6.82),  # pilot picks (validated)
        "scoop_y": ((-7.9, -3.9), (3.7, 6.85)),  # pilot fit windows
        "scoop_tols": (0.35, 0.05),
        "fin_lip": {"u0": 0.351, "u1": 3.342, "s1": -4.55,
                    "z0": 13.4, "h_max": 15.9,
                    "sample_y": (-7.9, -4.0)},   # pilot-validated window
        "dome_x": (-10, 12), "dome_box": [-10, -12, -1, 22, 24],
    },
    {   # thumb: own anatomy, own measured laws
        "body_id": 2, "mesh": "body2_ref.stl",
        "fin_x": None,                # ridge sits distal of the crown region
        "wings": [("lt", -30.00011 - 0.4), ("gt", -24.80011 + 0.4)],
        "crown_y": (-7.372351, 7.538651),
        "slab_ys": None,              # auto-select by decimation (tol 0.30)
        # windows where the shelf is the scoop arc (beyond -3.9 the rear
        # shelf leaves the circle: fit res 0.011 inside vs 0.378 with the
        # polluted full window)
        "scoop_y": ((-7.3, -3.9), (0.1, 7.4)),
        "scoop_tols": (0.05, 0.05),   # both thumb scoops are near-exact circles
        "fin_lip": None,
        "dome_x": (-36, -19), "dome_box": [-36, -12, -1, 18, 24],
    },
]


def crownlaws(cfg, plan):
    bid = cfg["body_id"]
    mesh = trimesh.load(OUT / cfg["mesh"], force="mesh")
    y0, y1 = cfg["crown_y"]
    fin_x = cfg["fin_x"]

    def allpts(y):
        s = mesh.section(plane_origin=[0, y, 0], plane_normal=[0, 1, 0])
        return np.vstack([L[:, [0, 2]] for L in s.discrete])

    def outside_fin(P):
        if fin_x is None:
            return P
        return P[(P[:, 0] < fin_x[0]) | (P[:, 0] > fin_x[1])]

    # ---- 1. dome ceiling: max z per station, arc fit in (y,z) --------------
    dome = []
    for y in np.arange(y0 + 0.1, y1 - 0.02, 0.25):
        P = outside_fin(allpts(round(y, 3)))
        dome.append((y, P[:, 1].max()))
    dome = np.array(dome)
    dome_cy, dome_cz, dome_r, dome_res = circle_fit(dome)
    assert dome_res < 0.35, f"body {bid}: dome arc res {dome_res:.3f}"
    assert dome_cz > dome[:, 1].max(), f"body {bid}: dome center not above part"

    def dome_z(y):
        return dome_cz - np.sqrt(dome_r**2 - (y - dome_cy)**2)  # lower branch

    # ---- 2. optional rear fin lip: linear top law above the dome -----------
    fin_fit = None
    if cfg["fin_lip"] is not None:
        fin = []
        sy0, sy1 = cfg["fin_lip"]["sample_y"]
        for y in np.arange(sy0, sy1, 0.15):
            P = allpts(round(y, 3))
            inw = P[(P[:, 0] > fin_x[0]) & (P[:, 0] < fin_x[1])]
            if len(inw) and inw[:, 1].max() > dome_z(y) + 0.15:
                fin.append((y, inw[:, 1].max()))
        fin = np.array(fin)
        fin_m, fin_b, fin_res = line_fit(fin[:, 0], fin[:, 1])
        assert fin_res < 0.15, f"body {bid}: fin lip line res {fin_res:.3f}"
        fin_fit = (fin_m, fin_b, fin_res)

    # ---- 3. underside scoops: wing shelf heights, circle fits in (y,z) -----
    def shelf_pts(y_range):
        pts = []
        for y in y_range:
            P = allpts(round(y, 3))
            for side, lim in cfg["wings"]:
                w = P[P[:, 0] < lim] if side == "lt" else P[P[:, 0] > lim]
                if len(w) and w[:, 1].min() > 0.05:
                    pts.append((y, w[:, 1].min()))
        return np.array(pts)

    (ry0, ry1), (fy0, fy1) = cfg["scoop_y"]
    rear = shelf_pts(np.arange(ry0, ry1, 0.2))
    front = shelf_pts(np.arange(fy0, fy1, 0.2))
    rear = rear[rear[:, 1] > 0.05]
    front = front[front[:, 1] > 0.05]
    sc_r = circle_fit(rear)
    sc_f = circle_fit(front)
    tol_r, tol_f = cfg["scoop_tols"]
    assert sc_r[3] < tol_r and sc_f[3] < tol_f, \
        f"body {bid}: scoop res {sc_r[3]:.3f}/{sc_f[3]:.3f}"

    # ---- 4. control slabs: convex sections, decimated + vectorized ---------
    def ctrl_profile(y):
        P = allpts(round(y, 3))
        if fin_x is not None:
            P = P[(P[:, 0] < fin_x[0]) | (P[:, 0] > fin_x[1])
                  | (P[:, 1] < dome_z(y) - 0.1)]
        hull = ConvexHull(P)
        return P[hull.vertices][:, [1, 0]]           # (z, x) for axis-y extrude

    if cfg["slab_ys"] is None:
        cand = [round(y, 3) for y in np.arange(y0 + 0.03, y1 - 0.02, 0.4)]
        kept, derr = decimate_stations(
            [(y, ctrl_profile(y)) for y in cand], tol=0.30)
        slab_ys = [cand[k] for k in kept]
        print(f"  body {bid}: fatias de controlo auto-selecionadas "
              f"({len(cand)} candidatas -> {len(slab_ys)}, erro interp. "
              f"máx {derr:.3f} <= 0.30): {slab_ys}")
    else:
        slab_ys = list(cfg["slab_ys"])

    slabs = {}
    for y in slab_ys:
        segs, nl, na, _ = vectorize(ctrl_profile(y), tol=0.05)
        slabs[y] = segs
        print(f"  body {bid}: fatia y={y}: {nl} linhas + {na} arcos")

    print(f"  body {bid}: domo r={dome_r:.2f} c=(y={dome_cy:.2f},z={dome_cz:.2f})"
          f" res={dome_res:.3f}")
    print(f"  body {bid}: scoop tras r={sc_r[2]:.2f} c=({sc_r[0]:.2f},{sc_r[1]:.2f})"
          f" res={sc_r[3]:.3f} | frente r={sc_f[2]:.2f} c=({sc_f[0]:.2f},"
          f"{sc_f[1]:.2f}) res={sc_f[3]:.3f}")
    if fin_fit:
        print(f"  body {bid}: pala z={fin_fit[0]:.4f}*y+{fin_fit[1]:.3f} "
              f"res={fin_fit[2]:.3f} ({np.degrees(np.arctan(fin_fit[0])):.1f} deg)")

    # ---- 5. patch the plan --------------------------------------------------
    entry = [b for b in plan["bodies"] if b["body_id"] == bid][0]
    params = entry.setdefault("params", [])
    params += [
        {"name": "dome_r", "value": R(dome_r),
         "source": f"lengthwise ceiling arc radius (fit over {len(dome)} "
                   f"stations, res {dome_res:.3f})"},
        {"name": "dome_cy", "value": R(dome_cy),
         "source": "ceiling arc center y (same fit)"},
        {"name": "dome_cz", "value": R(dome_cz),
         "source": "ceiling arc center z — ABOVE the part: the ceiling is "
                   "the circle's lower branch"},
        {"name": "scoop_rear_r", "value": R(sc_r[2]),
         "source": f"rear underside scoop cylinder (x-axis) radius: circle "
                   f"fit to the wing shelf heights, res {sc_r[3]:.3f}"},
        {"name": "scoop_rear_cy", "value": R(sc_r[0]),
         "source": "rear scoop center y (same fit)"},
        {"name": "scoop_rear_cz", "value": R(sc_r[1]),
         "source": "rear scoop center z (same fit)"},
        {"name": "scoop_front_r", "value": R(sc_f[2]),
         "source": f"front underside scoop radius, res {sc_f[3]:.3f} — "
                   "nearly exact circle"},
        {"name": "scoop_front_cy", "value": R(sc_f[0]),
         "source": "front scoop center y (same fit)"},
        {"name": "scoop_front_cz", "value": R(sc_f[1]),
         "source": "front scoop center z (same fit)"},
    ]
    if fin_fit:
        params += [
            {"name": "fin_top_m", "value": R(fin_fit[0]),
             "source": f"rear clip-lip top slope (linear fit res {fin_fit[2]:.3f})"},
            {"name": "fin_top_b", "value": R(fin_fit[1]),
             "source": "rear clip-lip top intercept (same fit)"},
        ]

    dx0, dx1 = cfg["dome_x"]
    bx, by, bz, bw, bl = cfg["dome_box"]

    def slab_node(y, i):
        return {"prim": "extrude", "axis": "y", "name": f"crown_ctrl_{i}",
                "source": f"parametric CONTROL section at y={y} (convex hull "
                          "of the measured section, vectorized lines+arcs "
                          "tol 0.05)",
                "profile2d": {"path": slabs[y]},
                "z0": R(y), "z1": R(y + 0.02)}

    crown_new_children = [
        {"op": "difference", "children": [
            {"op": "intersection", "children": [
                {"op": "hull", "children": [slab_node(y, i)
                                            for i, y in enumerate(slab_ys)]},
                {"op": "difference", "children": [
                    {"prim": "box", "name": "dome_below",
                     "source": "everything below the ceiling-arc center plane",
                     "min": [bx, by, bz], "size": [bw, bl, "dome_cz + 1"]},
                    {"prim": "cylinder", "name": "dome_arc",
                     "source": "lengthwise ceiling: x-axis cylinder, LOWER "
                               "branch (center above the part) — residual in "
                               "dome_r param",
                     "p0": [dx0, "dome_cy", "dome_cz"],
                     "p1": [dx1, "dome_cy", "dome_cz"], "r": "dome_r"},
                ]},
            ]},
            {"prim": "cylinder", "name": "scoop_rear",
             "source": "rear underside scoop: measured x-axis cylinder "
                       "(see scoop_rear_* params)",
             "p0": [dx0, "scoop_rear_cy", "scoop_rear_cz"],
             "p1": [dx1, "scoop_rear_cy", "scoop_rear_cz"], "r": "scoop_rear_r"},
            {"prim": "cylinder", "name": "scoop_front",
             "source": "front underside scoop: measured x-axis cylinder "
                       "(see scoop_front_* params)",
             "p0": [dx0, "scoop_front_cy", "scoop_front_cz"],
             "p1": [dx1, "scoop_front_cy", "scoop_front_cz"],
             "r": "scoop_front_r"},
        ]},
    ]
    if cfg["fin_lip"]:
        fl = cfg["fin_lip"]
        crown_new_children.append(
            {"prim": "sweep", "axis": "y", "name": "fin_lip",
             "source": "rear clip lip: measured x-window, sloped top law "
                       "(fin_top_* params)",
             "u0": fl["u0"], "u1": fl["u1"], "s0": R(y0), "s1": fl["s1"],
             "z0": fl["z0"], "h_max": fl["h_max"], "steps": 8,
             "law": {"kind": "linear", "m": "fin_top_m", "b": "fin_top_b"}})
    crown_new = {"op": "union", "children": crown_new_children}

    sub = entry["csg"]["children"][0]["children"]
    assert sub[3].get("op") == "union", f"body {bid}: unexpected crown subtree"
    sub[3] = crown_new
    entry["notes"] = (entry.get("notes", "") +
                      " | crown REPLACED by law-solids (template-style): hull "
                      "of vectorized control slabs INTERSECT measured ceiling "
                      "arc MINUS measured underside scoops"
                      + (" PLUS sloped fin lip" if cfg["fin_lip"] else "")
                      + " — every law fitted with residual cited")


plan = json.loads((OUT / "plan.json").read_text())
shutil.copy(OUT / "plan.json", OUT / "plan_pre_crownlaws.json")
for cfg in CONFIGS:
    crownlaws(cfg, plan)
validate_plan(plan)
(OUT / "plan.json").write_text(json.dumps(plan, indent=1))
print("plan.json patched (crown law-solids em bodies 3 e 2); "
      "backup em plan_pre_crownlaws.json")
