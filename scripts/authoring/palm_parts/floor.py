"""Palm floor (chão / palma da mão): the flat perforated palmar plate.

Real measured outline (ref section z5.3, shapely-simplified) extruded between
the exact floor planes #829 (z4.62) / #828 (z6.62), minus the basket-weave
vent grid (3.21x2.13 slots, pitch 4.9, orientation alternating by row — the
exact measured vent geometry). Refine here: outline, vent size/pitch/pattern.
"""
import json

import numpy as np

from palm_parts.common import OUT, R, Z_BOT, Z_DECK, box


def build():
    add, cut = [], []
    floor_outline = json.load(open(OUT / "floor_outline.json"))
    add.append({"prim": "extrude", "axis": "z", "name": "base_plate",
                "profile2d": {"poly": [[R(p[0]), R(p[1])] for p in floor_outline]},
                "z0": Z_BOT, "z1": Z_DECK,
                "source": "flat palmar floor: measured outline (ref z5.3, "
                          "simplified) between exact planes #829/#828"})
    # basket-weave vent grid, clipped to points inside the floor outline.
    # Measured (ref z5.3): 99 slots, pitch 4.63, long/short 3.11/2.13,
    # centres over x[-28.5,15.7] y[-26.6,22.5], orientation alternating by row.
    from matplotlib.path import Path as _P
    # clip to the floor outline inset ~2.5mm (vents keep off the rim); fall
    # back to the raw outline if shapely is unavailable
    try:
        from shapely.geometry import Polygon
        _ins = Polygon(floor_outline).buffer(-2.5)
        _pts = (list(_ins.exterior.coords) if _ins.geom_type == "Polygon"
                else list(max(_ins.geoms, key=lambda g: g.area).exterior.coords))
        poly = _P(np.array(_pts))
    except Exception:
        poly = _P(np.array(floor_outline))
    HOLE_L, HOLE_S, PITCH = 3.11, 2.13, 4.63
    VX0, VY0 = -28.5, -26.6                 # measured vent region (bottom-left)
    for col in range(0, 10):                # x -28.5 .. 13.2 (measured region)
        for row in range(0, 11):            # y -26.6 .. 19.7 (measured region)
            cx, cy = VX0 + PITCH * col, VY0 + PITCH * row
            if not poly.contains_point((cx, cy)):
                continue
            lx, ly = (HOLE_L, HOLE_S) if row % 2 == 0 else (HOLE_S, HOLE_L)
            cut.append(box(f"vent_{col}_{row}",
                           (cx - lx/2, cy - ly/2, Z_BOT - 0.5),
                           (lx, ly, Z_DECK - Z_BOT + 1),
                           "basket-weave vent slot (3.11x2.13, pitch 4.63)"))
    return add, cut
