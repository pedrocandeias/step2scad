"""Thumb (polegar): a tilted single-LUG pivot mount on the +X side.

Corrected form (from the reference render): the palm thumb mount is ONE
rounded LUG (a flat paddle plate with a single pin hole), not a fork — the
thumb piece is the clevis that grips this lug. Measured: rounded tip crown
r7.5 (#524) at (31.2,-5.9,z10.6) on a horizontal pin axis (0.64,0.77,0)=50°
about Z; pivot bore r2.7 (#226). The lug plate rises from a chunky base that
joins the palm body; region bbox x[22,42] y[-24,4] z[4.6,26]. Built in a
local frame (pin along local X) then rotated 50° about Z and seated on the
deck. Refine here: lug thickness/width, base bulk, tip position.
"""
from palm_parts.common import Z_DECK, box, cyl

TH_C = [31.2, -5.9, Z_DECK]        # lug-tip crown centre xy, base on the deck
TH_ANG = 50.0                      # tilt (oblique faces normal 0.64,0.77)
CR_R = 7.5                         # rounded lug-tip crown radius (#524)
PIN_Z = 10.62 - Z_DECK             # pin height above the deck (world z10.62)
T = 6.0                            # lug plate thickness (along the pin axis)
NECK = 6.0                         # how far the lug root sits below the tip


def build():
    # single lug plate (perpendicular to the pin), rounded r7.5 tip, one bore
    lug = {"op": "difference", "children": [
        {"op": "union", "children": [
            box("thumb_lug", (-T/2, -CR_R, -NECK), (T, 2 * CR_R, PIN_Z + NECK),
                "thumb lug plate (paddle rising from the base to the tip)"),
            cyl("thumb_crown", (-T/2, 0, PIN_Z), (T/2, 0, PIN_Z), CR_R,
                "thumb lug rounded tip: exact r7.5 (face #524) at z10.6"),
        ]},
        cyl("thumb_bore", (-T/2 - 1, 0, PIN_Z), (T/2 + 1, 0, PIN_Z), 2.7,
            "thumb pivot bore: exact r2.7 (faces #226/#184)"),
    ]}
    thumb = {"transform": {"translate": TH_C, "rotate_deg": [0, 0, TH_ANG]},
             "name": "thumb", "child": lug}
    # chunky base block tying the lug into the palm body (measured bbox root)
    base = box("thumb_base", (22.0, -18.0, Z_DECK), (13.0, 20.0, 8.0),
               "thumb mount base (bulk joining the lug to the palm body)")
    return [thumb, base], []
