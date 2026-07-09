"""Thumb (polegar): a tilted two-axis saddle mount on the +X side.

Measured (occupancy in the 50deg pin-local frame): the thumb is a non-prismatic
~48%-solid saddle spanning localX[-19,8] localY[-7,14] z[5,24] — NOT a clean
fork (the centre is solid, no through-slot). The main mass is a tilted housing
(faces = the ±50deg walls #453/#539/#540/#331), densest and tallest toward the
+localX/top; a single clean void sits at localY[-3,0] z[8,11]. Lower lug r7.5
(#524) on the 50deg pin (0.64,0.77,0) at z10.6; upper tower carries the 2nd
saddle pin r7 (#300, axis 0.77,-0.64) at z16.6. Clean primitives only — the
distributed ~52% voids are fillets/tapers that don't map to clean cuts, so a
solid housing shaped to the real envelope is the clean-form approximation.
"""
from palm_parts.common import Z_DECK, box, cyl

TH_C = [31.2, -5.9, Z_DECK]        # pin centre xy, base on the deck; 50deg frame
TH_ANG = 50.0
CR_R = 7.5                         # lower lug tip crown radius (#524)
PIN_Z = 10.62 - Z_DECK            # lower pin height above the deck


def build():
    # housing shaped to the measured envelope in the pin-local frame:
    # localX[-16,8], localY[-6.5,7] (the dense core), z up to ~23 (measured top)
    housing = {"op": "difference", "children": [
        box("thumb_housing", (-16, -6.5, 0), (24, 13.5, 16.4),
            "thumb housing: tilted mass shaped to the measured envelope "
            "(±50deg walls #453/#539/#540/#331), up to z23"),
        # the clean measured voids (empty in the occupancy map)
        box("thumb_void1", (-17, -3.0, 8.0 - Z_DECK), (26, 3.5, 3.6),
            "thumb clevis void: measured hollow at localY[-3,0] z8-11"),
        box("thumb_void2", (-17, -6.6, 6.6 - Z_DECK), (16, 2.8, 2.4),
            "thumb lower-left void: measured empty at localY[-6.6,-4] z6.6-9"),
    ]}
    # lower lug paddle + rounded r7.5 tip + pivot bore r2.7
    lug = {"op": "difference", "children": [
        {"op": "union", "children": [
            box("thumb_lug", (-3, -CR_R, 0), (6, 2 * CR_R, PIN_Z),
                "thumb lug paddle rising to the pin"),
            cyl("thumb_crown", (-3, 0, PIN_Z), (3, 0, PIN_Z), CR_R,
                "thumb lug rounded tip: exact r7.5 (#524) at z10.6"),
        ]},
        cyl("thumb_bore", (-4, 0, PIN_Z), (4, 0, PIN_Z), 2.7,
            "thumb lower pivot bore: exact r2.7 (#226/#184)"),
    ]}
    thumb = {"transform": {"translate": TH_C, "rotate_deg": [0, 0, TH_ANG]},
             "name": "thumb", "child": {"op": "union", "children": [housing, lug]}}

    # upper tower (2nd saddle axis) in world coords (axis differs)
    ux, uy, uz = 39.3, -11.4, 16.6
    ax = (0.77, -0.64, 0.0)
    tower = {"op": "difference", "children": [
        box("thumb_tower", (33.0, -16.0, Z_DECK), (9.0, 10.0, uz + 3 - Z_DECK),
            "thumb upper tower: 2nd saddle pin block"),
        cyl("thumb_upbore", (ux - ax[0]*7, uy - ax[1]*7, uz),
            (ux + ax[0]*7, uy + ax[1]*7, uz), 3.0,
            "thumb upper pin bore (#300 region)"),
    ]}
    return [thumb, tower], []
