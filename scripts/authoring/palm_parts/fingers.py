"""Finger clevises (garras dos dedos): 4 projecting forks at the +Y edge.

Each finger = two prongs (r6 x-axis crowns ~11mm apart) with a central fork
slot and the r2.5 pin bore. The knuckle LINE IS ANGLED (measured): index at
y40 stepping back to pinky at y30 (fingers fan forward). Crown z10.6. Centres
measured from the r6/r2.5 x-axis faces. Refine here: crown roundness, fork
width, per-finger fan angle, projection length.
"""
from palm_parts.common import Z_DECK, box, cyl

# (cx = clevis centre x, ky = knuckle y) — measured from the r6/r2.5 faces
FINGERS = [(-26.0, 30.0, "pinky"), (-12.0, 35.0, "ring"),
           (-3.0, 39.0, "middle"), (11.0, 40.0, "index")]
KN_Z, KN_R, KN_HW, SLOT_W = 10.62, 6.0, 5.5, 4.0


def build():
    add, cut = [], []
    for cx, ky, nm in FINGERS:
        y0 = ky - 14.0
        add.append({"op": "difference", "children": [
            {"op": "union", "children": [
                box(f"neck_{nm}", (cx - KN_HW, y0, Z_DECK),
                    (2 * KN_HW, ky - y0, KN_Z + KN_R - Z_DECK),
                    f"{nm} finger neck (ties the fork into the body)"),
                cyl(f"knuckle_{nm}", (cx - KN_HW, ky, KN_Z),
                    (cx + KN_HW, ky, KN_Z), KN_R,
                    f"{nm} knuckle crown: exact r6.000 x-axis at y{ky:.0f} z10.6"),
            ]},
            box(f"slot_{nm}", (cx - SLOT_W/2, y0 + 4, Z_DECK - 1),
                (SLOT_W, ky - y0, KN_R + 4),
                f"{nm} fork slot (splits the knuckle into two prongs)"),
            cyl(f"bore_{nm}", (cx - KN_HW - 1, ky, KN_Z),
                (cx + KN_HW + 1, ky, KN_Z), 2.5,
                f"{nm} pin bore: exact r2.5 (faces #228/#286/#338...)"),
        ]})
    return add, cut
