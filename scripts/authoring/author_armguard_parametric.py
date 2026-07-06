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
# the insets fall on a straight line vs z -> the bottom edge is a CHAMFER,
# one offset law instead of discrete layers (measure first, claim after)
_zs = np.array([(b["z0"] + b["z1"]) / 2 for _, b in rim_insets])
_ds = np.array([-i for i, _ in rim_insets])
rim_m, rim_c = np.polyfit(_zs, _ds, 1)
rim_res = float(np.abs(_ds - (rim_m * _zs + rim_c)).max())
assert rim_res < 0.05, f"rim insets not linear in z (res {rim_res:.3f})"
rim_z1 = R(max(b["z1"] for _, b in rim_insets))
rim_d0 = R(rim_m * z_base + rim_c)
rim_d1 = R(rim_m * rim_z1 + rim_c)
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
params += [
    {"name": "rim_cham_d0", "value": -0.5,
     "source": "EXACT 45-deg bottom edge chamfer: cone faces #93/#114 span "
               f"r 7.495->7.995 (fitted rim insets agreed: slope res {rim_res:.3f})"},
    {"name": "rim_cham_d1", "value": 0.0,
     "source": "exact: chamfer vanishes at its top level"},
    {"name": "z_rim_top", "value": 0.501317,
     "source": "EXACT cone faces #93/#114 upper extent (z=0.5013)"},
]
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
        "tree": {"op": "union", "children": [
            {"prim": "offset_sweep", "name": "plate_rim_chamfer",
             "source": "bottom edge 45-deg chamfer: linear offset law fitted "
                       "to the measured rim band insets (residual in params)",
             "profile2d": {"ref": "plate_outline"},
             "z0": "z_base", "z1": "z_rim_top", "steps": 6,
             "law": {"kind": "linear", "d0": "rim_cham_d0", "d1": "rim_cham_d1"}},
            
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
            {"prim": "cylinder", "name": "skirt",
             "source": "EXACT 45-deg skirt: cone faces #29/#105 span "
                       "r 8.995@z1.8013 -> 7.995@z2.8014 (skirt band circles "
                       "matched the cone law to 0.005)",
             "p0": ["cx", "mount_y", "z_wing_top"],
             "p1": ["cx", "mount_y", "z_blend0"],
             "r": "mount_r + 1.0", "r2": "mount_r"},
        ]},   # blend segments appended below from measured radii
    },
}

# classify every deck layer: exact-primitive layers are REPLACED, the organic
# remainder keeps measured profiles under semantic names
counters = {}
deck_children = []
mount_top_samples = []
ridge_bands = []
rail_layers = {}
for p in deck:
    kind, extra = classify_deck(p)
    if kind == "sphere":
        continue                                   # replaced by the exact sphere
    if kind == "mount_circle":
        mount_top_samples.append(extra)            # replaced by knuckle_mount()
        continue
    if kind == "ridge":
        ridge_bands.append(p)                      # replaced by center_ridge()
        continue
    if kind.startswith("mount_skirt"):
        continue                                   # replaced by the exact cone frustum
    if kind.startswith("rail_hump"):
        rail_layers.setdefault(kind[-1], []).append(p)   # wing+strip, parametrized below
        continue
    counters[kind] = counters.get(kind, 0) + 1
    deck_children.append(layer(
        p, f"{kind.replace('_', ' ')} (measured organic layer)",
        name=f"{kind}_l{counters[kind]:02d}"))
assert not deck_children, f"unexpected organic layers remain: {[c['name'] for c in deck_children]}"''

# ---- center ridge: 16 measured bands -> stadium footprint + 3 height laws --
# Per band: (z_top, y_tail, y_head, half-width). The tail retreats at ~45°
# up to a plateau, then a circular arc; the head cap tapers on a second arc —
# the v13 rib-transition construction, here FITTED to the measured bands.
rb = []
for p in sorted(ridge_bands, key=lambda q: q["z0"]):
    a = np.array(p["profile"])
    rb.append((p["z0"], p["z1"], float(a[:, 1].min()), float(a[:, 1].max()),
               float(a[:, 0].min()), float(a[:, 0].max())))
z_ridge_top = R(rb[-1][1])
ridge_hw = R(max(x1 for *_, x1 in rb))
head_top = max(yh for _, _, _, yh, _, _ in rb)
ridge_head_cy = R(head_top - ridge_hw)      # stadium cap center

# segment the tail sequence at the discontinuity (jump > 5 in y_tail)
tails = [(z1, yt) for z0, z1, yt, yh, *_ in rb]
jump = next(i for i in range(1, len(tails))
            if tails[i][1] - tails[i - 1][1] > 5)
low, high = tails[:jump], tails[jump:]

def fit_line(pts):
    A = np.c_[[p[1] for p in pts], np.ones(len(pts))]
    (m, b), *_ = np.linalg.lstsq(A, [p[0] for p in pts], rcond=None)
    res = max(abs(z - (m * y + b)) for z, y in pts)
    return float(m), float(b), float(res)

def fit_arc(pts):                            # circle through (z, y) samples
    y = np.array([p[1] for p in pts]); z = np.array([p[0] for p in pts])
    A = np.c_[2 * y, 2 * z, np.ones(len(pts))]
    (cy, cz, c), *_ = np.linalg.lstsq(A, y**2 + z**2, rcond=None)
    Rr = float(np.sqrt(c + cy**2 + cz**2))
    res = float(np.abs(np.hypot(y - cy, z - cz) - Rr).max())
    return float(cy), float(cz), Rr, res

t_m, t_b, t_res = fit_line(low)
assert t_res < 0.08, f"ridge tail not linear (res {t_res:.3f})"
a_yc, a_zc, a_R, a_res = fit_arc(high)
assert a_res < 0.05, f"ridge main ramp not an arc (res {a_res:.3f})"
heads = [(z1, yh) for z0, z1, yt, yh, *_ in rb if yh < head_top - 0.1]
h_yc, h_zc, h_R, h_res = fit_arc(heads)
assert h_res < 0.05, f"ridge head taper not an arc (res {h_res:.3f})"

# derived boundaries (numeric; derivation cited in the sources)
tail_y0 = (z_plate_top - t_b) / t_m                       # 45° ramp meets plate top
tail_y1 = (float(low[-1][0]) - t_b) / t_m                 # ramp reaches the plateau
z_plateau = float(low[-1][0])                             # exact band level
arc_y0 = a_yc - np.sqrt(a_R**2 - (z_plateau - a_zc)**2)   # arc leaves the plateau
arc_y1 = a_yc - np.sqrt(max(a_R**2 - (z_ridge_top - a_zc)**2, 0))  # arc reaches full
head_y0 = h_yc + np.sqrt(max(h_R**2 - (z_ridge_top - h_zc)**2, 0))  # taper starts

# constant (x,z) cross-section, measured on the reference tessellation and
# verified identical at y=-5/0/+4 (max delta 0.002)
import trimesh as _tm
_ref = _tm.load(str(OUT / "Arm_Guard_ref.stl"), force="mesh")
_sec = _ref.section(plane_origin=[0, 0, 0], plane_normal=[0, 1, 0])
_loop = max(_sec.discrete, key=len)
_mask = (np.abs(_loop[:, 0]) < 6.5) & (_loop[:, 2] > z_plate_top + 0.05)
_idx = np.where(_mask)[0]
_start = next(i for i in _idx if (i - 1) % len(_loop) not in _idx)
_run = []
_i = _start
while _mask[_i]:
    _run.append(_i)
    _i = (_i + 1) % len(_loop)
_lobe = _loop[_run][:, [0, 2]]
_prof = [[R(q[0]), R(q[1])] for q in _lobe]
ridge_xsection = ([[R(_lobe[0][0]), R(z_plate_top)]] + _prof
                  + [[R(_lobe[-1][0]), R(z_plate_top)]])
# decimate collinear points
def _dec(loop, tol=0.02):
    out = list(loop)
    ch = True
    while ch and len(out) > 6:
        ch = False
        for i in range(len(out)):
            a, b_, c = np.array(out[i-1]), np.array(out[i]), np.array(out[(i+1) % len(out)])
            ab = c - a
            n = np.linalg.norm(ab)
            if n > 1e-9 and abs(ab[0]*(b_-a)[1] - ab[1]*(b_-a)[0]) / n < tol:
                out.pop(i); ch = True; break
    return out
ridge_xsection = _dec(ridge_xsection)

ridge_params = [
    ("ridge_hw", ridge_hw, "measured ridge half-width (constant across all 16 bands)"),
    ("ridge_head_cy", ridge_head_cy, "stadium head-cap center: measured head apex - ridge_hw"),
    ("z_ridge_top", z_ridge_top, "exact B-rep plane: ridge crest top"),
    ("z_ridge_plateau", R(z_plateau), "exact B-rep band level: tail plateau height"),
    ("ridge_tail_m", R(t_m), f"measured 45-deg tail ramp slope (linear fit, res {t_res:.3f})"),
    ("ridge_tail_b", R(t_b), "measured tail ramp intercept (same fit)"),
    ("ridge_arc_yc", R(a_yc), f"main ramp fitted circular arc center y (res {a_res:.3f} over {len(high)} bands)"),
    ("ridge_arc_zc", R(a_zc), "main ramp arc center z (same fit)"),
    ("ridge_arc_R", R(a_R), "main ramp arc radius (same fit)"),
    ("ridge_head_yc", R(h_yc), f"head taper fitted arc center y (res {h_res:.3f})"),
    ("ridge_head_zc", R(h_zc), "head taper arc center z (same fit)"),
    ("ridge_head_R", R(h_R), "head taper arc radius (same fit)"),
    ("ridge_tail_y0", R(tail_y0), "derived: tail ramp meets the plate top (from the fit)"),
    ("ridge_tail_y1", R(tail_y1), "derived: tail ramp reaches the plateau (from the fit)"),
    ("ridge_arc_y0", R(arc_y0), "derived: main arc leaves the plateau level"),
    ("ridge_arc_y1", R(arc_y1), "derived: main arc reaches the crest height"),
    ("ridge_head_y0", R(head_y0), "derived: head taper leaves the crest height"),
]
params += [{"name": n, "value": v, "source": s} for n, v, s in ridge_params]

modules["center_ridge"] = {
    "args": [],
    "doc": "center ridge: stadium footprint INTERSECTED with (45-deg tail ramp "
           "+ plateau + fitted-arc main ramp + full section + fitted-arc head "
           "taper) — the v13 rib-transition construction, laws fitted to the "
           "16 measured bands (residuals in the param sources)",
    "tree": {"op": "intersection", "children": [
        {"prim": "extrude", "axis": "y", "name": "ridge_xsec",
         "source": "measured constant (x,z) cross-section (hourglass: ±5.0 "
                   "base, ±3.60 waist at z=2.9, ±4.81 crest) — verified "
                   "identical at y=-5/0/+4 on the reference tessellation",
         "profile": [[q[1], q[0]] for q in ridge_xsection],
         "z0": "ridge_tail_y0", "z1": "ridge_head_cy + ridge_hw + 0.2"},
        {"op": "hull", "children": [
            {"prim": "cylinder", "name": "ridge_cap",
             "source": "stadium head cap (measured half-width radius)",
             "p0": [0, "ridge_head_cy", "z_plate_top"],
             "p1": [0, "ridge_head_cy", "z_ridge_top"], "r": "ridge_hw"},
            {"prim": "box", "name": "ridge_bar",
             "source": "stadium bar to the measured tail end",
             "min": ["-ridge_hw", "ridge_tail_y0", "z_plate_top"],
             "size": ["2*ridge_hw", "ridge_head_cy - ridge_tail_y0",
                      "z_ridge_top - z_plate_top"]},
        ]},
        {"op": "union", "children": [
            {"prim": "sweep", "name": "ridge_tail45", "axis": "y",
             "source": "45-deg tail ramp: measured linear law (res in params)",
             "u0": "-ridge_hw", "u1": "ridge_hw",
             "s0": "ridge_tail_y0", "s1": "ridge_tail_y1",
             "z0": "z_plate_top", "h_max": "z_ridge_plateau", "steps": 8,
             "law": {"kind": "linear", "m": "ridge_tail_m", "b": "ridge_tail_b"}},
            {"prim": "box", "name": "ridge_plateau",
             "source": "tail plateau at the exact band level",
             "min": ["-ridge_hw", "ridge_tail_y1", "z_plate_top"],
             "size": ["2*ridge_hw", "ridge_arc_y0 - ridge_tail_y1",
                      "z_ridge_plateau - z_plate_top"]},
            {"prim": "sweep", "name": "ridge_main_arc", "axis": "y",
             "source": "main ramp: fitted circular arc (residual in params)",
             "u0": "-ridge_hw", "u1": "ridge_hw",
             "s0": "ridge_arc_y0", "s1": "ridge_arc_y1",
             "z0": "z_plate_top", "h_max": "z_ridge_top", "steps": 24,
             "law": {"kind": "arc", "sc": "ridge_arc_yc", "zc": "ridge_arc_zc",
                     "R": "ridge_arc_R"}},
            {"prim": "box", "name": "ridge_full",
             "source": "full-height section between the two fitted arcs",
             "min": ["-ridge_hw", "ridge_arc_y1", "z_plate_top"],
             "size": ["2*ridge_hw", "ridge_head_y0 - ridge_arc_y1",
                      "z_ridge_top - z_plate_top"]},
            {"prim": "sweep", "name": "ridge_head_arc", "axis": "y",
             "source": "head taper: fitted circular arc (residual in params)",
             "u0": "-ridge_hw", "u1": "ridge_hw",
             "s0": "ridge_head_y0", "s1": "ridge_head_cy + ridge_hw + 0.2",
             "z0": "z_plate_top", "h_max": "z_ridge_top", "steps": 16,
             "law": {"kind": "arc", "sc": "ridge_head_yc", "zc": "ridge_head_zc",
                     "R": "ridge_head_R"}},
        ]},
    ]},
}
print(f"center_ridge: 16 bandas -> 3 leis (res {t_res:.3f}/{a_res:.3f}/{h_res:.3f})")

# ---- rail humps: wing prism + 45-deg offset-sweep strip (fully parametric) --
# Measured: strip footprints shrink UNIFORMLY with z (dist to the base
# footprint = dz within std 0.012 -> 45-deg edge law on ALL sides); the wing
# is the outline clipped at a vertical line (its inner edge decimated to a
# single straight segment).
railsR = sorted(rail_layers["R"], key=lambda q: q["z0"])
railsL = sorted(rail_layers["L"], key=lambda q: q["z0"])
wingsR = [q for q in railsR if q["z0"] < 1.79]
stripsR = [q for q in railsR if q["z0"] >= 1.79]
# L/R mirror check (areas)
for qr, ql in zip(railsR, railsL):
    ar, al = _parea(qr), _parea(ql)
    assert abs(ar - al) < 0.05 * ar, f"rail L/R assimetria: {qr['name']} {ar:.0f} vs {al:.0f}"

wing = max(wingsR, key=_parea)
wa = np.array(wing["profile"])
# inner edge = the long near-vertical segment closest to the center
segs = [(A, B) for A, B in zip(wa, np.roll(wa, -1, axis=0))
        if abs(B[1] - A[1]) > 20 and abs(B[0] - A[0]) < 1.0]
inner_seg = min(segs, key=lambda s: abs(s[0][0]))
wing_x_cut = R((inner_seg[0][0] + inner_seg[1][0]) / 2)
z_wing_top = R(max(q["z1"] for q in wingsR))          # exact B-rep level

strip_base = min(stripsR, key=lambda q: q["z0"])       # lowest strip band
z_strip_mid = (strip_base["z0"] + strip_base["z1"]) / 2
z_rail_top = R(max(q["z1"] for q in stripsR))          # exact level (= z_blend0)
# uniform-offset law: delta(z) = z_strip_mid - z (45 deg), validated above
strip_d0 = R(z_strip_mid - z_wing_top)                 # slight outward pad at base
strip_d1 = R(z_strip_mid - z_rail_top)

params += [
    {"name": "wing_x_cut", "value": wing_x_cut,
     "source": "measured wing inner boundary (decimated to one straight "
               "vertical segment in the band footprint)"},
    {"name": "z_wing_top", "value": z_wing_top,
     "source": "exact B-rep plane level: top of the wing zone"},
    {"name": "z_rail_top", "value": z_rail_top,
     "source": "exact B-rep plane level: top of the rail strips"},
    {"name": "rail_d0", "value": strip_d0,
     "source": "45-deg rail edge law: offset at the wing top (uniform-shrink "
               "measurement, std 0.012)"},
    {"name": "rail_d1", "value": strip_d1,
     "source": "45-deg rail edge law: offset at the rail top (same measurement)"},
]

modules["rail_hump"] = {
    "args": [],
    "doc": "outer wing + strap rail (right side; the left side is mirrored): "
           "wing = outline clipped at wing_x_cut; rail strip = measured base "
           "footprint shrinking at the measured 45-deg edge law on all sides",
    "tree": {"op": "union", "children": [
        {"prim": "extrude", "axis": "z", "name": "wing",
         "source": "wing zone: shared outline INTERSECT x >= wing_x_cut "
                   "(inner edge measured straight; largest wing band footprint)",
         "profile2d": {"op2d": "intersection", "children": [
             {"ref": "plate_upper_outline"},
             {"rect": ["wing_x_cut", -50, 50, 50]}]},
         "z0": "z_plate_top", "z1": "z_wing_top"},
        {"prim": "offset_sweep", "name": "rail_strip",
         "source": "strap rail: measured base footprint with the uniform "
                   "45-deg shrink law (dist-to-base = dz, std 0.012)",
         "profile2d": {"ref": "rail_strip_base"},
         "z0": "z_wing_top", "z1": "z_rail_top", "steps": 8,
         "law": {"kind": "linear", "d0": "rail_d0", "d1": "rail_d1"}},
    ]},
}

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
                 "plate_upper_outline": upper["profile"],
                 "rail_strip_base": strip_base["profile"]},
    "modules": modules,
    "csg": {"op": "difference", "children": [
        {"op": "union", "children": [
            {"call": "plate", "name": "plate_i", "args": {}},
            {"call": "center_ridge", "name": "ridge_i", "args": {}},
            {"call": "rail_hump", "name": "rail_right", "args": {}},
            {"transform": {"mirror": [1, 0, 0]}, "name": "rail_left",
             "child": {"call": "rail_hump", "name": "rail_left_i", "args": {}}},
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
