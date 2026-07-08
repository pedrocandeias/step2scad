"""Shared anchors + primitive helpers for the Palm_left big-primitive parts.

Every part module (floor/fingers/thumb/wrist) imports these and returns
(add, cut) lists of measured primitives. All dimensions come from the exact
B-rep faces (features.json) or the reference tessellation — never guessed.
"""
import json
from pathlib import Path

import numpy as np  # noqa: F401  (parts use it)

OUT = Path("output/Palm_left")
R = lambda x: round(float(x), 3)

# ---- measured anchors (exact planes) ----
Z_BOT = 4.62      # exact bottom plane #829 (flat underside)
Z_DECK = 6.62     # exact deck plane #828 (palmar plate top, ~2mm)
Z_APEX = 29.3     # measured dome apex (broad cap)


def box(name, mn, sz, src):
    return {"prim": "box", "name": name,
            "min": [R(mn[0]), R(mn[1]), R(mn[2])],
            "size": [R(sz[0]), R(sz[1]), R(sz[2])], "source": src}


def cyl(name, p0, p1, r, src):
    return {"prim": "cylinder", "name": name,
            "p0": [R(p0[0]), R(p0[1]), R(p0[2])],
            "p1": [R(p1[0]), R(p1[1]), R(p1[2])], "r": R(r), "source": src}
