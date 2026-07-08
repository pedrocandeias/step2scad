"""Finger clevises (garras dos dedos): 4 projecting forks at the +Y edge.

Each finger = a rounded r6 knuckle crown (x-axis cylinder) sitting on a LOW
neck that ties it into the body, split by a central fork slot, with the r2.5
pin bore through the crown. Keeping the neck below the pin height lets the
crown round up as a prominent knuckle boss (instead of a flat-topped block).
The knuckle LINE IS ANGLED (measured): index y40 stepping back to pinky y30.
Pins are all parallel to X (measured: every r2.5 bore is x-axis) -> no splay.
Centres measured from the r6/r2.5 x-axis faces.
"""
from palm_parts.common import Z_DECK, box, cyl

# (cx = clevis centre x, ky = knuckle y) — measured from the r6/r2.5 faces
FINGERS = [(-26.0, 30.0, "pinky"), (-12.0, 35.0, "ring"),
           (-3.0, 39.0, "middle"), (11.0, 40.0, "index")]
KN_Z = 10.62     # pin / crown centre height (exact r2.5/r6 faces)
KN_R = 6.0       # knuckle crown radius (exact r6 faces)
KN_HW = 6.0      # clevis half-width in X (measured crown pair span ~11mm)
SLOT_W = 4.5     # fork slot gap (tab pocket)
NECK_LEN = 15.0  # how far the neck reaches back into the body


def build():
    add = []
    for cx, ky, nm in FINGERS:
        y0 = ky - NECK_LEN
        add.append({"op": "difference", "children": [
            {"op": "union", "children": [
                # LOW neck (only to the pin height) so the crown rounds above it
                box(f"neck_{nm}", (cx - KN_HW, y0, Z_DECK),
                    (2 * KN_HW, ky - y0, KN_Z - Z_DECK),
                    f"{nm} finger neck (low base tying the fork into the body)"),
                # rounded knuckle crown (r6) — prominent boss over the neck
                cyl(f"knuckle_{nm}", (cx - KN_HW, ky, KN_Z),
                    (cx + KN_HW, ky, KN_Z), KN_R,
                    f"{nm} knuckle crown: exact r6.000 x-axis at y{ky:.0f} z10.6"),
            ]},
            # fork slot: splits crown + neck into two rounded prongs
            box(f"slot_{nm}", (cx - SLOT_W/2, y0 + 3, Z_DECK - 1),
                (SLOT_W, ky - y0 + KN_R, KN_Z + KN_R),
                f"{nm} fork slot (tab pocket between the two prongs)"),
            cyl(f"bore_{nm}", (cx - KN_HW - 1, ky, KN_Z),
                (cx + KN_HW + 1, ky, KN_Z), 2.5,
                f"{nm} pin bore: exact r2.5 (faces #228/#286/#338...)"),
        ]})
    return add, []
