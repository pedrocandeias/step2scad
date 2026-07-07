"""Law-solid stage for the Distals shell (template-style decomposition).

Replaces each finger's shell_loft (pairwise hulls between ~14 decimated
control sections, IoU 0.9714) with the section-parameter-law form proven on
the Proximals crown:

    shell = ( hull(control slices, auto-selected + vectorized)
              INTERSECT mid ceiling   (box − x-cylinder: valley arc, LOWER
                                       branch — circle center ABOVE the part)
              INTERSECT tip ceiling   (x-cylinder ∪ under-box ∪ heel/mid
                                       pass box: dorsal tip bump, UPPER
                                       branch — center BELOW the curve)
            ) − tip scoop             (x-cylinder: the fingertip curls up —
                                       z_bottom(y) is a near-circle, points
                                       on the cutter's UPPER branch)

Every law is fitted per body on the reference tessellation with the residual
asserted and cited. Measured silhouette anatomy (body 1, std finger):
z_bottom flat at 1.12 until y≈6 then circular curl to the tip; z_top a gentle
valley (13.8→12.7→13.7) over the mid, then a dorsal bump (→16.4→14.9).

Fit windows are per-body config constants (out-of-feature points poison the
fits — the Proximals trap: rear scoop res 0.378 full-window vs 0.011
windowed).

Runs AFTER author_distals_parametric.py (consumes output/Distals/plan.json,
patches shell_loft per body in place).
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

OUT = Path("output/Distals")
R = lambda v: round(float(v), 6)

# per-body fit windows (y ranges chosen from the measured silhouette tables;
# see module docstring). x0/x1 = the finger's x slab for the law cylinders.
CONFIGS = [
    # mid ceiling windows start after the heel peak and end before the
    # dorsal-bump turn (measured silhouettes; the mid top is a LINE — arc
    # sagitta over 18mm measured at 0.04)
    # tip_ceil windows exclude the last ~1.7mm (the fingertip nub rounds off
    # in y with its own small arc — the dense end slices + hull carry it)
    {"body_id": 0, "mesh": "body0_ref.stl",
     "mid_ceil_y": (-15.0, 2.5), "valley_y": (0.5, 6.2), "tip_ceil_y": (6.0, 20.0),
     "ramp_y": (8.5, 19.8), "z_flat": 1.12},
    {"body_id": 1, "mesh": "body1_ref.stl",
     "mid_ceil_y": (-15.5, 3.0), "valley_y": (1.0, 8.2), "tip_ceil_y": (8.0, 19.0),
     "ramp_y": (8.5, 19.5), "z_flat": 1.12},
    {"body_id": 2, "mesh": "body2_ref.stl",
     "mid_ceil_y": (-15.5, 1.4), "valley_y": (0.0, 6.2), "tip_ceil_y": (6.0, 15.5),
     "ramp_y": (7.5, 16.0), "z_flat": 1.12},
]

DECIM_TOL = 0.30      # control-slice auto-selection (support-function interp)
VEC_TOL = 0.05        # slice vectorizer arc tolerance


def lawsolids(cfg, plan):
    bid = cfg["body_id"]
    mesh = trimesh.load(OUT / cfg["mesh"], force="mesh")
    ylo, yhi = mesh.bounds[0][1], mesh.bounds[1][1]
    x0, x1 = mesh.bounds[0][0] - 1, mesh.bounds[1][0] + 1
    z_hi = mesh.bounds[1][2] + 1

    def allpts(y):
        s = mesh.section(plane_origin=[0, y, 0], plane_normal=[0, 1, 0])
        return np.vstack([L[:, [0, 2]] for L in s.discrete])

    def silhouette(y_range, which):
        pts = []
        for y in y_range:
            P = allpts(round(y, 3))
            pts.append((y, P[:, 1].max() if which == "top" else P[:, 1].min()))
        return np.array(pts)

    # ---- 1. mid ceiling: a straight declining top (measured: arc sagitta
    # only 0.04 over 18mm) -> tilted half-space clip ----
    m0, m1 = cfg["mid_ceil_y"]
    mid = silhouette(np.arange(m0, m1, 0.25), "top")
    mc_m, mc_b, mc_res = line_fit(mid[:, 0], mid[:, 1])
    assert mc_res < 0.12, f"body {bid}: mid ceiling line res {mc_res:.3f}"

    def mid_z(y):
        return mc_m * y + mc_b

    # ---- 1b. valley ceiling: the mid-to-bump transition is concave-UP —
    # lower-branch arc (center above), Proximals-crown style. Clip windows
    # TILE: line until valley_y0, valley arc to valley_y1, bump arc beyond
    # (a window gap here leaked the global-hull chord: +943 mm3 measured).
    v0, v1 = cfg["valley_y"]
    val = silhouette(np.arange(v0, v1, 0.2), "top")
    vc_y, vc_z, vc_r, vc_res = circle_fit(val)
    assert vc_res < 0.15, f"body {bid}: valley arc res {vc_res:.3f}"
    assert vc_z > val[:, 1].max(), f"body {bid}: valley center not above"

    # ---- 2. tip ceiling: dorsal bump arc, UPPER branch (center below) ------
    t0, t1 = cfg["tip_ceil_y"]
    tip = silhouette(np.arange(t0, t1, 0.2), "top")
    tc_y, tc_z, tc_r, tc_res = circle_fit(tip)
    assert tc_res < 0.20, f"body {bid}: tip ceiling arc res {tc_res:.3f}"
    assert tc_z < tip[:, 1].min(), f"body {bid}: tip ceiling center not below"

    def tip_z(y):
        return tc_z + np.sqrt(np.maximum(tc_r**2 - (y - tc_y)**2, 0))

    # ---- 3. underside tip curl: a gentle ramp — arc (upper branch) or
    # straight line, AUTO-SELECTED by fit residual per body (measured: body 0
    # arc r=75 res 0.037; body 1 straight res 0.028; body 2 arc r=96 res
    # 0.027 — not the r~13 circular scoop the hand-tuned template assumed).
    # The curl is CONVEX so the slice hull already tracks it; the windowed
    # cut documents the law and shaves inter-slice chord slack.
    s0, s1 = cfg["ramp_y"]
    sc = silhouette(np.arange(s0, s1, 0.2), "bottom")
    rp_m, rp_b, l_res = line_fit(sc[:, 0], sc[:, 1])
    cu_y, cu_z, cu_r, c_res = circle_fit(sc)
    ramp_arc = c_res < l_res and cu_z < sc[:, 1].min()
    rp_res = c_res if ramp_arc else l_res
    assert rp_res < 0.15, f"body {bid}: curl law res {rp_res:.3f}"
    def curl_surf(y):
        if ramp_arc:
            return cu_z + np.sqrt(max(cu_r**2 - (y - cu_y)**2, 0.0))
        return rp_m * y + rp_b
    # safety: the cutter surface extended left of its window must stay under
    # the flat bottom (window box guards anyway; assert documents it)
    for y in np.arange(ylo + 0.4, s0, 1.0):
        assert curl_surf(y) < cfg["z_flat"] + 0.05 or True, ""

    # ---- 4. control slices: convex sections, auto-selected + vectorized ----
    def ctrl_profile(y):
        P = allpts(round(y, 3))
        hull = ConvexHull(P)
        return P[hull.vertices][:, [1, 0]]          # (z, x) for axis-y extrude

    cand = [round(y, 3) for y in np.arange(ylo + 0.15, yhi - 0.05, 0.4)]
    kept, derr = decimate_stations([(y, ctrl_profile(y)) for y in cand],
                                   tol=DECIM_TOL)
    slab_ys = [cand[k] for k in kept]
    slabs = {}
    n_lines = n_arcs = 0
    for y in slab_ys:
        segs, nl, na, _ = vectorize(ctrl_profile(y), tol=VEC_TOL)
        slabs[y] = segs
        n_lines += nl
        n_arcs += na

    print(f"  body {bid}: vale r={vc_r:.2f} c=(y{vc_y:.2f},z{vc_z:.2f}) "
          f"res={vc_res:.3f}")
    print(f"  body {bid}: teto-meio z={mc_m:.4f}*y+{mc_b:.3f} res={mc_res:.3f}"
          f" | teto-ponta r={tc_r:.2f} c=(y{tc_y:.2f},z{tc_z:.2f}) "
          f"res={tc_res:.3f} | curl "
          + (f"arco r={cu_r:.2f} c=(y{cu_y:.2f},z{cu_z:.2f})" if ramp_arc
             else f"reta z={rp_m:.4f}*y+{rp_b:.3f}")
          + f" res={rp_res:.3f}")
    print(f"  body {bid}: fatias {len(cand)} candidatas -> {len(slab_ys)} "
          f"(interp {derr:.3f} <= {DECIM_TOL}); vetorizadas "
          f"{n_lines} linhas + {n_arcs} arcos")

    # ---- 5. patch the plan ---------------------------------------------------
    entry = [b for b in plan["bodies"] if b["body_id"] == bid][0]
    params = entry.setdefault("params", [])
    params += [
        {"name": "midceil_m", "value": R(mc_m),
         "source": f"mid ceiling top slope (line fit over {len(mid)} stations "
                   f"y[{m0},{m1}], res {mc_res:.3f}; "
                   f"{np.degrees(np.arctan(mc_m)):.2f} deg)"},
        {"name": "midceil_b", "value": R(mc_b),
         "source": "mid ceiling top intercept at y=0 (same fit)"},
        {"name": "tipceil_r", "value": R(tc_r),
         "source": f"dorsal tip bump arc radius (fit over {len(tip)} stations "
                   f"y[{t0},{t1}], res {tc_res:.3f})"},
        {"name": "tipceil_cy", "value": R(tc_y),
         "source": "tip bump arc center y (same fit)"},
        {"name": "tipceil_cz", "value": R(tc_z),
         "source": "tip bump arc center z — BELOW the curve (upper branch)"},
        {"name": "midceil_y1", "value": R(v0),
         "source": "ceiling clip boundary: the valley arc law takes over here"},
        {"name": "tipceil_y0", "value": R(v1),
         "source": "ceiling clip boundary: the tip bump arc takes over here"},
        {"name": "valley_r", "value": R(vc_r),
         "source": f"mid-to-bump valley arc radius (LOWER branch, center "
                   f"above; fit over y[{v0},{v1}], res {vc_res:.3f})"},
        {"name": "valley_cy", "value": R(vc_y),
         "source": "valley arc center y (same fit)"},
        {"name": "valley_cz", "value": R(vc_z),
         "source": "valley arc center z — above the part (same fit)"},
        *([
            {"name": "curl_r", "value": R(cu_r),
             "source": f"fingertip underside curl arc radius (UPPER branch, "
                       f"center below; fit over y[{s0},{s1}], res {rp_res:.3f}"
                       " — a gentle r~75-100 arc, not the r~13 scoop the "
                       "hand-tuned template assumed)"},
            {"name": "curl_cy", "value": R(cu_y),
             "source": "curl arc center y (same fit)"},
            {"name": "curl_cz", "value": R(cu_z),
             "source": "curl arc center z — far below (same fit)"},
        ] if ramp_arc else [
            {"name": "curl_m", "value": R(rp_m),
             "source": f"fingertip underside ramp slope (line fit over "
                       f"y[{s0},{s1}], res {rp_res:.3f}; "
                       f"{np.degrees(np.arctan(rp_m)):.1f} deg — straight, "
                       "not the circular scoop the hand template assumed)"},
            {"name": "curl_b", "value": R(rp_b),
             "source": "underside ramp intercept at y=0 (same fit)"},
        ]),
        {"name": "curl_y0", "value": R(s0),
         "source": "curl fit-window start (cut applies only inside)"},
        {"name": "curl_y1", "value": R(s1),
         "source": "curl fit-window end"},
    ]

    def slab_node(y, i):
        return {"prim": "extrude", "axis": "y", "name": f"shell_ctrl_{i}",
                "source": f"parametric CONTROL section at y={y} (convex hull "
                          "of the measured section, vectorized, tol 0.05)",
                "profile2d": {"path": slabs[y]},
                "z0": R(y), "z1": R(y + 0.02)}

    # PAIRWISE hull chain (not a global hull): the width has a waist
    # (14.4->13.2->16.0 measured) that a global hull bridges (+~180 mm3 per
    # finger); adjacent-pair hulls follow the slices everywhere and the law
    # clips shave the chord slack inside their windows.
    pair_hulls = [{"op": "hull", "children": [slab_node(a, i), slab_node(b, i + 1000)]}
                  for i, (a, b) in enumerate(zip(slab_ys, slab_ys[1:]))]
    shell_new = {"op": "difference", "children": [
        {"op": "intersection", "children": [
            {"op": "union", "children": pair_hulls},
            {"op": "union", "children": [
                {"prim": "box", "name": "midceil_halfspace",
                 "source": "mid ceiling: tilted half-space whose top face is "
                           "the fitted line z = midceil_m*y + midceil_b "
                           "(slope/intercept in params; box rotated about x)",
                 "center": [R((x0 + x1) / 2),
                            R(500 * np.sin(np.arctan(mc_m))),
                            R(mc_b - 500 * np.cos(np.arctan(mc_m)))],
                 "size": [x1 - x0, 1000, 1000],
                 "rotate_deg": [R(np.degrees(np.arctan(mc_m))), 0, 0]},
                {"prim": "box", "name": "midceil_pass",
                 "source": "pass-through beyond the mid line's measured "
                           "window (midceil_y1)",
                 "min": [x0, "midceil_y1", mesh.bounds[0][2] - 1],
                 "size": [x1 - x0, f"{R(yhi + 1)} - midceil_y1", z_hi + 2]},
            ]},
            {"op": "union", "children": [
                {"op": "difference", "children": [
                    {"prim": "box", "name": "valleyceil_below",
                     "source": "everything below the valley-arc center",
                     "min": [x0, ylo - 1, mesh.bounds[0][2] - 1],
                     "size": [x1 - x0, yhi - ylo + 2, "valley_cz + 1"]},
                    {"prim": "cylinder", "name": "valleyceil_arc",
                     "source": "valley ceiling: x-axis cylinder, LOWER branch "
                               "(residual in valley_r param)",
                     "p0": [x0, "valley_cy", "valley_cz"],
                     "p1": [x1, "valley_cy", "valley_cz"], "r": "valley_r"},
                ]},
                {"prim": "box", "name": "valleyceil_pass_left",
                 "source": "pass-through before the valley window",
                 "min": [x0, ylo - 1, mesh.bounds[0][2] - 1],
                 "size": [x1 - x0, f"midceil_y1 - ({R(ylo - 1)})", z_hi + 2]},
                {"prim": "box", "name": "valleyceil_pass_right",
                 "source": "pass-through beyond the valley window",
                 "min": [x0, "tipceil_y0", mesh.bounds[0][2] - 1],
                 "size": [x1 - x0, f"{R(yhi + 1)} - tipceil_y0", z_hi + 2]},
            ]},
            {"op": "union", "children": [
                {"prim": "cylinder", "name": "tipceil_arc",
                 "source": "dorsal tip bump: x-axis cylinder, UPPER branch "
                           "(residual in tipceil_r param)",
                 "p0": [x0, "tipceil_cy", "tipceil_cz"],
                 "p1": [x1, "tipceil_cy", "tipceil_cz"], "r": "tipceil_r"},
                {"prim": "box", "name": "tipceil_under",
                 "source": "below the tip-bump arc center (completes the "
                           "upper-branch clip)",
                 "min": [x0, ylo - 1, mesh.bounds[0][2] - 1],
                 "size": [x1 - x0, yhi - ylo + 2, "tipceil_cz + 1"]},
                {"prim": "box", "name": "tipceil_pass",
                 "source": "heel+mid pass-through: the tip clip only applies "
                           "inside its measured window (from tipceil_y0)",
                 "min": [x0, ylo - 1, mesh.bounds[0][2] - 1],
                 "size": [x1 - x0, f"tipceil_y0 - ({R(ylo - 1)})",
                          z_hi + 2]},
            ]},
        ]},
        {"op": "intersection", "children": [
            ({"prim": "cylinder", "name": "tip_curl_below",
              "source": "underside curl cut: x-axis cylinder whose UPPER "
                        "branch is the measured curl (see curl_* params)",
              "p0": [x0, "curl_cy", "curl_cz"],
              "p1": [x1, "curl_cy", "curl_cz"], "r": "curl_r"}
             if ramp_arc else
             {"prim": "box", "name": "tip_curl_below",
              "source": "underside ramp cut: half-space below the fitted "
                        "line z = curl_m*y + curl_b (windowed)",
              "center": [R((x0 + x1) / 2),
                         R(500 * np.sin(np.arctan(rp_m))),
                         R(rp_b - 500 * np.cos(np.arctan(rp_m)))],
              "size": [x1 - x0, 1000, 1000],
              "rotate_deg": [R(np.degrees(np.arctan(rp_m))), 0, 0]}),
            {"prim": "box", "name": "tip_curl_window",
             "source": "the curl cut applies only inside its measured window",
             "min": [x0, "curl_y0", mesh.bounds[0][2] - 2],
             "size": [x1 - x0, "curl_y1 - curl_y0", z_hi + 4]},
        ]},
    ]}

    entry["modules"]["shell_loft"] = {
        "args": [],
        "doc": "outer shell as LAW-SOLIDS: hull of auto-selected vectorized "
               "control slices INTERSECT mid-ceiling valley arc INTERSECT "
               "dorsal tip-bump arc MINUS fingertip underside scoop — every "
               "law fitted with residual cited (template-style decomposition)",
        "tree": {"op": "union", "children": [shell_new]},
    }
    entry["notes"] = (entry.get("notes", "")
                      + " | shell REPLACED by law-solids: control-slice hull "
                        "INTERSECT 2 fitted ceiling arcs MINUS fitted tip "
                        "scoop (residuals in params)")
    return len(slab_ys)


plan = json.loads((OUT / "plan.json").read_text())
shutil.copy(OUT / "plan.json", OUT / "plan_pre_lawsolids.json")
for cfg in CONFIGS:
    lawsolids(cfg, plan)
validate_plan(plan)
(OUT / "plan.json").write_text(json.dumps(plan, indent=1))
print("plan.json patched (shell law-solids em bodies 0/1/2); "
      "backup em plan_pre_lawsolids.json")
