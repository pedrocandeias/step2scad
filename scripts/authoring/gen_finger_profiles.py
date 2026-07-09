"""Generate EXACT Y-Z profiles per finger tine (clean extrudes, no stairs).

Each tine is a wall roughly prismatic along X: measure its Y-Z silhouette from
the reference (occupancy projected onto the y-z plane over the tine's x-range),
simplify to a clean polygon (lines + a rounded crown top), and fingers.py
extrudes it along X. This tracks the real surface (rounded crown, tapered
base) far better than voxel boxes, with no stairs. The r2.5 pin bores are cut
separately as round cylinders.

Writes output/Palm_left/finger_profiles.json: {tine_index: [[y,z], ...]}.
Run: python3 scripts/authoring/gen_finger_profiles.py
"""
import json
from pathlib import Path

import numpy as np
import trimesh

OUT = Path("output/Palm_left")
TINES = [(-35.3, -31.5), (-25.2, -17.5), (-11.2, -3.5), (-3.5, 2.5), (2.5, 10.5), (10.5, 16.5), (16.5, 21.8)]  # 7 tines: 2 isolated + connected block sliced (only 2 real slots stay empty)
Z0, Z1 = 6.62, 16.6
Y0, Y1 = 27.0, 46.0
STEP = 0.25

ref = trimesh.load(str(OUT / "Palm_left_ref.stl"), force="mesh")


def silhouette(x0, x1):
    """Y-Z outer silhouette of the tine: for each z, the [y_min, y_max] of
    material anywhere in the tine's x-range (union projection)."""
    xs = np.arange(x0 + 0.15, x1, STEP)
    ys = np.arange(Y0, Y1, STEP)
    zs = np.arange(Z0, Z1, STEP)
    gx, gy, gz = np.meshgrid(xs, ys, zs, indexing="ij")
    occ = ref.contains(np.c_[gx.ravel(), gy.ravel(), gz.ravel()]).reshape(
        len(xs), len(ys), len(zs))
    proj = occ.any(axis=0)                      # (y, z) union over x
    left, right = [], []
    for k, z in enumerate(zs):
        yi = np.where(proj[:, k])[0]
        if len(yi) == 0:
            continue
        left.append((round(float(ys[yi[0]]), 2), round(float(z), 2)))
        right.append((round(float(ys[yi[-1]]), 2), round(float(z), 2)))
    if len(left) < 2:
        return None
    # polygon: up the left edge, down the right edge
    poly = left + right[::-1]
    return poly


def simplify(poly):
    try:
        from shapely.geometry import Polygon
        p = Polygon(poly).buffer(0).simplify(0.25)
        if p.is_empty:
            return poly
        if p.geom_type == "MultiPolygon":
            p = max(p.geoms, key=lambda g: g.area)
        return [[round(a, 2), round(b, 2)] for a, b in p.exterior.coords[:-1]]
    except Exception:
        return [[a, b] for a, b in poly]


profiles = {}
for i, (x0, x1) in enumerate(TINES):
    poly = silhouette(x0, x1)
    if poly:
        profiles[str(i)] = simplify(poly)
        print(f"tine{i} x[{x0},{x1}]: perfil {len(profiles[str(i)])} pts")
json.dump(profiles, open(OUT / "finger_profiles.json", "w"))
print(f"escrito finger_profiles.json ({len(profiles)} tines)")
