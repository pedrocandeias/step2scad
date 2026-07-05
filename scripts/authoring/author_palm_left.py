"""Author output/Palm_left/plan.json — Phoenix palm (left), single body.

STRATEGY (agent decision):
  ADDS   A1 main dome+knuckle shell: hull-loft of measured outer sections
            along y (x <= 22.9), y from the exact shell back plane -30.945 to
            the mesh front; dense over knuckle lobes
         A2 thumb lobe: hull-loft along y (x >= 20.5)
         A3 wrist barrel: exact r8 cylinder at (y=-38.95, z=12.62) spanning
            the exact face extents
  CUTS   C1 palm cavity: NON-convex measured internal-loop slabs along y
            (keeps the tendon-guide ribs the B-rep hangs from the ceiling)
         C2 105 bottom-plate grid holes (contains-grid measured, edges
            snapped to the exact small wall planes)
         C3 4 finger clevis slots (exact x plane pairs, probe-measured
            staggered back walls)
         C4 knuckle pin bores r2.5 + r3.25 counterbores (exact)
         C5 wrist axle bore r3 (exact)
         C6 barrel cutout between tabs (probe-measured walls, exact back)
         C7 thumb clevis slot (exact skew plane pair, rotated box)
         C8 thumb pin r2.5 + r2.7 counterbores (exact skew cylinders)
         C9 thumb knuckle relief r7.5 (exact skew cylinder)
         C10 every reversed tendon-channel cylinder r in {1.0,1.1,1.15}
            cut segment-exact along its own axis (the paths fan; each
            B-rep segment is already an exact cylinder)
Sections are measured on a FINE tessellation (deflection 0.01) to avoid the
~0.05mm inward chord bias of the default mesh.
"""
import json
import sys

import numpy as np

sys.path.insert(0, "src")
from step2scad.ingest import read_step, shape_to_trimesh

STEP = "models/phoenix_components/Palm_left.step"
SCRATCH = "scripts/authoring"  # side-data (e.g. palm_grid_holes.json) lives next to the scripts
feats = json.load(open("output/Palm_left/features.json"))
body = feats["bodies"][0]
R = lambda x: round(float(x), 6)

print("tessellating fine mesh (deflection 0.01)...")
mesh = shape_to_trimesh(read_step(STEP), linear_deflection=0.01)
print(f"  {len(mesh.faces)} faces, watertight={mesh.is_watertight}")


def convex_hull(pts):
    pts = sorted(set(map(tuple, np.round(pts, 5))))
    if len(pts) < 3:
        return pts
    def cross(o, a, b):
        return (a[0]-o[0])*(b[1]-o[1]) - (a[1]-o[1])*(b[0]-o[0])
    def half(seq):
        out = []
        for p in seq:
            while len(out) >= 2 and cross(out[-2], out[-1], p) <= 0:
                out.pop()
            out.append(p)
        return out[:-1]
    return half(pts) + half(pts[::-1])


def decimate(loop, tol=0.04):
    loop = [np.asarray(p, float) for p in loop]
    out = list(loop)
    changed = True
    while changed and len(out) > 8:
        changed = False
        for i in range(len(out)):
            a, b, c = out[i-1], out[i], out[(i+1) % len(out)]
            ab = c - a
            n = np.linalg.norm(ab)
            if n < 1e-9:
                continue
            d = abs(float(ab[0]*(b-a)[1] - ab[1]*(b-a)[0])) / n
            if d < tol:
                out.pop(i)
                changed = True
                break
    return [[R(p[0]), R(p[1])] for p in out]


def section_loops(y):
    sec = mesh.section(plane_origin=[0, y, 0], plane_normal=[0, 1, 0])
    if sec is None:
        return []
    return [d for d in sec.discrete]


def loop_area(pts2):
    x, z = pts2[:, 0], pts2[:, 1]
    return 0.5 * abs(np.dot(x, np.roll(z, 1)) - np.dot(z, np.roll(x, 1)))


def outer_hull_profile(y, xlo, xhi, tries=(0.0, 0.08, -0.08, 0.2, -0.2)):
    for dy in tries:
        pts = []
        for loop in section_loops(y + dy):
            m = loop[:, 0]
            keep = loop[(m >= xlo) & (m <= xhi)]
            if len(keep):
                pts.append(keep[:, [0, 2]])
        if pts:
            return decimate(convex_hull(np.vstack(pts)))
    return None


# ---------------------------------------------------------------- A1 + A2
def hull_loft(name, ys_profiles, note):
    kids = []
    for i in range(len(ys_profiles) - 1):
        (ya, pa), (yb, pb) = ys_profiles[i], ys_profiles[i + 1]
        kids.append({"op": "hull", "children": [
            {"prim": "extrude", "axis": "y", "name": f"{name}{i:02d}a",
             "source": f"measured outer section hull at y={ya} (fine mesh)",
             "profile": [[p[1], p[0]] for p in pa], "z0": R(ya), "z1": R(ya + 0.02)},
            {"prim": "extrude", "axis": "y", "name": f"{name}{i:02d}b",
             "source": f"measured outer section hull at y={yb} (fine mesh)",
             "profile": [[p[1], p[0]] for p in pb], "z0": R(yb), "z1": R(yb + 0.02)},
        ]})
    return {"op": "union", "children": kids}


def station_list(y0, y1, coarse, fine_zones):
    ys = set()
    y = y0
    while y <= y1:
        ys.add(R(y)); y += coarse
    for (a, b, step) in fine_zones:
        y = max(a, y0)
        while y <= min(b, y1):
            ys.add(R(y)); y += step
    ys.add(R(y1))
    return sorted(ys)


def repaired_stations(ys, xlo, xhi):
    out = []
    for y in ys:
        p = outer_hull_profile(y, xlo, xhi)
        if p is not None:
            out.append((y, p))
    # neighbor-consistency: drop stations whose z-span collapses vs both sides
    def span(prof):
        zs = [q[1] for q in prof]
        return max(zs) - min(zs)
    keep = []
    for i, (y, p) in enumerate(out):
        if 0 < i < len(out) - 1:
            nb = min(span(out[i-1][1]), span(out[i+1][1]))
            if span(p) < 0.55 * nb:
                print(f"  station y={y}: collapsed section, dropped")
                continue
        keep.append((y, p))
    return keep


Y_BACKWALL = -30.945348  # exact shell back plane (faces 133/450)
ymax = float(mesh.vertices[:, 1].max())

# ---- shell = ONE stack of NON-CONVEX measured outline slabs -------------
# Two clipped convex hull-lofts (main x<=23.6 / thumb x>=23) PINCH at the
# seam (iter-3: wedge gaps shredded the palm-thumb transition, recon section
# at x=23 was 623 vs 1204 mm²) and convex hulls bridge the mound saddles
# (iter-3 FP 2342 mm³). Outline slabs have neither problem: each y band is
# the section's actual outer loops, holes ignored (cuts recreate them), and
# the slot roof bridges come along for free.

def _contains2d(poly, pt):
    from matplotlib.path import Path as MplPath
    return MplPath(poly).contains_point(pt)


def outline_profiles(y):
    loops = section_loops(y)
    polys = [l[:, [0, 2]] for l in loops]
    polys = [p for p in polys if loop_area(p) > 0.5]
    if not polys:
        return None
    outers = []
    for i, p in enumerate(polys):
        if any(j != i and _contains2d(polys[j], p[0]) for j in range(len(polys))):
            continue  # hole loop — the measured cuts recreate it
        outers.append(decimate([list(q) for q in p], tol=0.08))
    return outers or None


ymin = float(mesh.vertices[:, 1].min())
band_edges = station_list(ymin + 0.05, ymax - 0.05, 0.6, [
    (ymin, Y_BACKWALL + 3, 0.3),            # wrist tabs + back roll
    (17.5, 34.0, 0.3),                       # knuckle mounds
    (34.0, ymax, 0.2),                       # front taper + tips
])
shell_slabs = []
prev_area = None
for i in range(len(band_edges) - 1):
    ya, yb = band_edges[i], band_edges[i + 1]
    mid = (ya + yb) / 2
    profs = outline_profiles(mid)
    if profs is None:
        profs = outline_profiles(mid + 0.07) or outline_profiles(mid - 0.07)
    if profs is None:
        print(f"  shell band y=[{ya},{yb}]: no section, skipped")
        continue
    area = sum(loop_area(np.asarray(p)) for p in profs)
    if prev_area is not None and area < 0.35 * prev_area and yb < ymax - 2:
        alt = outline_profiles(mid + 0.12) or outline_profiles(mid - 0.12)
        if alt and sum(loop_area(np.asarray(p)) for p in alt) > area:
            profs = alt  # partial-section repair
    prev_area = area
    for k, p in enumerate(profs):
        shell_slabs.append({
            "prim": "extrude", "axis": "y",
            "name": f"sh{len(shell_slabs):03d}",
            "source": f"shell outline slab: measured outer section loop at "
                      f"y={R(mid)} (fine mesh), band [{R(ya)}, {R(yb)}]",
            "profile": [[q[1], q[0]] for q in p],
            "z0": R(ya), "z1": R(yb)})
print(f"shell: {len(shell_slabs)} outline slabs over {len(band_edges)-1} bands")
A1 = {"op": "union", "children": shell_slabs}
A2 = None  # merged into the single outline stack

# wrist tabs are covered by the outline-slab stack (bands start at mesh ymin)

A3 = {"prim": "cylinder", "name": "barrel",
      "source": "wrist barrel: exact r8 boss faces 534/535 at (y=-38.95, "
                "z=12.62); ends probe-measured (rounded, mid values)",
      "p0": [-38.19, -38.951348, 12.624652], "p1": [23.27, -38.951348, 12.624652],
      "r": 8.0}

# ---------------------------------------------------------------- C1 cavity
# contains-column scan: per station, per x column, find the FIRST interior
# void run (void samples with material above) — floor measured too, so the
# thumb-lobe hollow (floor above the plate) and the knuckle-region hollow
# (y > 28.4) are captured, not just the plate-top cavity. Keeps ceiling ribs.
Z_PLATE_TOP = 6.624652  # exact plane face 828
cav_ys = station_list(-31.4, 34.5, 1.0, [(-31.4, -26.5, 0.5), (17.5, 34.5, 0.5)])
xs_grid = np.arange(-39.8, 41.5, 0.45)  # includes the thumb lobe
zs_grid = np.arange(Z_PLATE_TOP + 0.12, 33.8, 0.25)
cav_slabs = []


def cavity_profiles(y):
    X, Z = np.meshgrid(xs_grid, zs_grid, indexing="ij")
    pts = np.stack([X.ravel(), np.full(X.size, y), Z.ravel()], axis=1)
    inside = mesh.contains(pts).reshape(X.shape)
    n = len(zs_grid)
    zlo = np.full(len(xs_grid), np.nan)
    zhi = np.full(len(xs_grid), np.nan)
    for i in range(len(xs_grid)):
        col = inside[i]
        if not col.any():
            continue  # column misses the shell entirely
        j = 0
        while j < n:
            if not col[j]:
                k = j
                while k < n and not col[k]:
                    k += 1
                if k < n and (k - j) * 0.25 > 0.4:  # interior void run
                    zlo[i] = zs_grid[j] - 0.125
                    zhi[i] = zs_grid[k] - 0.125
                    break  # take the first (lowest) QUALIFYING run
                j = k  # skip a too-thin or roofless run, keep scanning
            else:
                j += 1
    runs, cur = [], []
    for i in range(len(xs_grid)):
        if not np.isnan(zlo[i]):
            cur.append(i)
        elif cur:
            runs.append(cur); cur = []
    if cur:
        runs.append(cur)
    profs = []
    for run in runs:
        if len(run) < 3:
            continue
        top = [[R(xs_grid[i]), R(zhi[i])] for i in run]
        bot = [[R(xs_grid[i]), R(zlo[i])] for i in reversed(run)]
        profs.append(decimate(top + bot, tol=0.06))
    return profs


for i in range(len(cav_ys) - 1):
    ya, yb = cav_ys[i], cav_ys[i + 1]
    for prof in cavity_profiles((ya + yb) / 2):
        cav_slabs.append({
            "prim": "extrude", "axis": "y", "name": f"cv{len(cav_slabs):03d}",
            "source": f"cavity: contains-column measured at y={R((ya+yb)/2)} "
                      "(void run above the exact plate top; keeps ceiling ribs)",
            "profile": [[p[1], p[0]] for p in prof],
            "z0": R(ya), "z1": R(yb)})
print(f"cavity: {len(cav_slabs)} slabs")

# ---------------------------------------------------------------- C2 grid
holes = json.load(open(f"{SCRATCH}/palm_grid_holes.json"))
# snap hole edges to exact small-plane offsets
xoffs, yoffs = [], []
for f in body["faces"]:
    if f["type"] != "plane" or not (0.3 < f["area"] < 12):
        continue
    n = np.asarray(f["params"]["normal"], float)
    o = np.asarray(f["params"]["origin"], float)
    if abs(abs(n[0]) - 1) < 1e-3:
        xoffs.append(o[0] if abs(n[0]) > 0.99 else None)
        xoffs[-1] = float(np.dot(n, o) / n[0]) if n[0] else None
    elif abs(abs(n[1]) - 1) < 1e-3 and n[1] != 0:
        yoffs.append(float(np.dot(n, o) / n[1]))
xoffs = sorted(v for v in xoffs if v is not None)
yoffs = sorted(set(round(v, 4) for v in yoffs))
def snap(v, offs):
    if not offs:
        return v
    best = min(offs, key=lambda o: abs(o - v))
    return best if abs(best - v) < 0.25 else v
grid_cuts = []
for (x0, x1, y0, y1, _) in holes:
    x0s, x1s = snap(x0, xoffs), snap(x1, xoffs)
    y0s, y1s = snap(y0, yoffs), snap(y1, yoffs)
    grid_cuts.append({
        "prim": "box", "name": f"h{len(grid_cuts):03d}",
        "source": "bottom-plate grid hole: contains-grid measured, edges "
                  "snapped to exact wall planes",
        "min": [R(x0s), R(y0s), 4.1], "size": [R(x1s - x0s), R(y1s - y0s), 3.05]})
print(f"grid: {len(grid_cuts)} hole cuts")

# ---------------------------------------------------------------- C3 slots
# Each slot is a TUNNEL: floor lip (z~5-7), straight throat, and a roof
# bridge over it (z~18-21). Cut = measured (y,z) staircase of the void
# forward of the bar body; the roof bridge is re-added as a measured box.
SLOTS = [(-31.46, -25.46), (-17.46, -11.46), (-3.46, 2.54), (10.54, 16.54)]
YS_ROW = np.linspace(14.0, 47.0, 221)  # 0.15 resolution


def slot_scan(xm, xs=None):
    """Per z-row: (cut-onset y, material segments). Material is OR-ed over
    several x stations so wall-side fillets are treated as material and the
    full-width void boxes never chop them (iter-5 FN trio ~310 mm3)."""
    xs = xs if xs is not None else [xm]
    rows = []
    for z in np.arange(0.6, 25.8, 0.4):
        ins = np.zeros(len(YS_ROW), dtype=bool)
        for xx in xs:
            pts = np.stack([np.full(len(YS_ROW), xx), YS_ROW,
                            np.full(len(YS_ROW), z)], axis=1)
            ins |= mesh.contains(pts)
        if not ins.any():
            rows.append((float(z), 14.0, []))
            continue
        idx = np.where(ins)[0]
        k = idx[0]
        while k + 1 < len(YS_ROW) and ins[k + 1]:
            k += 1
        onset = float(YS_ROW[k]) + 0.075
        segs = []
        k += 1
        while k < len(YS_ROW):
            if ins[k]:
                s = k
                while k + 1 < len(YS_ROW) and ins[k + 1]:
                    k += 1
                segs.append((float(YS_ROW[s]) - 0.075, float(YS_ROW[k]) + 0.075))
            k += 1
        rows.append((float(z), onset, segs))
    return rows


# cut only the measured VOID RUNS per z row (cutting "everything forward of
# the first material block" chopped the slot floor lips and roof bridges —
# iter-4 FN pair at z=5.34, ~320 mm³)
slot_cuts = []
for k, (a, bx) in enumerate(SLOTS):
    rows = slot_scan((a + bx) / 2,
                     xs=[(a + bx) / 2, a + 0.35, bx - 0.35])
    for (z, onset, segs) in rows:
        # void spans: onset -> each material block start, then past the last
        edges = [onset]
        for (s0, s1) in segs:
            edges.extend([s0, s1])
        edges.append(50.0)
        for v in range(0, len(edges), 2):
            v0, v1 = edges[v], edges[v + 1]
            if v1 - v0 < 0.2:
                continue
            slot_cuts.append({
                "prim": "box", "name": f"slot{k}_{len(slot_cuts):03d}",
                "source": f"finger clevis slot void run: exact wall planes "
                          f"x=[{a},{bx}]; y=[{R(v0)},{R(v1)}] contains-scanned "
                          f"at slot mid-x, z={R(z)}",
                "min": [R(a), R(v0), R(z - 0.2)],
                "size": [R(bx - a), R(v1 - v0), 0.4]})
print(f"slots: {len(slot_cuts)} void-run boxes")

# ---------------------------------------------------------------- C4/C5
pin_cuts = [
    {"prim": "cylinder", "name": "kpin1",
     "source": "knuckle pin bore: exact r2.5 faces 219/220/228/338 at (y=39.05, z=10.62)",
     "p0": [-5.46, 39.045348, 10.624652], "p1": [17.54, 39.045348, 10.624652], "r": 2.5},
    {"prim": "cylinder", "name": "kpin2",
     "source": "knuckle pin bore: exact r2.5 faces 286/288/290 at (y=35.05, z=10.62)",
     "p0": [-18.38, 35.045348, 10.624652], "p1": [-9.46, 35.045348, 10.624652], "r": 2.5},
    {"prim": "cylinder", "name": "kpin3",
     "source": "knuckle pin bore: exact r2.5 faces 234/242/324 at (y=29.05, z=10.62)",
     "p0": [-32.38, 29.045348, 10.624652], "p1": [-23.46, 29.045348, 10.624652], "r": 2.5},
    {"prim": "cylinder", "name": "kcb1",
     "source": "pin-head counterbore: exact r3.25 face 318",
     "p0": [-7.46, 39.045348, 10.624652], "p1": [-5.46, 39.045348, 10.624652], "r": 3.25},
    {"prim": "cylinder", "name": "kcb2",
     "source": "pin-head counterbore: exact r3.25 face 249",
     "p0": [-9.46, 35.045348, 10.624652], "p1": [-7.46, 35.045348, 10.624652], "r": 3.25},
    {"prim": "cylinder", "name": "kcb3",
     "source": "pin-head counterbore: exact r3.25 face 248",
     "p0": [-23.46, 29.045348, 10.624652], "p1": [-21.46, 29.045348, 10.624652], "r": 3.25},
    {"prim": "cylinder", "name": "wbore",
     "source": "wrist axle bore: exact r3 faces 93/246 at (y=-38.95, z=12.62)",
     "p0": [-39.5, -38.951348, 12.624652], "p1": [24.5, -38.951348, 12.624652], "r": 3.0},
]

def _xl(z): return -33.06 - 0.026 * (z - 7.5)   # measured z7.5/-33.06, z17.5/-33.32
def _xr(z): return 18.15 + 0.026 * (z - 7.5)    # measured z7.5/18.15, z17.5/18.41
C6 = {"prim": "extrude", "axis": "y", "name": "barrelcut",
      "source": "tensioner bay between wrist tabs: raycast-measured tilted "
                "walls (two z stations each side), back = exact shell plane",
      "profile": [[2.5, R(_xl(2.5))], [22.5, R(_xl(22.5))],
                  [22.5, R(_xr(22.5))], [2.5, R(_xr(2.5))]],
      "z0": -48.0, "z1": R(-30.945348)}

# ---------------------------------------------------------------- thumb
ND = np.array([0.642788, 0.766044, 0.0])   # exact clevis normal
TD = np.degrees(np.arctan2(ND[1], ND[0]))
# measure the slot's true (t, z) extent in the rotated mid-plane frame:
# interior void runs per z row (void bounded by lobe material on both sides)
C0 = np.array([31.196, -5.878, 0.0])
TT = np.array([-0.766044, 0.642788, 0.0])
ts = np.arange(-16.0, 16.0, 0.3)
slot_cells = []
for z in np.arange(0.6, 26.0, 0.4):
    ins = np.zeros(len(ts), dtype=bool)
    for w in (0.0, 2.2, -2.2):
        pts = np.stack([C0[0] + ts * TT[0] + w * ND[0],
                        C0[1] + ts * TT[1] + w * ND[1],
                        np.full(len(ts), z)], axis=1)
        ins |= mesh.contains(pts)
    k = 0
    while k < len(ts):
        if not ins[k]:
            s = k
            while k + 1 < len(ts) and not ins[k + 1]:
                k += 1
            if not (s == 0 and k >= len(ts) - 1):  # skip all-void rows
                slot_cells.append((float(z), float(ts[s]), float(ts[k])))
        k += 1
# one thin rotated box PER measured void run — a single bbox box chops the
# slot's roof bridge (iter-4 FN 909 mm³ at the thumb overhang)
tslot_rows = []
for (z, t0c, t1c) in slot_cells:
    if t1c - t0c < 0.25:
        continue
    tc = C0 + ((t0c + t1c) / 2) * TT
    tslot_rows.append({
        "prim": "box", "name": f"tslot{len(tslot_rows):02d}",
        "source": "thumb clevis slot void row: exact skew planes (6mm wide); "
                  f"t=[{R(t0c)},{R(t1c)}] contains-scanned at z={R(z)}",
        "center": [R(tc[0]), R(tc[1]), R(z)],
        "size": [6.0, R(t1c - t0c + 0.3), 0.4],
        "rotate_deg": [0.0, 0.0, R(TD)]})
print(f"thumb slot: {len(tslot_rows)} void-run rows")
C7 = {"op": "union", "children": tslot_rows}

def axis_pt(A, dA, d):
    return (np.asarray(A) + (d - dA) * ND).tolist()

A226 = np.array([27.976, -11.661, 10.424]); d226 = float(ND[:2] @ A226[:2])
thumb_cuts = [
    {"prim": "cylinder", "name": "tpin",
     "source": "thumb pin bore: exact r2.5 face 184 axis (z=10.424), cut through both ears",
     "p0": [R(v) for v in axis_pt(A226, d226, 6.5)],
     "p1": [R(v) for v in axis_pt(A226, d226, 24.5)], "r": 2.5},
    {"prim": "cylinder", "name": "tcb1",
     "source": "thumb counterbore: exact r2.7 face 226 segment",
     "p0": [R(v) for v in axis_pt(A226, d226, d226 - 1.5)],
     "p1": [R(v) for v in axis_pt(A226, d226, d226 + 1.5)], "r": 2.7},
    {"prim": "cylinder", "name": "tcb2",
     "source": "thumb counterbore: exact r2.7 faces 319/320 segment",
     "p0": [R(v) for v in axis_pt(A226, d226, 18.55)],
     "p1": [R(v) for v in axis_pt(A226, d226, 20.55)], "r": 2.7},
    {"prim": "cylinder", "name": "trelief",
     "source": "thumb knuckle relief: exact r7.5 face 524 (o 31.196,-5.878,10.624, v ±3)",
     "p0": [R(v) for v in (np.array([31.196, -5.878, 10.624]) - 3.0 * ND)],
     "p1": [R(v) for v in (np.array([31.196, -5.878, 10.624]) + 3.0 * ND)], "r": 7.5},
]

# ------------------------------------------------- C10 tendon channel cuts
tube_cuts = []
for f in body["faces"]:
    if f["type"] != "cylinder" or f["orientation"] != "reversed":
        continue
    r = f["params"]["radius"]
    if not any(abs(r - rr) < 0.02 for rr in (1.0, 1.1, 1.15)):
        continue
    o = np.asarray(f["params"]["axis_origin"], float)
    dd = np.asarray(f["params"]["axis_dir"], float)
    dd = dd / np.linalg.norm(dd)
    v0, v1 = sorted(f["v_range"])
    if v1 - v0 < 0.05:
        continue  # degenerate seam sliver
    p0 = o + (v0 - 0.3) * dd
    p1 = o + (v1 + 0.3) * dd
    tube_cuts.append({
        "prim": "cylinder", "name": f"tube{len(tube_cuts):02d}",
        "source": f"tendon channel: exact cylinder face {f['index']} "
                  f"(r={R(r)}), segment-exact axis, 0.3 overshoot",
        "p0": [R(v) for v in p0], "p1": [R(v) for v in p1], "r": R(r)})
print(f"tendon channels: {len(tube_cuts)} segment cuts")

# outline slabs already carry the slot roof bridges (they are part of the
# measured outer loops) and the slot cuts spare them — no roof add-backs.
tree = {"op": "difference", "children": [
    {"op": "union", "children": [A1, A3]}]
    + cav_slabs + grid_cuts + slot_cuts + pin_cuts + [C6, C7]
    + thumb_cuts + tube_cuts}

plan = {"version": 1, "source": feats["source"], "bodies": [{
    "body_id": 0, "strategy": "csg",
    "notes": "palm: main+thumb hull-lofts + exact wrist barrel; cavity as "
             "measured non-convex loop slabs (ribs preserved); exact cuts for "
             "grid holes, finger slots, pins, barrel bay, thumb clevis, "
             "tendon channels",
    "csg": tree}]}
json.dump(plan, open("output/Palm_left/plan.json", "w"), indent=1)
n_prims = (len(cav_slabs) + len(grid_cuts) + len(slot_cuts) + len(pin_cuts)
           + len(thumb_cuts) + len(tube_cuts) + len(tslot_rows)
           + len(shell_slabs) + 3)
print(f"wrote output/Palm_left/plan.json  (~{n_prims} primitives)")
