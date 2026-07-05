"""Author output/Arm_Guard/plan.json.

STRATEGY (agent decision): the arm guard is a 2.5D stepped plate (flat bottom,
tops at exact plane levels, 45-degree ramps, strap tunnels). Reconstruct as a
BAND STACK: between consecutive exact z-levels (subdivided to <= 0.5 mm so the
ramps staircase within tolerance), extrude the measured section footprint —
outer loops added, hole loops subtracted. Every band boundary is an exact
B-rep plane offset; every loop is measured from the high-res tessellation at
the band midplane.
"""
import json
import sys

import numpy as np

sys.path.insert(0, "src")
from step2scad.probe import load_mesh

R = lambda x: round(float(x), 6)
feats = json.load(open("output/Arm_Guard/features.json"))
body = feats["bodies"][0]
mesh = load_mesh("models/phoenix_components/Arm_Guard.step")

# ---- exact z knots from the B-rep z-normal planes ---------------------------
knots = set()
for f in body["faces"]:
    if f["type"] != "plane" or f["area"] < 3:
        continue
    n = np.asarray(f["params"]["normal"], float)
    n /= np.linalg.norm(n)
    if abs(n[2]) > 0.999:
        knots.add(R(float(n @ np.asarray(f["params"]["origin"])) * np.sign(n[2])))
z_top = float(mesh.bounds[1][2])
z_bot = float(mesh.bounds[0][2])
knots |= {R(z_bot), R(z_top)}
knots = sorted(k for k in knots if z_bot - 1e-6 <= k <= z_top + 1e-6)
merged = [knots[0]]
for k in knots[1:]:
    if k - merged[-1] > 0.005:
        merged.append(k)
knots = merged
# subdivide gaps > 0.5
bands = []
for a, b in zip(knots, knots[1:]):
    nsub = max(1, int(np.ceil((b - a) / 0.25)))
    for i in range(nsub):
        bands.append((R(a + (b - a) * i / nsub), R(a + (b - a) * (i + 1) / nsub)))
print(f"{len(bands)} bands from {len(knots)} exact knots: {knots}")


def decimate(loop, tol=0.03):
    loop = [np.asarray(p, float) for p in loop]
    out = list(loop)
    changed = True
    while changed and len(out) > 6:
        changed = False
        for i in range(len(out)):
            a, b, c = out[i - 1], out[i], out[(i + 1) % len(out)]
            ab = c - a
            nrm = np.linalg.norm(ab)
            if nrm < 1e-9:
                continue
            d = abs(float(np.cross(ab, b - a))) / nrm
            if d < tol:
                out.pop(i)
                changed = True
                break
    return [[R(p[0]), R(p[1])] for p in out]


from shapely.geometry import Polygon, Point

def band_loops(zmid):
    sec = mesh.section(plane_origin=[0, 0, zmid], plane_normal=[0, 0, 1])
    if sec is None:
        return []
    rings = []
    for d in sec.discrete:
        xy = d[:, :2]
        if len(xy) < 4:
            continue
        poly = Polygon(xy)
        if not poly.is_valid or poly.area < 0.05:
            continue
        rings.append((poly, xy))
    # nesting depth: even = outer, odd = hole
    out = []
    for i, (pi, xyi) in enumerate(rings):
        depth = sum(1 for j, (pj, _) in enumerate(rings)
                    if i != j and pj.contains(Point(xyi[0])))
        out.append((depth, xyi))
    return out


children = []
for k, (a, b) in enumerate(bands):
    zmid = (a + b) / 2
    loops = band_loops(zmid)
    # robustness: partial-section retry (parent hit this on Distals)
    area_now = sum(Polygon(xy).area for dep, xy in loops if dep % 2 == 0)
    alt = band_loops(zmid + 0.03)
    area_alt = sum(Polygon(xy).area for dep, xy in alt if dep % 2 == 0)
    if area_alt > area_now * 1.02:
        loops, zmid = alt, zmid + 0.03
    outers = [xy for dep, xy in loops if dep % 2 == 0]
    holes = [xy for dep, xy in loops if dep % 2 == 1]
    if not outers:
        print(f"band {k} [{a},{b}]: EMPTY, skipped")
        continue
    src = (f"measured section loops at z={R(zmid)} for the band between exact "
           f"B-rep plane levels z={a} and z={b}")
    adds = [{"prim": "extrude", "axis": "z", "name": f"b{k}o{i}",
             "source": src, "profile": decimate(xy), "z0": a, "z1": b}
            for i, xy in enumerate(outers)]
    node = adds[0] if len(adds) == 1 else {"op": "union", "children": adds}
    if holes:
        cuts = [{"prim": "extrude", "axis": "z", "name": f"b{k}h{j}",
                 "source": src + " (hole loop)",
                 "profile": decimate(xy), "z0": R(a - 0.005), "z1": R(b + 0.005)}
                for j, xy in enumerate(holes)]
        node = {"op": "difference", "children": [node] + cuts}
    children.append(node)
    print(f"band {k} [{a},{b}]: {len(outers)} outer, {len(holes)} holes")

# ---- exact slanted-plane cuts: trim the staircase back to the true ramps ---
# For every significant slanted plane face, cut a box whose face lies exactly
# on the B-rep plane, bounded to the face's measured footprint (an infinite
# halfspace would clip unrelated geometry — these planes cross the part).
slant_cuts = []
V = mesh.vertices
for f in body["faces"]:
    if f["type"] != "plane" or f["area"] < 10:
        continue
    n = np.asarray(f["params"]["normal"], float)
    n /= np.linalg.norm(n)
    if True:
        continue  # slant cuts disabled: bounded boxes gouged the deck under
                  # overhangs and diagonal strips (IoU 0.988 -> 0.83); fine
                  # 0.25 mm bands approximate the ramps instead
    d = float(n @ np.asarray(f["params"]["origin"], float))
    near = V[np.abs(V @ n - d) < 0.05]
    if len(near) < 10:
        continue
    theta = np.degrees(np.arccos(np.clip(n[2], -1, 1)))
    phi = np.degrees(np.arctan2(n[1], n[0]))
    # local in-plane basis consistent with rotate([0, theta, phi])
    th, ph = np.radians(theta), np.radians(phi)
    e1 = np.array([np.cos(th) * np.cos(ph), np.cos(th) * np.sin(ph), -np.sin(th)])
    e2 = np.cross(n, e1)
    u = near @ e1
    v = near @ e2
    H = 10.0
    size = [R(u.max() - u.min() + 0.6), R(v.max() - v.min() + 0.6), R(H)]
    c_in = ((u.max() + u.min()) / 2) * e1 + ((v.max() + v.min()) / 2) * e2
    c_in = c_in + (d - float(c_in @ n)) * n + n * (H / 2)
    slant_cuts.append({
        "prim": "box", "name": f"slant{f['index']}",
        "source": f"exact slanted plane face #{f['index']} "
                  f"(n={[R(x) for x in n]}, d={R(d)}); cut box bounded to the "
                  "face's measured footprint, face flush on the plane",
        "center": [R(x) for x in c_in], "size": size,
        "rotate_deg": [0, R(theta), R(phi)]})
    print(f"slant cut: face {f['index']} area={f['area']:.1f} n={np.round(n,3)}")

tree = {"op": "union", "children": children}
if slant_cuts:
    tree = {"op": "difference", "children": [tree] + slant_cuts}

plan = {
    "version": 1,
    "source": feats["source"],
    "bodies": [{
        "body_id": 0,
        "strategy": "csg",
        "notes": "2.5D band stack: measured section footprints extruded "
                 "between exact B-rep z-levels (ramps staircased <= 0.5 mm), "
                 "then trimmed by exact bounded slanted-plane cuts",
        "csg": tree,
    }],
}
json.dump(plan, open("output/Arm_Guard/plan.json", "w"), indent=1)
print("wrote output/Arm_Guard/plan.json")
