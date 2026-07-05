"""Author the SEMANTIC PARAMETRIC Arm_Guard plan (schema v2).

Reads the measured band-stack plan (kept as plan_bandstack.json) + the exact
B-rep features, and re-expresses the part in human-editable form:

  PARAMS   exact z levels (plate step/top, slot & window cut tops), slot end
           radius and the 8 exact slot end-cap centers, window z reach
  MODULES  strap_slot(x0,y0,x1,y1): capsule = hull of two parametric
           cylinders between z_cut_lo..z_slot_top (edit slot_r and every slot
           widens; edit a cap coordinate and that slot moves/stretches)
           plate(): two profile layers between exact z params
           deck_ridge(): the organic pad/ridge staircase (measured profiles,
           grouped and commented — heights measured, shapes organic)
  CUTS     4 strap_slot calls + 2 pin-window profile cuts

Every number remains a measured value with provenance. Run:
    python3 scripts/authoring/author_armguard_parametric.py
"""
import json
import shutil
import sys
from pathlib import Path

import numpy as np

sys.path.insert(0, "src")
from step2scad.plan import validate_plan

OUT = Path("output/Arm_Guard")
R = lambda x: round(float(x), 6)

# ---- measurement sources ---------------------------------------------------
band_path = OUT / "plan_bandstack.json"
if not band_path.exists():                  # first run: preserve the band plan
    shutil.copy(OUT / "plan.json", band_path)
bands = json.load(open(band_path))
feats = json.load(open(OUT / "features.json"))
faces = feats["bodies"][0]["faces"]

prims = []
def _walk(n):
    if "op" in n:
        for c in n["children"]:
            _walk(c)
    else:
        prims.append(n)
_walk(bands["bodies"][0]["csg"])
outers = [p for p in prims if "(hole loop)" not in p["source"]]
holes = [p for p in prims if "(hole loop)" in p["source"]]

# ---- exact slot geometry: the 8 r=2.0 vertical end-cap cylinder faces ------
caps = []
for f in faces:
    if f["type"] != "cylinder":
        continue
    p = f["params"]
    if (abs(p["radius"] - 2.0) < 1e-6 and abs(abs(p["axis_dir"][2]) - 1) < 1e-6
            and f["orientation"] == "reversed"):
        caps.append((f["index"], p["axis_origin"][0], p["axis_origin"][1]))
assert len(caps) == 8, f"expected 8 slot end caps, got {len(caps)}"
slot_r = 2.0
left = sorted([c for c in caps if c[1] < 0], key=lambda c: c[2])
right = sorted([c for c in caps if c[1] > 0], key=lambda c: c[2])
slots = [(left[0], left[1]), (left[2], left[3]),
         (right[0], right[1]), (right[2], right[3])]
slot_names = ["slotL_low", "slotL_high", "slotR_low", "slotR_high"]

# shared slot geometry (v13 style): centers + one len/angle; verify symmetry
def slot_cla(pair):
    (i0, x0, y0), (i1, x1, y1) = pair
    d = np.array([x1 - x0, y1 - y0])
    return (np.array([(x0 + x1) / 2, (y0 + y1) / 2]),
            float(np.linalg.norm(d) + 2 * slot_r),
            float(-np.degrees(np.arctan2(d[0], d[1]))))
cL = [slot_cla(slots[0]), slot_cla(slots[1])]
cR = [slot_cla(slots[2]), slot_cla(slots[3])]
slot_len = cL[0][1]
slot_ang = -cL[0][2]           # left slots tilt -ang; right side mirrors
assert all(abs(c[1] - slot_len) < 0.02 for c in cL + cR), "slot lengths differ"
assert all(abs(abs(c[2]) - slot_ang) < 0.05 for c in cL + cR), "slot angles differ"
for l, r in zip(cL, cR):       # exact L/R mirror symmetry
    assert abs(l[0][0] + r[0][0]) < 0.02 and abs(l[0][1] - r[0][1]) < 0.02, \
        "slots are not mirror-symmetric"


def near_slot(cx, cy):
    for (i0, x0, y0), (i1, x1, y1) in slots:
        a, b, q = np.array([x0, y0]), np.array([x1, y1]), np.array([cx, cy])
        t = np.clip(np.dot(q - a, b - a) / np.dot(b - a, b - a), 0, 1)
        if np.linalg.norm(q - (a + t * (b - a))) < slot_r + 1.5:
            return True
    return False

# ---- classify measured hole loops: slot-covered / pin windows --------------
win_profiles = {}
misc = []
z_hole_top = 0.0
for h in holes:
    pts = np.array(h["profile"])
    cx, cy = pts.mean(axis=0)
    z_hole_top = max(z_hole_top, h["z1"])
    if near_slot(cx, cy):
        continue                              # replaced by the slot module
    key = "winL" if cx < 0 else "winR"
    # keep the SMALLEST measured loop per window: it is the true wall footprint;
    # upper bands are flared by the 45° edge chamfer and would overcut if used
    def _area(q):
        a = np.array(q)
        return 0.5 * abs(np.dot(a[:, 0], np.roll(a[:, 1], 1))
                         - np.dot(a[:, 1], np.roll(a[:, 0], 1)))
    if key not in win_profiles or _area(pts) < _area(win_profiles[key]["profile"]):
        win_profiles[key] = h
    if not (25 < abs(cx) < 36 and cy > 28):
        misc.append(h)
assert not misc, f"unclassified hole loops: {[(m['name']) for m in misc]}"

# window z reach = the highest band a window hole appears in
win_top = max(h["z1"] for h in holes
              if not near_slot(*np.array(h["profile"]).mean(axis=0)))
slot_top = max(h["z1"] for h in holes
               if near_slot(*np.array(h["profile"]).mean(axis=0)))

# ---- plate layers + organic deck/ridge stack --------------------------------
outers.sort(key=lambda p: p["z0"])
z_base = outers[0]["z0"]
plate = [p for p in outers if p["z1"] <= 1.402]
deck = [p for p in outers if p["z0"] >= 1.401]
z_plate_step, z_plate_top = 0.901317, 1.401317   # exact B-rep plane levels
def _parea(p):
    a = np.array(p["profile"])
    return 0.5 * abs(np.dot(a[:, 0], np.roll(a[:, 1], 1))
                     - np.dot(a[:, 1], np.roll(a[:, 0], 1)))

# fully-developed outline = the LARGEST measured footprint of each layer
lowers = sorted((p for p in plate if p["z1"] <= z_plate_step + 1e-4),
                key=lambda p: p["z0"])
main = max(lowers, key=_parea)
# bands below the fully-developed outline are the rounded bottom rim: keep
# them as measured layers (organic edge), parametrize only the main body
rim = [p for p in lowers if p["z1"] <= main["z0"] + 1e-4 and _parea(p) < _parea(main) - 1.0]
z_main_lo = R(max((p["z1"] for p in rim), default=z_base))

def _inset_of(band, ref_pts):
    """Mean boundary distance of a rim band to the main outline (validated
    uniform: std < 0.05 -> the band IS an offset() of the outline)."""
    pts = np.array(band["profile"])
    a = ref_pts; b = np.roll(ref_pts, -1, axis=0)
    d = np.full(len(pts), np.inf)
    for A, B in zip(a, b):
        AB = B - A
        L2 = AB @ AB
        if L2 < 1e-12:
            continue
        tt = np.clip(((pts - A) @ AB) / L2, 0, 1)
        proj = A + tt[:, None] * AB
        d = np.minimum(d, np.linalg.norm(pts - proj, axis=1))
    assert d.std() < 0.05, f"{band['name']}: rim not a uniform offset (std {d.std():.3f})"
    return float(d.mean())

main_pts = np.array(main["profile"])
rim_insets = [(_inset_of(b, main_pts), b) for b in rim]
upper = max((p for p in plate if p["z0"] >= z_plate_step - 1e-4), key=_parea)

params = [
    {"name": "z_base", "value": R(z_base),
     "source": "exact B-rep bottom plane level"},
    {"name": "z_plate_step", "value": R(z_plate_step),
     "source": "exact B-rep plane: outline steps in at this level"},
    {"name": "z_plate_top", "value": R(z_plate_top),
     "source": "exact B-rep plane: top of the flat plate, deck pads start"},
    {"name": "slot_r", "value": R(slot_r),
     "source": "exact r2.0 slot end-cap cylinder faces "
               + "/".join(f"#{c[0]}" for c in caps)},
    {"name": "z_slot_top", "value": R(slot_top),
     "source": "highest measured band pierced by the strap slots"},
    {"name": "z_window_top", "value": R(win_top),
     "source": "highest measured band pierced by the mount pin windows"},
    {"name": "z_cut_lo", "value": R(z_base - 0.5),
     "source": "cut overshoot below the base plane (declared, 0.5)"},
]
for i, (ins, b) in enumerate(rim_insets):
    params.append({"name": f"rim_inset{i}", "value": R(ins),
                   "source": "measured: mean boundary distance of rim band "
                             f"{b['name']} to the main outline (uniform, std<0.05)"})
cap_ids = "/".join(f"#{c[0]}" for c in caps)
params += [
    {"name": "slot_len", "value": R(slot_len),
     "source": f"distance between exact end-cap axes + 2*slot_r (faces {cap_ids}); "
               "identical for all four slots within 0.02"},
    {"name": "slot_ang", "value": R(slot_ang),
     "source": "slot line angle from +Y (exact end-cap axes); the right side "
               "mirrors the left exactly"},
    {"name": "slot_low_cx", "value": R(cL[0][0][0]),
     "source": "midpoint of the lower-left slot's exact end-cap axes"},
    {"name": "slot_low_cy", "value": R(cL[0][0][1]),
     "source": "midpoint of the lower-left slot's exact end-cap axes"},
    {"name": "slot_high_cx", "value": R(cL[1][0][0]),
     "source": "midpoint of the upper-left slot's exact end-cap axes"},
    {"name": "slot_high_cy", "value": R(cL[1][0][1]),
     "source": "midpoint of the upper-left slot's exact end-cap axes"},
]

def layer(p, note, name=None):
    return {"prim": "extrude", "axis": "z", "name": name or p["name"],
            "source": note + " — " + p["source"],
            "profile": p["profile"], "z0": p["z0"], "z1": p["z1"]}


# ---- primitive recognition over the organic deck layers ---------------------
# The measured band loops hide exact primitives: the knuckle-mount posts are
# the exact r7.995 cylinder faces (with a blended top we approximate as a
# measured frustum), and the crest dome is the exact B-rep sphere face #1.
sphere_face = next(f for f in faces if f["type"] == "sphere")
sph_c, sph_r = sphere_face["params"]["center"], sphere_face["params"]["radius"]

MOUNT_Y, MOUNT_R = 35.5048, 7.995          # exact cylinder faces #92/#98
Z_MOUNT_CHAM = R(10.796450 - MOUNT_R)      # exact: 45° cone meets the cylinder
Z_MOUNT_TOP = 3.801317                     # exact B-rep plane level


def circle_fit(pts):
    c = pts.mean(axis=0)
    for _ in range(20):
        d = np.linalg.norm(pts - c, axis=1)
        c = c + ((pts - c) / d[:, None] * (d - d.mean())[:, None]).mean(axis=0)
    d = np.linalg.norm(pts - c, axis=1)
    return c, float(d.mean()), float(np.ptp(d))


def classify_deck(p):
    pts = np.array(p["profile"])
    cx, cy = pts.mean(axis=0)
    c, r, dev = circle_fit(pts)
    if dev < 0.1 and np.hypot(c[0] - sph_c[0], c[1] - sph_c[1]) < 0.5:
        return "sphere", None
    if dev < 0.1 and abs(abs(c[0]) - 30.145) < 0.3 and abs(c[1] - MOUNT_Y) < 0.3:
        return "mount_circle", (float(c[0]), (p["z0"] + p["z1"]) / 2, r)
    if np.hypot(abs(cx) - 30.145, cy - MOUNT_Y) < 10:
        return "mount_skirt_" + ("L" if cx < 0 else "R"), None
    if abs(cx) < 10:
        return "ridge", None
    return "rail_hump_" + ("L" if cx < 0 else "R"), None

modules = {
    "strap_slot": {
        "args": [],
        "doc": "strap slot at the origin, long axis +Y: capsule = hull of the "
               "two end-cap cylinders; slot_r sets width (4 = 2*slot_r), "
               "slot_len the length, z_slot_top the depth. Instances are "
               "placed by translate+rotate and the right side by mirror.",
        "tree": {"op": "hull", "children": [
            {"prim": "cylinder", "name": "cap0",
             "source": "slot end cap (exact r2.0 cylinder faces)",
             "p0": [0, "slot_len/2 - slot_r", "z_cut_lo"],
             "p1": [0, "slot_len/2 - slot_r", "z_slot_top"], "r": "slot_r"},
            {"prim": "cylinder", "name": "cap1",
             "source": "slot end cap (exact r2.0 cylinder faces)",
             "p0": [0, "-(slot_len/2 - slot_r)", "z_cut_lo"],
             "p1": [0, "-(slot_len/2 - slot_r)", "z_slot_top"], "r": "slot_r"},
        ]},
    },
    "plate": {
        "args": [],
        "doc": "base plate: measured outline in two layers between exact z "
               "levels (the outline includes the two r7.995 knuckle-mount "
               "lobes at (±30.145, 35.505))",
        "tree": {"op": "union", "children":
            [{"prim": "extrude", "axis": "z", "name": f"plate_rim{i}",
              "source": "bottom edge round: measured as a uniform inset of "
                        f"the shared outline (std < 0.05) — {b['source']}",
              "profile2d": {"op2d": "offset", "delta": f"-rim_inset{i}",
                            "child": {"ref": "plate_outline"}},
              "z0": b["z0"], "z1": b["z1"]}
             for i, (_, b) in enumerate(rim_insets)]
            + [
            {"prim": "extrude", "axis": "z", "name": "plate_main",
             "source": "plate main body: shared measured outline — " + main["source"],
             "profile2d": {"ref": "plate_outline"},
             "z0": z_main_lo, "z1": "z_plate_step"},
            {"prim": "extrude", "axis": "z", "name": "plate_upper",
             "source": "plate upper layer (outline after the step) — " + upper["source"],
             "profile2d": {"ref": "plate_upper_outline"},
             "z0": "z_plate_step", "z1": "z_plate_top"},
        ]},
    },
    "knuckle_mount": {
        "args": ["cx"],
        "doc": "knuckle-mount post: exact r7.995 cylinder up to the exact "
               "blend-start level, then the convex top blend as measured "
               "frustum segments between exact B-rep plane levels (the true "
               "face is a torus fillet; radii are band circle-fit values)",
        "tree": {"op": "union", "children": [
            {"prim": "cylinder", "name": "post",
             "source": "exact cylinder faces #92/#98 (r=7.995) at y=35.5048",
             "p0": ["cx", "mount_y", "z_plate_top"],
             "p1": ["cx", "mount_y", "z_blend0"], "r": "mount_r"},
        ]},   # blend segments appended below from measured radii
    },
    "deck_ridge": {
        "args": [],
        "doc": "raised deck pads, mount skirts and central ridge: organic "
               "45-degree blends kept as measured layers with semantic names "
               "(base/top heights are exact B-rep plane levels)",
        "tree": {"op": "union", "children": []},   # filled below
    },
}

# classify every deck layer: exact-primitive layers are REPLACED, the organic
# remainder keeps measured profiles under semantic names
counters = {}
deck_children = []
mount_top_samples = []
for p in deck:
    kind, extra = classify_deck(p)
    if kind == "sphere":
        continue                                   # replaced by the exact sphere
    if kind == "mount_circle":
        mount_top_samples.append(extra)            # replaced by knuckle_mount()
        continue
    counters[kind] = counters.get(kind, 0) + 1
    deck_children.append(layer(
        p, f"{kind.replace('_', ' ')} (measured organic layer)",
        name=f"{kind}_l{counters[kind]:02d}"))
modules["deck_ridge"]["tree"]["children"] = deck_children

# top blend: measured band circle radii interpolated at the EXACT B-rep plane
# levels between the bands → chain of frustum segments (both mounts share it)
# both mounts sample the same bands — average the two radii per z level
by_z = {}
for _, z, r in mount_top_samples:
    by_z.setdefault(round(z, 3), []).append(r)
zs_m = np.array(sorted(by_z))
rs_m = np.array([float(np.mean(by_z[z])) for z in sorted(by_z)])
blend_levels = [Z_MOUNT_CHAM, 2.881317, 3.111317, 3.341317, 3.571317,
                R(Z_MOUNT_TOP)]                    # exact plane levels
slope, icept = np.polyfit(zs_m[-2:], rs_m[-2:], 1)  # tail slope for the ends
def r_at(z):
    if z <= zs_m[0]:
        return MOUNT_R                              # tangent to the cylinder
    if z >= zs_m[-1]:
        return float(slope * z + icept)
    return float(np.interp(z, zs_m, rs_m))
blend_r = [R(r_at(z)) for z in blend_levels]
blend_r[0] = R(MOUNT_R)

params += [
    {"name": "mount_y", "value": R(MOUNT_Y),
     "source": "exact mount cylinder faces #92/#98 axis y"},
    {"name": "mountL_x", "value": -30.145,
     "source": "exact mount cylinder face #98 axis x"},
    {"name": "mountR_x", "value": 30.145,
     "source": "exact mount cylinder face #92 axis x"},
    {"name": "mount_r", "value": R(MOUNT_R),
     "source": "exact mount cylinder faces #92/#98 radius"},
]
for k, (z, r) in enumerate(zip(blend_levels, blend_r)):
    params.append({"name": f"z_blend{k}", "value": R(z),
                   "source": "exact B-rep plane level (mount top-blend band)"
                   if 0 < k < len(blend_levels) - 1 else
                   ("exact: 45° cone faces #29/#105 meet the mount cylinder"
                    if k == 0 else "exact B-rep plane: top of the knuckle mounts")})
    params.append({"name": f"mount_rb{k}", "value": r,
                   "source": "exact mount cylinder radius (blend tangent)" if k == 0
                   else "measured: mount top-blend circle fit at this level"})
for k in range(len(blend_levels) - 1):
    modules["knuckle_mount"]["tree"]["children"].append(
        {"prim": "cylinder", "name": f"blend{k}",
         "source": "mount top blend segment (measured frustum between exact "
                   "plane levels; true face is a torus fillet)",
         "p0": ["cx", "mount_y", f"z_blend{k}"],
         "p1": ["cx", "mount_y", f"z_blend{k + 1}"],
         "r": f"mount_rb{k}", "r2": f"mount_rb{k + 1}"})

crest_dome = {"prim": "sphere", "name": "crest_dome",
              "source": f"exact B-rep sphere face #{sphere_face['index']} "
                        "(tactile dome on the ridge crest)",
              "center": [R(v) for v in sph_c], "r": R(sph_r)}

def slot_instance(tag, cx, cy):
    return {"transform": {"translate": [cx, cy, 0],
                          "rotate_deg": [0, 0, "-slot_ang"]},
            "name": tag,
            "child": {"call": "strap_slot", "name": f"{tag}_i", "args": {}}}

left_slots = {"op": "union", "children": [
    slot_instance("slotL_low", "slot_low_cx", "slot_low_cy"),
    slot_instance("slotL_high", "slot_high_cx", "slot_high_cy")]}
right_slots = {"transform": {"mirror": [1, 0, 0]}, "name": "slots_right",
               "child": {"op": "union", "children": [
                   slot_instance("slotR_low", "slot_low_cx", "slot_low_cy"),
                   slot_instance("slotR_high", "slot_high_cx", "slot_high_cy")]}}
cuts = [left_slots, right_slots]
for key, h in win_profiles.items():
    cuts.append({"prim": "extrude", "axis": "z", "name": f"pin_window_{key[-1]}",
                 "source": "knuckle-mount pin window: measured wall loop — "
                           + h["source"],
                 "profile": h["profile"], "z0": "z_cut_lo", "z1": "z_window_top"})

plan = {"version": 1, "source": feats["source"], "bodies": [{
    "body_id": 0, "strategy": "csg",
    "notes": "semantic parametric form: named z levels, parametric strap-slot "
             "module (4 instances), plate as two exact-z layers, organic "
             "deck/ridge staircase preserved as measured profiles; hole-edge "
             "chamfers deliberately omitted (sub-1% volume)",
    "params": params,
    "profiles": {"plate_outline": main["profile"],
                 "plate_upper_outline": upper["profile"]},
    "modules": modules,
    "csg": {"op": "difference", "children": [
        {"op": "union", "children": [
            {"call": "plate", "name": "plate_i", "args": {}},
            {"call": "deck_ridge", "name": "deck_i", "args": {}},
            {"call": "knuckle_mount", "name": "mount_left",
             "args": {"cx": "mountL_x"}},
            {"call": "knuckle_mount", "name": "mount_right",
             "args": {"cx": "mountR_x"}},
            crest_dome,
        ]}] + cuts},
}]}
validate_plan(plan)
json.dump(plan, open(OUT / "plan.json", "w"), indent=1)
print(f"wrote {OUT/'plan.json'}: {len(params)} params, {len(modules)} modules, "
      f"{len(cuts)} cuts, {len(deck)} organic layers "
      f"(band plan preserved at {band_path.name})")
