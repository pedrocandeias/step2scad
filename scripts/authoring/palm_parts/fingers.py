"""Finger knuckles (garras) — EXACT Y-Z PROFILE extrudes (clean, no stairs).

Each tine is a wall roughly prismatic along X. fingers reads
finger_profiles.json (its measured Y-Z silhouette — base + rounded crown top,
from gen_finger_profiles.py) and extrudes it along X for the tine's x-range:
smooth surfaces, no voxel stairs, no loft. The r2.5 pin bores are cut as exact
round cylinders through the tines.
"""
import json

from palm_parts.common import OUT, R, cyl

TINES = [(-35.3, -31.5), (-25.2, -17.5), (-11.2, -3.5), (-3.5, 2.5), (2.5, 10.5), (10.5, 16.5), (16.5, 21.8)]  # 7 tines: 2 isolated + connected block sliced (only 2 real slots stay empty)
# (x_lo, x_hi, pin_y, name) — bores drilled through the tines at each pin
FINGERS = [(-35, -17, 29.1, "pinky"), (-25, -7, 35.1, "ring"),
           (-11, 2, 39.1, "middle"), (2, 21, 39.1, "index")]
KN_Z, BORE_R = 10.62, 2.5


def build():
    profiles = json.load(open(OUT / "finger_profiles.json"))
    add = []
    for i, (x0, x1) in enumerate(TINES):
        prof = profiles.get(str(i))
        if not prof:
            continue
        add.append({"prim": "extrude", "axis": "x", "name": f"tine{i}",
                    "profile": [[R(p[0]), R(p[1])] for p in prof],
                    "z0": R(x0), "z1": R(x1),
                    "source": f"finger tine {i}: measured Y-Z silhouette "
                    f"extruded along X x[{x0},{x1}] (base + rounded crown)"})
    cut = []
    for xl, xh, py, nm in FINGERS:
        cut.append(cyl(f"bore_{nm}", (xl - 1, py, KN_Z), (xh + 1, py, KN_Z),
                       BORE_R, f"{nm} pin bore: exact round r2.5 x-axis"))
    return add, cut
