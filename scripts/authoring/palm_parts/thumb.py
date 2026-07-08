"""Thumb (polegar): a tilted keyhole clevis on the +X side.

Measured clevis crown r7.5 (#524) centred (31,-6,z10.6) on the tilted pin
axis (0.64,0.77,0)=50°; pivot bore r2.7 (#226). Built in a local frame (pin
along local X) then rotated 50° about Z and placed at the deck. Refine here:
crown prominence, fork slot depth, prong shape, the connection to the body.
"""
from palm_parts.common import Z_DECK, box, cyl

TH_C = [31.0, -6.0, Z_DECK]        # crown centre xy, base at the deck
TH_ANG = 50.0                      # tilt (oblique faces normal 0.64,0.77)
CR_R = 7.5
PIN_Z = 10.62 - Z_DECK             # pin height above the deck
PW, PGAP, PL = 3.5, 4.0, 15.0      # prong width, slot gap, length along pin


def build():
    thumb = {"op": "difference", "children": [
        {"op": "union", "children": [
            box("thumb_prong_a", (-PL/2, PGAP/2, 0), (PL, PW, PIN_Z + CR_R),
                "thumb fork prong A"),
            box("thumb_prong_b", (-PL/2, -PGAP/2 - PW, 0), (PL, PW, PIN_Z + CR_R),
                "thumb fork prong B"),
            cyl("thumb_crown", (-PL/2, 0, PIN_Z), (PL/2, 0, PIN_Z), CR_R,
                "thumb clevis crown: exact r7.5 (face #524) at z10.6"),
        ]},
        box("thumb_slot", (-PL/2 - 1, -PGAP/2, 0), (PL + 2, PGAP, PIN_Z + 1),
            "thumb fork slot (U-gap between the prongs, open to the deck)"),
        cyl("thumb_bore", (-PL/2 - 1, 0, PIN_Z), (PL/2 + 1, 0, PIN_Z), 2.7,
            "thumb pivot bore: exact r2.7 (faces #226/#184)"),
    ]}
    add = [{"transform": {"translate": TH_C, "rotate_deg": [0, 0, TH_ANG]},
            "name": "thumb", "child": thumb}]
    return add, []
