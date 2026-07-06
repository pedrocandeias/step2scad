"""Semanticize the Distals plan (v1 -> parametric style, CLAUDE.md rules).

Transforms output/Distals/plan_v1.json (measured hull-loft + exact cuts,
IoU 0.9839) into the readable form:

  - station profiles VECTORIZED (lines + fitted arcs, arcs snapped to exact
    y-axis cylinder faces of each body) and registered as shared `profiles`
    with ZONE NAMES (lobe_/clevis_/mid_/dome_) instead of st##a dumps;
  - constant-section runs collapsed to single extrudes (measured: the distal
    tapers continuously — only one adjacent pair qualifies at tol 0.06, so
    the hull-loft honestly remains the loft);
  - cuts/adds grouped into per-body modules: hinge_cuts(), tendon_cuts(),
    tendon_details() — same exact values, structured;
  - body-level named params are NOT available here (the emitter restricts
    params to single-body plans; Distals has 5 bodies) — noted limitation.

Run: python3 scripts/authoring/author_distals_parametric.py
"""
import json
import shutil
import sys
from pathlib import Path

import numpy as np

sys.path.insert(0, "src")
from step2scad.fitting import decimate_stations, dist_to_poly, vectorize
from step2scad.plan import validate_plan

OUT = Path("output/Distals")
v1_path = OUT / "plan_v1.json"
if not v1_path.exists():
    shutil.copy(OUT / "plan.json", v1_path)
plan = json.loads(v1_path.read_text())
feats = json.loads((OUT / "features.json").read_text())

SAME_TOL = 0.06          # adjacent stations closer than this are one section
DECIM_TOL = 0.30         # control-section decimation: max interp error (mm)
VEC_TOL = 0.06           # vectorizer arc-fit tolerance


def y_cylinder_circles_zx(body):
    """Exact circles of y-axis cylinder faces, in the station (z, x) frame."""
    out = []
    for f in body["faces"]:
        if (f["type"] == "cylinder"
                and abs(abs(f["params"]["axis_dir"][1]) - 1) < 1e-3):
            p = f["params"]
            out.append((f["index"], p["axis_origin"][2], p["axis_origin"][0],
                        p["radius"]))
    return out


def zone_of(y):
    if y <= -13.0:
        return "lobe"        # knuckle lobe (hinge end)
    if y <= -6.0:
        return "clevis"      # clevis / gap region
    if y <= 6.0:
        return "mid"         # slot + scoop region
    return "dome"            # fingertip dome


def semanticize_body(entry, body):
    tree = entry["csg"]
    diff = tree["children"][0]
    shell, cuts = diff["children"][0], diff["children"][1:]
    adds = tree["children"][1:]

    # ---- stations from the hull slabs (profile pairs are (z, x)) ----------
    stations = {}
    for h in shell["children"]:
        for slab in h["children"]:
            stations.setdefault(round(slab["z0"], 6), slab["profile"])
    ys = sorted(stations)

    # ---- decimate to CONTROL sections: an interior station survives only if
    # the hull of its neighbors cannot reproduce it within DECIM_TOL
    # (support-function interpolation — exact for convex hull cross-sections)
    kept, interp_err = decimate_stations([(y, stations[y]) for y in ys],
                                         tol=DECIM_TOL)
    n_all = len(ys)
    ys = [ys[k] for k in kept]
    print(f"  body {entry['body_id']}: {n_all} estações -> {len(ys)} secções "
          f"de controlo (erro interp. máx {interp_err:.3f} <= tol {DECIM_TOL})")

    # constant-section runs (measured; mostly none — the loft is real)
    same_next = []
    for i in range(len(ys) - 1):
        a, c = np.array(stations[ys[i]]), np.array(stations[ys[i + 1]])
        d = max(dist_to_poly(a, c).max(), dist_to_poly(c, a).max())
        same_next.append(d < SAME_TOL)

    circles = y_cylinder_circles_zx(body)
    # NOTE: shared profile refs break under multi-body prefixing (emitter
    # renders `<name>_pts` unprefixed) -> inline each vectorized path.
    prof_path, prof_name_of = {}, {}
    counters = {}
    n_lines = n_arcs = n_exact = 0
    for y in ys:
        z = zone_of(y)
        counters[z] = counters.get(z, 0) + 1
        name = f"{z}_s{counters[z]:02d}"
        segs, nl, na, ne = vectorize(stations[y], exact_circles=circles,
                                     tol=VEC_TOL)
        n_lines += nl; n_arcs += na; n_exact += ne
        prof_path[y] = {"path": segs}
        prof_name_of[y] = name

    # ---- rebuild the shell: extrudes over constant runs, hulls elsewhere --
    def slab(y, tag):
        return {"prim": "extrude", "axis": "y",
                "name": f"{prof_name_of[y]}_{tag}",
                "source": f"vectorized measured section at y={y} "
                          f"(station {prof_name_of[y]})",
                "profile2d": prof_path[y],
                "z0": round(y, 6), "z1": round(y + 0.02, 6)}

    kids = []
    i = 0
    seg_n = 0
    while i < len(ys) - 1:
        if same_next[i]:                      # constant run -> one extrude
            j = i
            while j < len(ys) - 1 and same_next[j]:
                j += 1
            kids.append({"prim": "extrude", "axis": "y",
                         "name": f"const_{prof_name_of[ys[i]]}",
                         "source": "constant measured section over "
                                   f"y=[{ys[i]}, {ys[j]}] (adjacent stations "
                                   f"identical within {SAME_TOL})",
                         "profile2d": prof_path[ys[i]],
                         "z0": round(ys[i], 6), "z1": round(ys[j] + 0.02, 6)})
            i = j
        else:                                 # genuine taper -> hull segment
            seg_n += 1
            kids.append({"op": "hull", "children": [
                slab(ys[i], f"h{seg_n:02d}a"), slab(ys[i + 1], f"h{seg_n:02d}b")]})
            i += 1

    entry["modules"] = {
        "shell_loft": {
            "args": [],
            "doc": "outer shell: hull-loft between vectorized measured "
                   "sections (zone-named: lobe_/clevis_/mid_/dome_); the "
                   "distal tapers continuously, so the loft is genuine",
            "tree": {"op": "union", "children": kids}},
        "hinge_cuts": {
            "args": [],
            "doc": "hinge system: clevis gap + knuckle relief + pin bore + "
                   "snap-pin pockets (all exact B-rep faces; see sources)",
            "tree": {"op": "union", "children": [c for c in cuts
                     if c.get("name") in ("gap", "relief", "pin_bore",
                                          "pocketL", "pocketR")]}},
        "tendon_cuts": {
            "args": [],
            "doc": "tendon path: bottom slot, top cord scoop and the top "
                   "channel flat (exact faces / measured laws; see sources)",
            "tree": {"op": "union", "children": [c for c in cuts
                     if c.get("name") in ("slot", "scoop", "channel")]}},
        "tendon_details": {
            "args": [],
            "doc": "material re-added inside the tendon path: post, slot "
                   "front-corner nooks, cord bar with measured top cut",
            "tree": {"op": "union", "children": adds}},
    }
    entry["csg"] = {"op": "union", "children": [
        {"op": "difference", "children": [
            {"call": "shell_loft", "name": "shell_i", "args": {}},
            {"call": "hinge_cuts", "name": "hinge_i", "args": {}},
            {"call": "tendon_cuts", "name": "tendon_i", "args": {}},
        ]},
        {"call": "tendon_details", "name": "details_i", "args": {}},
    ]}
    entry["notes"] = (
        f"decimated to {len(ys)} parametric CONTROL sections (from {n_all} "
        f"measured stations; support-function interp error <= 0.30; measured "
        "cost curve: 28 sections @ IoU 0.9809 / ~14 @ 0.9714 / ~10 @ 0.9615 "
        "— 0.30 chosen per the parametric-preferred policy) — "
        "semantic form: vectorized zone-named stations (hull-loft kept — "
        "the taper is real), cuts/adds grouped into hinge_cuts/tendon_cuts/"
        "tendon_details modules; exact values unchanged from plan_v1. "
        "Body-level named params unavailable (multi-body plan; emitter "
        "restriction).")
    return len(ys), seg_n, n_lines, n_arcs, n_exact


for entry in plan["bodies"]:
    if entry["strategy"] != "csg":
        continue
    body = feats["bodies"][entry["body_id"]]
    ns, nh, nl, na, ne = semanticize_body(entry, body)
    print(f"body {entry['body_id']}: {ns} estações vetorizadas "
          f"({nl} linhas + {na} arcos, {ne} exatos), {nh} segmentos hull")

validate_plan(plan)
(OUT / "plan.json").write_text(json.dumps(plan, indent=1))
print("wrote output/Distals/plan.json (semantic)")
