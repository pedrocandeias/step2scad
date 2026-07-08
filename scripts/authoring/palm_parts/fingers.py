"""Finger knuckles (garras) — HYBRID: exact occupancy boxes + smooth crowns.

The intricate interleaved finger clevis (solid tine bases splitting into thin
prongs) is reconstructed from finger_boxes.json (reference interior on a 0.5mm
grid, greedily merged into maximal boxes — gen_finger_boxes.py), with the
round crown discs EXCLUDED from the boxes and added here as smooth exact r6
cylinders (no voxel stairs on the curves). The r2.5 pin bores are cut as exact
round cylinders. No loft, no stairs on the round features.
"""
import json

from palm_parts.common import OUT, box, cyl

TINES = [(-35.3, -31.5), (-25.5, -17.5), (-11.5, -3.5), (2.5, 10.5), (16.5, 20.0)]
FINGERS = [(0, 1, 29.1, "pinky"), (1, 2, 35.1, "ring"),
           (2, 3, 39.1, "middle"), (3, 4, 39.1, "index")]
KN_Z, KN_R, BORE_R = 10.62, 6.0, 2.5


def build():
    boxes = json.load(open(OUT / "finger_boxes.json"))
    add = [box(f"fbox{i:03d}", mn, sz,
               "finger occupancy box (exact ref interior, crowns excluded)")
           for i, (mn, sz) in enumerate(boxes)]
    cut = []
    for li, ri, py, nm in FINGERS:
        for side, (x0, x1) in (("L", TINES[li]), ("R", TINES[ri])):
            add.append(cyl(f"crown_{nm}_{side}", (x0, py, KN_Z), (x1, py, KN_Z),
                           KN_R, f"{nm} crown {side}: smooth exact r6 (no stairs)"))
        xl0 = TINES[li][0]
        xr1 = TINES[ri][1]
        cut.append(cyl(f"bore_{nm}", (xl0 - 1, py, KN_Z), (xr1 + 1, py, KN_Z),
                       BORE_R, f"{nm} pin bore: exact round r2.5 x-axis"))
    return add, cut
