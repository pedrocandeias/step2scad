"""Author output/Tensioner_Pins/plan.json.

STRATEGY (agent decision): each pin = intersection of three measured octagonal
prisms (XZ cross-section x YZ side profile x XY plan outline — all vertices are
intersections of exact B-rep plane equations), minus the tendon slot (prismatic
along x between the two raycast-measured conic bspline walls), minus the blind
tendon bore (exact cylinder face + planar cap). Bodies 1/2 are translated
instances (identical volume + face sets; offset = exact centroid delta).

Every number here is EITHER an exact features.json value, an intersection of
two exact plane equations, or a probe raycast measurement (the bspline walls).
"""
import json
import numpy as np

feats = json.load(open("output/Tensioner_Pins/features.json"))
b0, b1, b2 = feats["bodies"]
F = {f["index"]: f for f in b0["faces"]}


def plane_eq(idx):
    """(unit normal, offset) with n.p = offset for face idx."""
    n = np.asarray(F[idx]["params"]["normal"], float)
    n /= np.linalg.norm(n)
    return n, float(n @ np.asarray(F[idx]["params"]["origin"], float))


def isect2(eq_a, eq_b, ax_u, ax_v):
    """Intersection point (u, v) of two plane equations restricted to the
    (ax_u, ax_v) coordinate plane (both normals lie in that plane)."""
    (na, da), (nb, db) = eq_a, eq_b
    A = np.array([[na[ax_u], na[ax_v]], [nb[ax_u], nb[ax_v]]])
    return np.linalg.solve(A, [da, db]).tolist()


def r6(x):
    return [round(v, 6) for v in x] if isinstance(x, list) else round(x, 6)


# ---- XZ cross-section octagon (faces 0/31 walls, 15 top, 24 bottom,
#      13/25 bottom chamfers, 14/30 top chamfers) — profile axes (x, z) ----
eq = {i: plane_eq(i) for i in (0, 31, 15, 24, 13, 25, 14, 30)}
xz = [
    isect2(eq[24], eq[13], 0, 2),   # bottom / +x bottom chamfer
    isect2(eq[13], eq[0], 0, 2),    # +x bottom chamfer / +x wall
    isect2(eq[0], eq[14], 0, 2),    # +x wall / +x top chamfer
    isect2(eq[14], eq[15], 0, 2),   # +x top chamfer / top
    isect2(eq[15], eq[30], 0, 2),   # top / -x top chamfer
    isect2(eq[30], eq[31], 0, 2),   # -x top chamfer / -x wall
    isect2(eq[31], eq[25], 0, 2),   # -x wall / -x bottom chamfer
    isect2(eq[25], eq[24], 0, 2),   # -x bottom chamfer / bottom
]

# ---- XY plan octagon (walls 0/31, ends 16/23, corner chamfers 4/7/26/28) ----
eq = {i: plane_eq(i) for i in (0, 31, 16, 23, 4, 7, 26, 28)}
xy = [
    isect2(eq[0], eq[4], 0, 1),     # +x wall / (+x,+y) corner chamfer
    isect2(eq[4], eq[16], 0, 1),    # corner / +y end
    isect2(eq[16], eq[26], 0, 1),
    isect2(eq[26], eq[31], 0, 1),   # -x wall
    isect2(eq[31], eq[28], 0, 1),
    isect2(eq[28], eq[23], 0, 1),   # -y end
    isect2(eq[23], eq[7], 0, 1),
    isect2(eq[7], eq[0], 0, 1),
]

# ---- YZ side octagon (ends 16/23, top 15, bottom 24, end chamfers
#      17/20 top, 18/21 bottom) — profile axes (y, z) ----
eq = {i: plane_eq(i) for i in (16, 23, 15, 24, 17, 20, 18, 21)}
yz = [
    isect2(eq[24], eq[18], 1, 2),   # bottom / +y bottom end chamfer
    isect2(eq[18], eq[16], 1, 2),   # / +y end
    isect2(eq[16], eq[17], 1, 2),   # / +y top end chamfer
    isect2(eq[17], eq[15], 1, 2),   # / top
    isect2(eq[15], eq[20], 1, 2),   # top / -y top end chamfer
    isect2(eq[20], eq[23], 1, 2),   # / -y end
    isect2(eq[23], eq[21], 1, 2),   # / -y bottom end chamfer
    isect2(eq[21], eq[24], 1, 2),   # / bottom
]

# ---- slot walls: probe raycast measurements at x=0 (prismatic along x:
#      wall y varies < 0.003 mm across x in [-1.4, 1.4]) ----
head_wall = [  # (z, y) samples of bspline face 11/12 wall on the head side
    (0.70, -14.348953), (1.00, -14.069137), (1.40, -13.751725),
    (1.80, -13.501885), (2.20, -13.318744), (2.60, -13.197268),
    (3.00, -13.141806), (3.20, -13.137367), (3.40, -13.150415),
    (3.80, -13.217820), (4.20, -13.352434), (4.60, -13.551634),
    (5.00, -13.814756), (5.30, -14.060239), (5.40, -14.147448),
]
bar_wall = [
    (0.70, -10.646316), (1.00, -10.530743), (1.40, -10.384704),
    (1.80, -10.281356), (2.20, -10.200298), (2.60, -10.146129),
    (3.00, -10.126810), (3.20, -10.122524), (3.40, -10.123424),
    (3.80, -10.159263), (4.20, -10.216109), (4.60, -10.299863),
    (5.00, -10.416808), (5.30, -10.520836), (5.40, -10.557256),
]


def extend(w, z_to):
    """Linear extrapolation of the outermost wall segment to overshoot z."""
    (z_a, y_a), (z_b, y_b) = (w[0], w[1]) if z_to < w[0][0] else (w[-2], w[-1])
    return (z_to, y_b + (y_b - y_a) / (z_b - z_a) * (z_to - z_b))


head = [extend(head_wall, 0.3)] + head_wall + [extend(head_wall, 5.8)]
bar = [extend(bar_wall, 0.3)] + bar_wall + [extend(bar_wall, 5.8)]
# polygon in (y, z): up the head wall, down the bar wall
slot_profile = [[r6(y), r6(z)] for z, y in head] + [[r6(y), r6(z)] for z, y in reversed(bar)]

# slot x extent: exact plane faces 9/10
x_slot = [plane_eq(9)[1] * np.sign(plane_eq(9)[0][0]) * -1, None]
sx9 = plane_eq(9); sx10 = plane_eq(10)
slot_x0 = sx9[1] / sx9[0][0]      # face 9: n=[1,0,0] -> x = offset
slot_x1 = sx10[1] / sx10[0][0]    # face 10: n=[-1,0,0] -> x = -offset

# bore: exact cylinder face 2 + planar cap face 1
cyl = F[2]["params"]
cap_y = plane_eq(1)[1] / plane_eq(1)[0][1]
bore_r = cyl["radius"]
ax_o = cyl["axis_origin"]  # x, z of the bore axis
y_end = plane_eq(16)[1] / plane_eq(16)[0][1]  # +y end face

# instance offsets: exact centroid deltas
off1 = (np.asarray(b1["centroid"]) - np.asarray(b0["centroid"])).tolist()
off2 = (np.asarray(b2["centroid"]) - np.asarray(b0["centroid"])).tolist()

plan = {
    "version": 1,
    "source": feats["source"],
    "bodies": [
        {
            "body_id": 0,
            "strategy": "csg",
            "notes": "chamfered bar = intersection of three measured octagonal "
                     "prisms; minus tendon slot (prismatic in x, raycast-measured "
                     "conic walls); minus blind tendon bore (exact cylinder+cap)",
            "csg": {
                "op": "difference",
                "children": [
                    {
                        "op": "intersection",
                        "children": [
                            {
                                "prim": "extrude", "axis": "y",
                                "name": "xsec",
                                "source": "XZ octagon: exact plane faces 0/31 (walls x=±2.377583), "
                                          "15 (top z=5.413925), 24 (bottom z=0.659863), 13/25 "
                                          "(45° bottom chamfers), 14/30 (top chamfers); vertices = "
                                          "plane-pair intersections",
                                "profile": [[r6(z), r6(x)] for x, z in xz],
                                "z0": r6(-y_end), "z1": r6(y_end),
                            },
                            {
                                "prim": "extrude", "axis": "z",
                                "name": "plan_xy",
                                "source": "XY octagon: exact plane faces 0/31, 16/23 (ends "
                                          "y=±16.559241), 4/7/26/28 (45° corner chamfers)",
                                "profile": [[r6(x), r6(y)] for x, y in xy],
                                "z0": 0.0, "z1": 6.0,
                            },
                            {
                                "prim": "extrude", "axis": "x",
                                "name": "side_yz",
                                "source": "YZ octagon: exact plane faces 16/23, 15, 24, 17/20 "
                                          "(top end chamfers), 18/21 (bottom end chamfers)",
                                "profile": [[r6(y), r6(z)] for y, z in yz],
                                "z0": -2.5, "z1": 2.5,
                            },
                        ],
                    },
                    {
                        "prim": "extrude", "axis": "x",
                        "name": "slot",
                        "source": "tendon slot between bspline faces 11/12: wall y(z) raycast-"
                                  "measured at x=0 (prismatic: <0.003mm variation across x); "
                                  "x span = exact plane faces 9/10 (x=±1.455185); z overshoot "
                                  "0.3/5.8 extrapolates the last measured segment",
                        "profile": slot_profile,
                        "z0": r6(slot_x0), "z1": r6(slot_x1),
                    },
                    {
                        "prim": "cylinder",
                        "name": "bore",
                        "source": "blind tendon bore: exact cylinder face 2 (r=1.507237, axis "
                                  "[0,-1,0] through x=0 z=3.037447) + planar cap face 1 at "
                                  "y=-8.770356; +y end overshoots the exit face 16 by ~1mm",
                        "p0": [r6(ax_o[0]), r6(cap_y), r6(ax_o[2])],
                        "p1": [r6(ax_o[0]), r6(y_end + 1.0), r6(ax_o[2])],
                        "r": r6(bore_r),
                    },
                ],
            },
        },
        {
            "body_id": 1, "strategy": "instance_of", "of": 0,
            "translate": [r6(v) for v in off1],
            "source": "exact centroid delta body1-body0 (identical volume/faces)",
            "notes": "identical pin, +x neighbor",
        },
        {
            "body_id": 2, "strategy": "instance_of", "of": 0,
            "translate": [r6(v) for v in off2],
            "source": "exact centroid delta body2-body0 (identical volume/faces)",
            "notes": "identical pin, -x neighbor",
        },
    ],
}

out = "output/Tensioner_Pins/plan.json"
with open(out, "w") as f:
    json.dump(plan, f, indent=1)
print("wrote", out)
print("xz:", [r6(list(p)) for p in xz])
print("xy:", [r6(list(p)) for p in xy])
print("yz:", [r6(list(p)) for p in yz])
print("slot x:", r6(slot_x0), r6(slot_x1), " bore r:", r6(bore_r), "cap y:", r6(cap_y))
print("offsets:", [r6(v) for v in off1], [r6(v) for v in off2])
