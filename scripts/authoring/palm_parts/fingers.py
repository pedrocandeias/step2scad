"""Finger clevises (garras): aggregates the 4 per-finger modules so each
knuckle can be refined independently (finger_pinky/ring/middle/index)."""
from palm_parts import finger_index, finger_middle, finger_pinky, finger_ring

def build():
    add, cut = [], []
    for f in (finger_pinky, finger_ring, finger_middle, finger_index):
        a, c = f.build()
        add += a
        cut += c
    return add, cut
