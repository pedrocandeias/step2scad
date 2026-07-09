"""Generate EXACT Y-Z profiles per thumb X-slice (clean, follows the taper).

The thumb narrows sharply along X (x22-24 ~87% solid near the palm, down to
~4% at the lug tip) — a constant solid box over-fills the thin end massively.
Like the finger tines, slice the thumb along X and extrude each slice's
measured Y-Z silhouette: follows the real taper/shape, no stairs, no voxels.
The r2.5/r2.7 pin bores are cut separately as round cylinders.

Writes output/Palm_left/thumb_profiles.json: [{x0,x1,profile[[y,z]...]}, ...].
Run: python3 scripts/authoring/gen_thumb_profiles.py
"""
import json
from pathlib import Path

import numpy as np
import trimesh

OUT = Path("output/Palm_left")
X0, X1, DX = 22.0, 42.0, 1.5          # thumb X-slices
Y0, Y1 = -24.0, 5.0
Z0, Z1 = 4.62, 25.0
STEP = 0.3

ref = trimesh.load(str(OUT / "Palm_left_ref.stl"), force="mesh")


def slice_profile(xa, xb):
    """Y-Z outer silhouette of the material in [xa,xb] (union over x)."""
    xs = np.arange(xa + 0.15, xb, STEP)
    ys = np.arange(Y0, Y1, STEP)
    zs = np.arange(Z0, Z1, STEP)
    gx, gy, gz = np.meshgrid(xs, ys, zs, indexing="ij")
    occ = ref.contains(np.c_[gx.ravel(), gy.ravel(), gz.ravel()]).reshape(
        len(xs), len(ys), len(zs))
    proj = occ.any(axis=0)
    left, right = [], []
    for k, z in enumerate(zs):
        yi = np.where(proj[:, k])[0]
        if len(yi) == 0:
            continue
        left.append((round(float(ys[yi[0]]), 2), round(float(z), 2)))
        right.append((round(float(ys[yi[-1]]), 2), round(float(z), 2)))
    if len(left) < 2:
        return None
    poly = left + right[::-1]
    try:
        from shapely.geometry import Polygon
        p = Polygon(poly).buffer(0).simplify(0.3)
        if p.geom_type == "MultiPolygon":
            p = max(p.geoms, key=lambda g: g.area)
        return [[round(a, 2), round(b, 2)] for a, b in p.exterior.coords[:-1]]
    except Exception:
        return [[a, b] for a, b in poly]


slices = []
for xa in np.arange(X0, X1, DX):
    prof = slice_profile(xa, xa + DX)
    if prof:
        slices.append({"x0": round(float(xa), 2), "x1": round(float(xa + DX), 2),
                       "profile": prof})
json.dump(slices, open(OUT / "thumb_profiles.json", "w"))
print(f"{len(slices)} fatias -> thumb_profiles.json")
