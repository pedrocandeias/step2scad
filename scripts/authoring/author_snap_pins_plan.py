"""Author output/Snap_Pins/plan.json.

STRATEGY (agent decision): each unique pin = hull-loft of measured cross
sections along its long axis (round shafts, flat top/bottom truncations,
barb rings and head plates all appear exactly in the stations), MINUS the
plan-view concavities (fork slot + barb notches) as vertical-walled extrude
cutters measured from the mid-z silhouette (silhouette convex hull minus the
actual outline). Engraved sub-0.15 mm label grooves are intentionally
ignored (<0.3 mm³ each). Structurally identical bodies (only the engraved
digit differs) become translated instances; body 7 is a y-mirror of body 1
so it gets its own measured plan from its own faces. Bodies 9/11 are clean
solids of revolution -> no plan entry, the rotate_extrude path handles them.
"""
import json
import sys

import numpy as np

sys.path.insert(0, "src")
from step2scad.ingest import read_step, shape_to_trimesh

try:
    from shapely.geometry import Polygon
except ImportError:
    Polygon = None

STEP = "models/phoenix_components/Snap_Pins.step"
feats = json.load(open("output/Snap_Pins/features.json"))
# fine tessellation: coarse meshes bias measured outlines inward ~0.05 mm,
# which is material on 107 mm³ pins
mesh = shape_to_trimesh(read_step(STEP), linear_deflection=0.008)

R = lambda x: round(float(x), 6)
UNIQUES = [0, 1, 5, 6, 7, 10, 12]
INSTANCES = {3: 0, 2: 1, 4: 1, 8: 6}
AXI = {"x": 0, "y": 1, "z": 2}


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


def decimate(loop, tol=0.03):
    loop = [np.asarray(p, float) for p in loop]
    out = list(loop)
    changed = True
    while changed and len(out) > 6:
        changed = False
        for i in range(len(out)):
            a, b, c = out[i-1], out[i], out[(i+1) % len(out)]
            ab = c - a
            n = np.linalg.norm(ab)
            if n < 1e-9:
                continue
            if abs(ab[0]*(b-a)[1] - ab[1]*(b-a)[0]) / n < tol:
                out.pop(i); changed = True; break
    return [[R(p[0]), R(p[1])] for p in out]


def true_bbox(body):
    """Mesh-measured bbox (OCC Bnd_Box overestimates bspline extents)."""
    mn = np.array(body["bbox"]["min"]) - 0.3
    mx = np.array(body["bbox"]["max"]) + 0.3
    sel = np.all((mesh.vertices >= mn) & (mesh.vertices <= mx), axis=1)
    v = mesh.vertices[sel]
    return v.min(axis=0), v.max(axis=0)


def body_loops(sec, lo, hi, iu, iv):
    """Section loops whose centroid lies inside this body's in-plane bbox."""
    out = []
    for d in sec.discrete:
        cu, cv = d[:, iu].mean(), d[:, iv].mean()
        if lo[iu]-0.3 <= cu <= hi[iu]+0.3 and lo[iv]-0.3 <= cv <= hi[iv]+0.3:
            out.append(d)
    return out


def station_profile(lo, hi, axis, s):
    """Convex hull of the body's section at <axis>=s (3-slice merged)."""
    ax = AXI[axis]
    iu, iv = [(1, 2), (2, 0), (0, 1)][ax]  # cyclic in-plane axes
    normal = np.eye(3)[ax]
    pts = []
    for ss in (s - 0.05, s, s + 0.05):
        origin = np.zeros(3); origin[ax] = ss
        sec = mesh.section(plane_origin=origin, plane_normal=normal)
        if sec is None:
            continue
        for d in body_loops(sec, lo, hi, iu, iv):
            pts.extend(d[:, [iu, iv]])
    if not pts:
        return None
    return decimate(convex_hull(np.array(pts)))


def plan_pockets(lo, hi):
    """Mid-z silhouette concavities (fork slot, barb notches) as (x,y) polys."""
    zmid = (lo[2] + hi[2]) / 2
    sec = mesh.section(plane_origin=[0, 0, zmid], plane_normal=[0, 0, 1])
    loops = body_loops(sec, lo, hi, 0, 1)
    assert loops, "no plan loops"
    outer = max(loops, key=lambda d: Polygon(d[:, :2]).area)
    poly = Polygon(outer[:, :2]).buffer(0)
    pockets = poly.convex_hull.difference(poly)
    geoms = getattr(pockets, "geoms", [pockets])
    out = []
    for g in geoms:
        if g.area < 0.4:
            continue  # engraving / tessellation noise
        # +0.015 buffer: cutter walls exactly coplanar with the loft surface
        # leave zero-volume tangency shards in the boolean output
        ring = list(g.buffer(0.015).simplify(0.02).exterior.coords)[:-1]
        out.append([[R(p[0]), R(p[1])] for p in ring])
    return out, R(zmid)


def build_body(body):
    bid = body["id"]
    lo, hi = true_bbox(body)
    size = hi - lo
    axis = "x" if size[0] >= size[1] else "y"
    ax = AXI[axis]
    a0, a1 = lo[ax], hi[ax]

    ss = list(np.arange(a0 + 0.25, a1 - 0.1, 0.4)) + [a0 + 0.06, a1 - 0.06]
    ss = sorted(set(round(s, 3) for s in ss))
    profiles = {s: station_profile(lo, hi, axis, s) for s in ss}
    ss = [s for s in ss if profiles[s] is not None]

    # repair pass: drop stations whose z-span collapses vs both neighbors
    def span(prof):
        vs = [p[1] for p in prof]
        return max(vs) - min(vs)
    keep = []
    for i, s in enumerate(ss):
        if 0 < i < len(ss) - 1:
            nb = min(span(profiles[ss[i-1]]), span(profiles[ss[i+1]]))
            if span(profiles[s]) < 0.5 * nb:
                print(f"   body {bid}: dropped partial station {axis}={s}")
                continue
        keep.append(s)
    ss = keep

    eps = 0.02
    def slab(s, tag):
        return {"prim": "extrude", "axis": axis, "name": f"st{tag}",
                "source": f"measured section convex hull at {axis}={s} "
                          "(high-res tessellation)",
                "profile": profiles[s], "z0": R(s), "z1": R(s + eps)}
    segs = [{"op": "hull", "children": [slab(ss[i], f"{i:02d}a"),
                                        slab(ss[i+1], f"{i:02d}b")]}
            for i in range(len(ss) - 1)]

    pockets, zmid = plan_pockets(lo, hi)
    cuts = []
    for k, ring in enumerate(pockets):
        cuts.append({
            "prim": "extrude", "axis": "z", "name": f"pocket{k}",
            "source": f"plan-view concavity (silhouette hull minus measured "
                      f"outline at z={zmid}): fork slot / barb notch, "
                      "vertical walls",
            "profile": ring, "z0": R(lo[2] - 0.5), "z1": R(hi[2] + 0.5)})
    print(f"body {bid}: axis={axis} {len(ss)} stations, {len(pockets)} pockets, "
          f"vol={body['volume']:.1f}")
    tree = {"op": "union", "children": segs}
    if cuts:
        tree = {"op": "difference", "children": [tree] + cuts}
    return {"body_id": bid, "strategy": "csg",
            "notes": f"hull-loft along {axis} from measured sections; plan-view "
                     "concavity cutters (fork slot/barb notches); engraved "
                     "label grooves (<0.3 mm³) intentionally omitted",
            "csg": tree}


bodies_out = []
for uid in UNIQUES:
    bodies_out.append(build_body(feats["bodies"][uid]))
for iid, of in INSTANCES.items():
    off = (np.asarray(feats["bodies"][iid]["centroid"])
           - np.asarray(feats["bodies"][of]["centroid"]))
    bodies_out.append({
        "body_id": iid, "strategy": "instance_of", "of": of,
        "translate": [R(v) for v in off],
        "source": f"centroid delta body{iid}-body{of}; canonical-anchor face "
                  "signature matches except the engraved digit (<2.2 mm² faces)",
        "notes": f"instance of body {of} (differs only in engraved label)"})
# bodies 9/11: rotate_extrude via the classifier — no plan entry needed
bodies_out.sort(key=lambda b: (b["strategy"] == "instance_of", b["body_id"]))

plan = {"version": 1, "source": feats["source"], "bodies": bodies_out}
json.dump(plan, open("output/Snap_Pins/plan.json", "w"), indent=1)
print("wrote output/Snap_Pins/plan.json")
