"""Palm floor (chão / palma da mão): the flat perforated palmar plate.

Real measured outline (ref section z5.3, shapely-simplified) extruded between
the exact floor planes #829 (z4.62) / #828 (z6.62) — the floor is measured
FLAT (underside at z4.62 across the whole footprint; no curve/dip). The
basket-weave perforation is driven from the EXACT measured vent slots
(output/Palm_left/vent_centers.json: 107 slots, each [cx, cy, long-axis],
extracted from the ref z5.3 section) — one 3.21x2.13 box per real slot with
its measured orientation, so the grid matches the real tapered vent field
(not a rectangular grid). Refine here: outline, slot size, the vent data.
"""
import json

from palm_parts.common import OUT, R, Z_BOT, Z_DECK, box

HOLE_L, HOLE_S = 3.21, 2.13    # measured slot long / short (ref z5.3)


def build():
    add, cut = [], []
    floor_outline = json.load(open(OUT / "floor_outline.json"))
    add.append({"prim": "extrude", "axis": "z", "name": "base_plate",
                "profile2d": {"poly": [[R(p[0]), R(p[1])] for p in floor_outline]},
                "z0": Z_BOT, "z1": Z_DECK,
                "source": "flat palmar floor: measured outline (ref z5.3, "
                          "simplified) between exact planes #829/#828"})
    # one vent slot per measured hole (exact real basket-weave field)
    vents = json.load(open(OUT / "vent_centers.json"))
    for i, (cx, cy, orient) in enumerate(vents):
        lx, ly = (HOLE_L, HOLE_S) if orient == "x" else (HOLE_S, HOLE_L)
        cut.append(box(f"vent_{i:03d}",
                       (cx - lx/2, cy - ly/2, Z_BOT - 0.5),
                       (lx, ly, Z_DECK - Z_BOT + 1),
                       "basket-weave vent slot (measured 3.21x2.13, exact "
                       "centre + orientation from ref z5.3)"))
    return add, cut
