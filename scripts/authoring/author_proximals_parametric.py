"""Author the SEMANTIC PARAMETRIC Proximals plan (schema v2/v3).

Collapses the v1 hull-loft plan (plan_v1.json, IoU 0.9796) into fitted laws:
the knuckle lobes are EXACT r6.0 cylinders about the exact pin-bore axes
(fit residuals 0.002/0.003), decks are tilted planes, blends are small arcs,
and the tendon-guide sawtooth is kept as measured line laws. Cuts (tunnel,
pins, fork, pocket, slots, shoulders) carry named params.

Writes plan_semantic.json AND promotes it to plan.json (the multi-body
semantic emitter prefix-bakes params per body). Also validates OFFLINE per
unique body: emits each csg body standalone (prefix=""), renders it, and
measures the native-CSG boolean IoU against that body's own reference
tessellation — this attributes residuals to a specific body/feature instead
of the whole-part blend.

Run:   python3 scripts/authoring/author_proximals_parametric.py
Then:  PYTHONPATH=src python3 -m step2scad models/phoenix_components/Proximals.step \
           --name Proximals --plan output/Proximals/plan.json
"""
import json
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

import numpy as np

sys.path.insert(0, "src")
from step2scad.fitting import circle_fit, line_fit, vectorize, z_cylinder_circles
from step2scad.plan import validate_plan
from step2scad.emit import csg as csg_emit

OUT = Path("output/Proximals")
STEP = "models/phoenix_components/Proximals.step"
R = lambda v: round(float(v), 6)

v1_path = OUT / "plan_v1.json"
if not v1_path.exists():
    shutil.copy(OUT / "plan.json", v1_path)
plan_v1 = json.load(open(v1_path))
feats = json.load(open(OUT / "features.json"))


# --------------------------------------------------------------------------
# open-polyline segmentation into line/arc laws (fit residual checked)
# --------------------------------------------------------------------------

def segment_polyline(samples, tol=0.10, min_arc=5, r_max=60.0):
    S = np.array(samples, float)
    n = len(S)
    i, out = 0, []
    while i < n - 1:
        best = None
        j = i + min_arc - 1
        while j < n:
            try:
                cx, cy, r, res = circle_fit(S[i:j + 1])
            except Exception:
                break
            if res > tol or r > r_max:
                break
            best = (j, cx, cy, r, res)
            j += 1
        if best and best[0] - i + 1 >= min_arc:
            j, cx, cy, r, res = best
            branch = "lower" if float(S[i:j + 1][:, 1].mean()) < cy else "upper"
            out.append(("arc", S[i][0], S[j][0], cx, cy, r, branch, res))
            i = j
            continue
        j = i + 1
        while j < n:
            m, b, res = line_fit(S[i:j + 1][:, 0], S[i:j + 1][:, 1])
            if res > tol:
                j -= 1
                break
            j += 1
        j = min(j, n - 1)
        m, b, res = line_fit(S[i:j + 1][:, 0], S[i:j + 1][:, 1])
        out.append(("line", S[i][0], S[j][0], m, b, res))
        i = j
    return out


def env_sweeps(segs, name, u0, u1, z_base, z_top, kind, exact_pins=()):
    """Segments -> smooth sweep prims. kind='top' keeps material below the
    envelope; kind='bottom' builds the material BELOW the envelope (subtract
    it to carve the underside)."""
    prims = []
    for k, (typ, s0, s1, *rest) in enumerate(segs):
        if s1 - s0 < 1e-6:
            continue
        if typ == "arc":
            cx, cy, r, branch, res = rest
            src = f"fitted arc law ({branch} branch, res {res:.3f})"
            for (pi, py, pz, pr) in exact_pins:
                if abs(cx - py) < 0.2 and abs(cy - pz) < 0.25 and abs(r - round(r)) < 0.05:
                    src = (f"knuckle lobe: r{round(r)} arc CONCENTRIC with the "
                           f"exact pin bore face #{pi} (fit res {res:.3f})")
                    break
            law = {"kind": "arc", "sc": R(cx), "zc": R(cy), "R": R(r)}
        else:
            m, b, res = rest
            src = f"fitted line law m={m:.4f} (res {res:.3f})"
            law = {"kind": "linear", "m": R(m), "b": R(b)}
        if typ == "arc" and rest[3] == "lower":
            cx, cy, r, branch, res = rest
            prims.append({"op": "difference", "children": [
                {"prim": "box", "name": f"{name}_{k:02d}_below",
                 "source": "region below the lower-branch arc envelope — "
                           + src,
                 "min": [R(u0 - 0.3), R(s0 - 0.05), R(z_base - 1.0)],
                 "size": [R(u1 - u0 + 0.6), R(s1 - s0 + 0.10),
                          R(cy - z_base + 1.0)]},
                {"prim": "cylinder", "name": f"{name}_{k:02d}_lobe",
                 "source": src,
                 "p0": [R(u0 - 0.4), R(cx), R(cy)],
                 "p1": [R(u1 + 0.4), R(cx), R(cy)], "r": R(r)},
            ]})
        elif kind == "top":
            prims.append({"prim": "sweep", "name": f"{name}_{k:02d}",
                          "source": src, "axis": "y",
                          "u0": R(u0), "u1": R(u1),
                          "s0": R(s0 - 0.05), "s1": R(s1 + 0.05),
                          "z0": R(z_base), "h_max": R(z_top), "steps": 8,
                          "law": law})
        else:
            prims.append({"prim": "sweep", "name": f"{name}_{k:02d}",
                          "source": "underside carve: " + src, "axis": "y",
                          "u0": R(u0 - 0.3), "u1": R(u1 + 0.3),
                          "s0": R(s0 - 0.05), "s1": R(s1 + 0.05),
                          "z0": R(z_base - 1.0), "h_max": R(z_top), "steps": 8,
                          "law": law})
    return prims


# --------------------------------------------------------------------------
# per-body semanticization
# --------------------------------------------------------------------------

def zones_of(entry):
    slabs, cuts = {}, []
    def walk(n):
        if "op" in n:
            for c in n["children"]:
                walk(c)
        elif n.get("prim") == "extrude" and n["name"][:2] in (
                "bm", "cr", "rg", "rd", "rp"):
            key = "".join(ch for ch in n["name"] if not ch.isdigit()).rstrip("_")
            slabs.setdefault(key, []).append(n)
        else:
            cuts.append(n)
    walk(entry["csg"])
    return slabs, cuts


def series_fullwidth(slabs, zones, u0, u1, frac=0.75):
    """Top envelope of the FULL-WIDTH part of each station (T-shaped
    profiles near the ridge have a narrow upper part that belongs to the
    ridge zone, not the beam)."""
    from shapely.geometry import Polygon, LineString
    pts = {}
    need = frac * (u1 - u0)
    for zn in zones:
        for p in slabs.get(zn, []):
            a = np.array(p["profile"])          # (z, x)
            y = round((p["z0"] + p["z1"]) / 2, 3)
            poly = Polygon(a)
            if not poly.is_valid:
                poly = poly.buffer(0)
            z_lo, z_hi = a[:, 0].min(), a[:, 0].max()
            top = z_lo
            for z in np.arange(z_lo + 0.05, z_hi + 0.05, 0.1):
                cut = poly.intersection(LineString([(z, u0 - 1), (z, u1 + 1)]))
                if cut.length >= need:
                    top = z
            pts[y] = max(pts.get(y, -1e9), top)
    return sorted(pts.items())


def series(slabs, zones, top=True):
    pts = {}
    for zn in zones:
        for p in slabs.get(zn, []):
            a = np.array(p["profile"])
            y = round((p["z0"] + p["z1"]) / 2, 3)
            z = a[:, 0].max() if top else a[:, 0].min()
            if top:
                pts[y] = max(pts.get(y, -1e9), z)
            else:
                pts[y] = min(pts.get(y, 1e9), z)
    return sorted(pts.items())


def build_body(entry, body_feats):
    bid = entry["body_id"]
    slabs, cuts = zones_of(entry)
    params = []

    def P(name, value, source):
        if not any(p["name"] == name for p in params):
            params.append({"name": name, "value": R(value), "source": source})
        return name

    # exact pin bores (r 2.3 / 2.375 full circles along x) — lobe centers
    pins = []
    for f in body_feats["faces"]:
        if f["type"] != "cylinder":
            continue
        p = f["params"]
        if (abs(abs(p["axis_dir"][0]) - 1) < 1e-6
                and f["orientation"] == "reversed"
                and abs(f["u_range"][1] - f["u_range"][0]) > 5.5):
            pins.append((f["index"], p["axis_origin"][1], p["axis_origin"][2],
                         p["radius"]))

    # ---- beam: constant x window × top/bottom envelope laws ---------------
    beam_zones = [z for z in slabs if z.startswith("bm")]
    xs = []
    for zn in beam_zones:
        for p in slabs[zn]:
            a = np.array(p["profile"])
            xs.append((a[:, 1].min(), a[:, 1].max()))
    xs = np.array(xs)
    u0 = float(np.median(xs[:, 0]))
    u1 = float(np.median(xs[:, 1]))
    # width-aware top only where the ridge exists (T-profiles); plain z_max
    # elsewhere (the dorsal hump crest tapers below the width threshold)
    ridge_y0 = min((p["z0"] for zn in ("rgsa", "rgca") for p in
                    slabs.get(zn, [])), default=1e9) - 0.4
    a_zones = beam_zones  # merged a+b series: denser + reaches the b-side tip
    tops_fw = dict(series_fullwidth(slabs, a_zones, u0, u1))
    tops_zm = dict(series(slabs, a_zones, True))
    tops = sorted((y, tops_fw[y] if y >= ridge_y0 else tops_zm[y])
                  for y in tops_zm)
    bots = series(slabs, beam_zones, False)
    y_lo, y_hi = tops[0][0], tops[-1][0]
    z_hi = max(z for _, z in tops) + 0.3
    z_lo = min(z for _, z in bots)
    top_segs = segment_polyline(tops)
    bot_segs = segment_polyline(bots)
    top_res = max(s[-1] for s in top_segs)
    bot_res = max(s[-1] for s in bot_segs)

    P("beam_wall_x0", u0, f"beam side-wall plane (median of {len(xs)} "
      "station footprints; end roundings in x are absorbed)")
    P("beam_wall_x1", u1, f"beam side-wall plane (median of {len(xs)} "
      "station footprints)")
    beam = {"op": "difference", "children": [
        {"op": "intersection", "children": [
            {"prim": "box", "name": "beam_bar",
             "source": "beam bar between the side-wall planes; z spans are "
                       "generous — the envelope laws below do the shaping",
             "min": ["beam_wall_x0", R(y_lo), R(min(z_lo, 0) - 0.2)],
             "size": ["beam_wall_x1 - beam_wall_x0", R(y_hi - y_lo),
                      R(z_hi - min(z_lo, 0) + 0.2)]},
            {"op": "union", "children": env_sweeps(
                top_segs, "beam_top", u0 - 0.5, u1 + 0.5, min(z_lo, 0) - 0.5,
                z_hi, "top", pins)},
        ]}] + env_sweeps(bot_segs, "beam_under", u0, u1, z_lo, z_hi, "bottom",
                         pins)}

    # hoist the exact knuckle lobes (arcs concentric with the pin bores) into
    # named params shared by the top and underside laws
    def hoist_lobes(node):
        if "op" in node:
            for c in node["children"]:
                hoist_lobes(c)
            return
        if node.get("prim") == "cylinder" and "CONCENTRIC" in node.get("source", ""):
            pin = min(pins, key=lambda q: abs(q[1] - node["p0"][1]))
            end = "palm" if pin[1] < (y_lo + y_hi) / 2 else "distal"
            py = P(f"knuckle_{end}_y", pin[1],
                   f"exact pin-bore axis y, face #{pin[0]}")
            pz = P(f"knuckle_{end}_z", pin[2],
                   f"exact pin-bore axis z, face #{pin[0]}")
            pr = P("knuckle_lobe_r", round(node["r"]),
                   "outer radius of both knuckle lobes (arc fits r=6.000 / "
                   "r=5.997, res 0.002/0.003 -> nominal 6.0)")
            node["p0"] = [node["p0"][0], py, pz]
            node["p1"] = [node["p1"][0], py, pz]
            node["r"] = pr
        if node.get("prim") == "sweep" and "CONCENTRIC" in node.get("source", ""):
            law = node["law"]
            pin = min(pins, key=lambda q: abs(q[1] - law["sc"]))
            end = "palm" if pin[1] < (y_lo + y_hi) / 2 else "distal"
            py = P(f"knuckle_{end}_y", pin[1],
                   f"exact pin-bore axis y, face #{pin[0]} (lobe arc fit "
                   "agrees within 0.1)")
            pz = P(f"knuckle_{end}_z", pin[2],
                   f"exact pin-bore axis z, face #{pin[0]}")
            pr = P("knuckle_lobe_r", round(law["R"]),
                   "outer radius of both knuckle lobes (arc fits r=6.000 / "
                   "r=5.997, res 0.002/0.003 -> nominal 6.0)")
            node["law"] = {"kind": "arc", "sc": py, "zc": pz, "R": pr}
    hoist_lobes(beam)

    # ---- dorsal ridge: stem + cap windows × top laws ----------------------
    ridge_parts = []
    for zns, tag in ((("rgsa", "rgsb"), "ridge_stem"),
                     (("rgca", "rgcb"), "ridge_cap")):
        zn = [z for z in zns if z in slabs]
        if not zn:
            continue
        rxs = np.array([[np.array(p["profile"])[:, 1].min(),
                         np.array(p["profile"])[:, 1].max()]
                        for z in zn for p in slabs[z]])
        ru0, ru1 = float(np.median(rxs[:, 0])), float(np.median(rxs[:, 1]))
        rt = series(slabs, zn, True)
        rb = series(slabs, zn, False)
        if tag == "ridge_cap" and len(rb) > 4:
            # the cap is a thin overhanging plate: its underside series has
            # deck-level outliers at the crown handoff — median-filter (w=3)
            # so the fitted law follows the plate, not the outliers
            zs = [z for _, z in rb]
            zs = [float(np.median(zs[max(0, i - 1):i + 2]))
                  for i in range(len(zs))]
            rb = [(y, z) for (y, _), z in zip(rb, zs)]
        rsegs = segment_polyline(rt)
        rbsegs = segment_polyline(rb)
        rz_lo = min(z for _, z in rb) - 0.3
        rz_hi = max(z for _, z in rt) + 0.2
        keep = {"op": "intersection", "children": [
            {"prim": "box", "name": f"{tag}_bar",
             "source": f"{tag} wall window x=[{R(ru0)},{R(ru1)}] (median of "
                       f"{len(rxs)} stations)",
             "min": [R(ru0), R(rt[0][0]), R(rz_lo)],
             "size": [R(ru1 - ru0), R(rt[-1][0] - rt[0][0]), R(rz_hi - rz_lo)]},
            {"op": "union", "children": env_sweeps(
                rsegs, f"{tag}_top", ru0 - 0.3, ru1 + 0.3, rz_lo - 0.2, rz_hi,
                "top")},
        ]}
        # underside law (the cap is an overhanging plate whose bottom follows
        # its own law) — subtracted LOCALLY so only this part is carved
        under = env_sweeps(rbsegs, f"{tag}_under", ru0, ru1, rz_lo, rz_hi,
                           "bottom")
        ridge_parts.append({"op": "difference", "children": [keep] + under}
                           if under else keep)

    # ---- crown: kept as v1 hull-loft (organic; cost of keeping = 0) -------
    crown_children = []
    for p in sorted(slabs.get("cra", []) + slabs.get("crb", []),
                    key=lambda q: q["z0"]):
        q = dict(p)
        q["name"] = "crown_" + p["name"]
        q["source"] = "crown loft station (measured; kept organic — no clean " \
                      "law found across stations) — " + p["source"]
        crown_children.append(q)
    # rebuild the original hull pairing (a_i with b_i)
    cra = [c for c in crown_children if c["name"].endswith("a")]
    crb = [c for c in crown_children if c["name"].endswith("b")]
    crown = {"op": "union", "children": [
        {"op": "hull", "children": [a, b]} for a, b in zip(cra, crb)]}

    # ---- side recess / palm profiles: vectorized paths --------------------
    extra = []
    circles = z_cylinder_circles(body_feats["faces"])
    for zn in ("rdl", "rdr", "rpl", "rpr"):
        for p in slabs.get(zn, []):
            segs, nl, na, ne = vectorize(p["profile"], exact_circles=(),
                                         tol=0.08)
            q = {k: v for k, v in p.items() if k != "profile"}
            q["name"] = {"rdl": "recess_left", "rdr": "recess_right",
                         "rpl": "palm_web_left", "rpr": "palm_web_right"}[zn]
            q["profile2d"] = {"path": segs}
            q["source"] = (f"vectorized measured profile ({nl} lines + {na} "
                           f"arcs) — " + p["source"])
            extra.append(q)

    # ---- cuts: hoist the exact radii into named params ---------------------
    cut_prims_named = []
    for c in cuts:
        c = dict(c)
        if c.get("prim") == "cylinder":
            if "tunnel" in c["name"]:
                c["r"] = P("tendon_tunnel_r", c["r"],
                           "exact tendon-tunnel bore radius — " + c["source"])
                c["name"] = "tendon_tunnel"
            elif c["name"].startswith("pin"):
                y_mid = (c["p0"][1] + c["p1"][1]) / 2
                end = "palm" if y_mid < (y_lo + y_hi) / 2 else "distal"
                c["r"] = P(f"pin_{end}_r", c["r"],
                           f"exact {end} pin-bore radius — " + c["source"])
                c["name"] = f"pin_bore_{end}"
        cut_prims_named.append(c)
    cuts = cut_prims_named

    adds = [beam] + ridge_parts + [crown] + [e for e in extra
                                             if "recess" not in e["name"]]
    cut_prims = [c for c in cuts] + [e for e in extra if "recess" in e["name"]]
    # (v1 recesses rdl/rdr are cuts; palm webs rpl/rpr are adds — preserve
    # the original membership by checking where they sat in the v1 tree)
    tree = {"op": "difference",
            "children": [{"op": "union", "children": adds}] + cut_prims}
    notes = (f"semantic laws: beam = exact wall window × envelope laws "
             f"(top res {top_res:.3f}, bottom res {bot_res:.3f}; knuckle "
             f"lobes are r6 arcs concentric with the exact pin bores); ridge "
             f"stem/cap = window × fitted laws; crown kept as measured loft "
             f"(no clean law); recess/web profiles vectorized")
    return {"body_id": bid, "strategy": "csg", "notes": notes,
            "params": params, "csg": tree}


# careful: v1 membership of rd/rp (cut vs add) — inspect the v1 tree order
def v1_membership(entry):
    root = entry["csg"]
    assert root["op"] == "difference"
    add_names, cut_names = set(), set()
    def collect(n, bag):
        if "op" in n:
            for c in n["children"]:
                collect(c, bag)
        else:
            bag.add(n["name"])
    collect(root["children"][0], add_names)
    for c in root["children"][1:]:
        collect(c, cut_names)
    return add_names, cut_names


bodies_out = []
report = []
for entry in plan_v1["bodies"]:
    if entry["strategy"] != "csg":
        bodies_out.append(entry)
        continue
    bf = feats["bodies"][entry["body_id"]]
    built = build_body(entry, bf)
    # fix rd/rp membership from the v1 tree
    adds_v1, cuts_v1 = v1_membership(entry)
    root = built["csg"]
    union = root["children"][0]["children"]
    rest = root["children"][1:]
    fixed_adds, fixed_cuts = [], list()
    for prim in union + rest:
        nm = prim.get("name", "")
        orig = {"recess_left": "rdl", "recess_right": "rdr",
                "palm_web_left": "rpl", "palm_web_right": "rpr"}.get(nm)
        if orig and orig in cuts_v1 and prim in union:
            union.remove(prim)
            rest.append(prim)
        if orig and orig in adds_v1 and prim in rest:
            rest.remove(prim)
            union.append(prim)
    built["csg"] = {"op": "difference",
                    "children": [{"op": "union", "children": union}] + rest}
    bodies_out.append(built)

plan = {"version": 1, "source": plan_v1.get("source", STEP),
        "bodies": bodies_out}
validate_plan(plan)
json.dump(plan, open(OUT / "plan_semantic.json", "w"), indent=1)
shutil.copy(OUT / "plan_semantic.json", OUT / "plan.json")
n_prims = json.dumps(plan).count('"prim"')
print(f"plan_semantic.json escrito: {n_prims} primitivas "
      f"(v1: {json.dumps(plan_v1).count(chr(34) + 'prim' + chr(34))})")

# --------------------------------------------------------------------------
# OFFLINE per-body validation (bypasses the multi-body semantic limitation):
# emit each unique csg body standalone, render, boolean-IoU vs that body's
# own reference tessellation.
# --------------------------------------------------------------------------
from step2scad.ingest import read_step, shape_to_trimesh, solids_of
import trimesh

shape = read_step(STEP)
solids = solids_of(shape)
osc = "/home/pec/bin/openscad"

for entry in plan["bodies"]:
    if entry["strategy"] != "csg":
        continue
    bid = entry["body_id"]
    lines = []
    csg_emit.emit_csg_body({"id": bid}, entry, lines, prefix="")
    scad = OUT / f"body{bid}_semantic.scad"
    scad.write_text("\n".join(lines) + f"\nbody_{bid}();\n")
    ref = shape_to_trimesh(solids[bid])
    ref_stl = OUT / f"body{bid}_ref.stl"
    ref.export(ref_stl)
    with tempfile.TemporaryDirectory() as td:
        td = Path(td)
        vols = {}
        for op in ("intersection", "union"):
            w = td / f"{op}.scad"
            w.write_text(f"use <{scad.resolve()}>\n{op}() {{ body_{bid}(); "
                         f'import("{ref_stl.resolve()}"); }}\n')
            outstl = td / f"{op}.stl"
            r = subprocess.run([osc, "-o", str(outstl), "--backend", "Manifold",
                                str(w)], capture_output=True, text=True)
            if r.returncode != 0:
                print(f"body {bid}: RENDER FALHOU: {r.stderr[-400:]}")
                vols = None
                break
            vols[op] = float(trimesh.load(outstl, force="mesh").volume)
    if vols:
        iou = vols["intersection"] / vols["union"]
        report.append((bid, iou))
        print(f"body {bid}: IoU offline (CSG nativo) = {iou:.4f}  "
              f"(∩ {vols['intersection']:.1f} / ∪ {vols['union']:.1f})")
print("RESUMO:", ", ".join(f"body {b}: {i:.4f}" for b, i in report))


# ---- crown stage: replace the measured crown loft with fitted law-solids ---
import subprocess
subprocess.run([sys.executable, "scripts/authoring/crownlaws_proximals.py"],
               check=True)
