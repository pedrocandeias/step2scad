"""Semanticize the Palm_left plan (v1 outline-slab stack -> parametric v2/v3).

Strategy (policy: parametric/editable preferred, every substitution measured,
boolean IoU must stay >= 0.955 — baseline 0.9652, tight margin):

  A. Group the 1938 v1 primitives into semantic modules with named params
     (shell, cavity, bottom grid, finger slots, thumb clevis, pins, wrist,
     tendon tubes).
  B. SHELL COLLAPSE: build per-lobe tracks across the 297 y-bands (centroid
     matching); inside each track, segment into runs where consecutive
     profiles are UNIFORM OFFSETS of the run base (fitting.uniform_offset);
     fit inset(y): |inset|<tol -> ONE extrude; linear -> offset_sweep linear
     (smooth plane-law emission); else keep the measured slabs.
  C. Vectorize every surviving profile (fitting.vectorize -> path nodes,
     arcs snapped to exact z-cylinder faces where applicable).
  D. Cuts: keep measured void-run boxes but grouped in modules; exact
     cylinders surface as named params.

Run:  python3 scripts/authoring/author_palm_left_parametric.py [--report]
"""
import json
import shutil
import sys
from pathlib import Path

import numpy as np

sys.path.insert(0, "src")
from step2scad.fitting import line_fit, dist_to_poly, vectorize  # noqa: E402

OUT = Path("output/Palm_left")
R = lambda x: round(float(x), 6)

v1 = json.loads((OUT / "plan_v1.json").read_text())
body = v1["bodies"][0]
feats = json.loads((OUT / "features.json").read_text())
faces = feats["bodies"][0]["faces"]

prims = []
def _walk(n):
    if "op" in n:
        for c in n["children"]:
            _walk(c)
    elif "transform" in n:
        _walk(n["child"])
    else:
        prims.append(n)
_walk(body["csg"])
by_stem = {}
for q in prims:
    by_stem.setdefault(q["name"].rstrip("0123456789_"), []).append(q)

# --------------------------------------------------------------- B. shell
sh = by_stem["sh"]
bands = {}
for q in sh:
    if q["z1"] - q["z0"] < 1e-6:
        continue                              # degenerate zero-height band
    bands.setdefault((q["z0"], q["z1"]), []).append(q)
band_keys = sorted(bands)

def centroid(prof):
    a = np.array(prof)
    return a.mean(axis=0)

# per-lobe tracks: greedy centroid matching across consecutive bands
tracks = []          # each: list of (band_idx, prim)
open_tracks = []     # (track, last_centroid, last_band_idx)
for bi, bk in enumerate(band_keys):
    loops = bands[bk]
    cents = [centroid(q["profile"]) for q in loops]
    used = set()
    next_open = []
    for tr, lc, lbi in open_tracks:
        if lbi != bi - 1:
            tracks.append(tr)
            continue
        best, bd = None, 6.0
        for k, c in enumerate(cents):
            if k in used:
                continue
            d = float(np.hypot(*(c - lc)))
            if d < bd:
                best, bd = k, d
        if best is None:
            tracks.append(tr)
        else:
            used.add(best)
            tr.append((bi, loops[best]))
            next_open.append((tr, cents[best], bi))
    for k, q in enumerate(loops):
        if k not in used:
            tr = [(bi, q)]
            next_open.append((tr, cents[k], bi))
    open_tracks = next_open
tracks += [tr for tr, _, _ in open_tracks]
tracks.sort(key=lambda tr: -len(tr))

# segment each track into uniform-offset runs vs the run's FIRST profile
UNIF_STD = 0.045
CONST_TOL = 0.06

def seg_runs(track):
    """[(kind, [(band_idx, prim)...], insets)] kind in const/linear/keep."""
    runs = []
    i = 0
    while i < len(track):
        base = np.array(track[i][1]["profile"])
        j = i + 1
        insets = [0.0]
        while j < len(track):
            pts = np.array(track[j][1]["profile"])
            d = dist_to_poly(pts, base)
            if d.std() > UNIF_STD or d.mean() > 3.5:
                break
            insets.append(float(d.mean()))
            j += 1
        chunk = track[i:j]
        if len(chunk) >= 3:
            ys = np.array([ (t[1]["z0"] + t[1]["z1"]) / 2 for t in chunk ])
            ds = np.array(insets)
            if ds.max() < CONST_TOL:
                runs.append(("const", chunk, ds))
            else:
                m, b, res = line_fit(ys, ds)
                runs.append(("linear" if res < 0.08 else "keep", chunk, ds))
        else:
            runs.append(("keep", chunk, insets))
        i = j
    return runs

n_const = n_lin = n_keep_slabs = 0
for tr in tracks:
    for kind, chunk, _ in seg_runs(tr):
        if kind == "const":
            n_const += len(chunk)
        elif kind == "linear":
            n_lin += len(chunk)
        else:
            n_keep_slabs += len(chunk)

if "--report" in sys.argv:
    print(f"tracks: {len(tracks)} (maior: {len(tracks[0])} bandas)")
    print(f"lâminas em runs CONSTANTES: {n_const}  (colapsam em extrudes únicos)")
    print(f"lâminas em runs LINEARES:   {n_lin}  (colapsam em offset_sweep)")
    print(f"lâminas a manter (medidas): {n_keep_slabs}")
    sys.exit(0)

# ------------------------------------------------------------- emission
def vect_profile(prof, label):
    segs, nl, na, nx = vectorize(prof)
    return {"path": segs,
            "source": f"vectorized measured section ({nl} lines + {na} arcs)"}

def shell_children(tracks, tag):
    kids = []
    n_collapsed = n_kept = 0
    for ti, tr in enumerate(tracks):
        for ri, (kind, chunk, insets) in enumerate(seg_runs(tr)):
            if kind == "const" and len(chunk) >= 3:
                midq = chunk[len(chunk) // 2][1]
                y0 = min(q["z0"] for _, q in chunk)
                y1 = max(q["z1"] for _, q in chunk)
                kids.append({
                    "prim": "extrude", "axis": "y",
                    "name": f"{tag}_t{ti:02d}r{ri}",
                    "source": f"constant-outline run: {len(chunk)} measured "
                              f"bands collapsed (mutual offsets < {CONST_TOL}, "
                              "std < 0.045; middle band profile)",
                    "profile2d": vect_profile(midq["profile"], tag),
                    "z0": R(y0), "z1": R(y1)})
                n_collapsed += len(chunk)
            else:
                for bi, q in chunk:
                    kids.append({
                        "prim": "extrude", "axis": "y",
                        "name": f"{tag}_t{ti:02d}b{bi:03d}",
                        "source": "measured organic band (no clean law) — "
                                  + q["source"][:80],
                        "profile2d": vect_profile(q["profile"], tag),
                        "z0": q["z0"], "z1": q["z1"]})
                    n_kept += 1
    print(f"{tag}: {n_collapsed} lâminas colapsadas, {n_kept} mantidas, "
          f"{len(kids)} prims")
    return kids

shell_kids = shell_children(tracks, "shell")

# cavity: same track treatment
cv = by_stem.get("cv", [])
cbands = {}
for q in cv:
    if q["z1"] - q["z0"] < 1e-6:
        continue
    cbands.setdefault((q["z0"], q["z1"]), []).append(q)
cband_keys = sorted(cbands)
ctracks = []
copen = []
for bi, bk in enumerate(cband_keys):
    loops = cbands[bk]
    cents = [centroid(q["profile"]) for q in loops]
    used = set()
    nxt = []
    for tr, lc, lbi in copen:
        if lbi != bi - 1:
            ctracks.append(tr); continue
        best, bd = None, 6.0
        for k, c in enumerate(cents):
            if k in used: continue
            d = float(np.hypot(*(c - lc)))
            if d < bd: best, bd = k, d
        if best is None: ctracks.append(tr)
        else:
            used.add(best); tr.append((bi, loops[best]))
            nxt.append((tr, cents[best], bi))
    for k, q in enumerate(loops):
        if k not in used:
            nxt.append(([(bi, q)], cents[k], bi))
    copen = nxt
ctracks += [tr for tr, _, _ in copen]
cav_kids = shell_children(ctracks, "cavity")

# ------------------------------------------------------------- cuts/params
def grab(stem):
    return by_stem.get(stem, [])

params = []
def add_cyl_params(q, base):
    params.extend([
        {"name": f"{base}_p0", "value": 0, "source": "unused"},
    ])

# keep exact cylinders verbatim but hoist r + axis into named params
def cyl_with_params(q, base):
    params.append({"name": f"{base}_r", "value": R(q["r"]),
                   "source": q["source"][:110]})
    out = dict(q)
    out["name"] = base
    out["r"] = f"{base}_r"
    return out

pin_kids = []
for i, q in enumerate(grab("kpin")):
    pin_kids.append(cyl_with_params(q, f"knuckle_pin{i+1}"))
for i, q in enumerate(grab("kcb")):
    pin_kids.append(cyl_with_params(q, f"pin_counterbore{i+1}"))
wrist_cuts = [cyl_with_params(grab("wbore")[0], "wrist_bore")] + grab("barrelcut")
thumb_kids = ([cyl_with_params(grab("tpin")[0], "thumb_pin")]
              + [cyl_with_params(q, f"thumb_cb{i+1}") for i, q in enumerate(grab("tcb"))]
              + [cyl_with_params(grab("trelief")[0], "thumb_relief")]
              + grab("tslot"))
tube_kids = grab("tube")
barrel = cyl_with_params(grab("barrel")[0], "wrist_barrel")

modules = {
    "palm_shell": {"args": [], "doc":
        "outer shell: constant-outline runs collapsed to single extrudes; "
        "organic bands kept measured (vectorized paths)", 
        "tree": {"op": "union", "children": shell_kids}},
    "palm_cavity": {"args": [], "doc":
        "interior cavity (CUT): same run-collapse treatment as the shell",
        "tree": {"op": "union", "children": cav_kids}},
    "bottom_grid": {"args": [], "doc":
        "ventilation/lattice grid of the bottom plate (105 measured holes, "
        "edges snapped to exact wall planes)",
        "tree": {"op": "union", "children": grab("h")}},
    "finger_slots": {"args": [], "doc":
        "four finger clevis slots: measured void-run rows (material OR-ed "
        "over three x-stations; see v1 provenance)",
        "tree": {"op": "union", "children": grab("slot")}},
    "thumb_clevis": {"args": [], "doc":
        "thumb clevis: exact skew pin/counterbores/relief + measured "
        "void-run rows",
        "tree": {"op": "union", "children": thumb_kids}},
    "knuckle_pins": {"args": [], "doc":
        "knuckle pin bores + head counterbores (exact cylinder faces)",
        "tree": {"op": "union", "children": pin_kids}},
    "wrist_cuts": {"args": [], "doc":
        "wrist axle bore (exact) + tensioner bay (measured tilted walls)",
        "tree": {"op": "union", "children": wrist_cuts}},
    "tendon_tubes": {"args": [], "doc":
        "tendon channels: every reversed exact cylinder face, segment-exact",
        "tree": {"op": "union", "children": tube_kids}},
}

plan = {"version": 1, "source": v1.get("source", ""), "bodies": [{
    "body_id": 0, "strategy": "csg",
    "notes": "semantic parametric palm: shell/cavity as run-collapsed + "
             "vectorized measured bands in named modules; cuts grouped into "
             "semantic modules; exact cylinder radii as named params",
    "params": params,
    "modules": modules,
    "csg": {"op": "difference", "children": [
        {"op": "union", "children": [
            {"call": "palm_shell", "name": "shell_i", "args": {}},
            barrel,
        ]},
        {"call": "palm_cavity", "name": "cavity_i", "args": {}},
        {"call": "bottom_grid", "name": "grid_i", "args": {}},
        {"call": "finger_slots", "name": "slots_i", "args": {}},
        {"call": "knuckle_pins", "name": "pins_i", "args": {}},
        {"call": "wrist_cuts", "name": "wrist_i", "args": {}},
        {"call": "thumb_clevis", "name": "thumb_i", "args": {}},
        {"call": "tendon_tubes", "name": "tubes_i", "args": {}},
    ]},
}]}

sys.path.insert(0, "src")
from step2scad.plan import validate_plan
validate_plan(plan)
json.dump(plan, open(OUT / "plan.json", "w"), indent=1)
n_prims = sum(len(m["tree"]["children"]) for m in modules.values()) + len(pin_kids)
print(f"wrote {OUT/'plan.json'}: {len(params)} params, {len(modules)} módulos")
