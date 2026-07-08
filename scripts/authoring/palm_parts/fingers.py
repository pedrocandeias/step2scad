"""Finger knuckles (garras) — EXACT OCCUPANCY reconstruction (author's choice).

The finger clevis is an intricate interleaved 3D solid (wide solid tine bases
that split into thin prongs higher up, per-finger varying widths) that a few
big primitives cannot match. This reads finger_boxes.json — the reference
interior sampled on a 0.5mm grid and greedily merged into maximal
axis-aligned boxes (gen_finger_boxes.py). The pin bores come out hollow for
free (the reference is hollow there). Exact occupancy; the only downside is
~0.5mm voxel steps on the round crowns (finer grid -> smaller steps, more
boxes). No loft.
"""
import json

from palm_parts.common import OUT, box


def build():
    boxes = json.load(open(OUT / "finger_boxes.json"))
    add = [box(f"fbox{i:03d}", mn, sz,
               "finger occupancy box (exact ref interior, 0.5mm greedy-merged)")
           for i, (mn, sz) in enumerate(boxes)]
    return add, []
