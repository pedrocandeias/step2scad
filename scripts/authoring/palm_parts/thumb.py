"""Thumb (polegar): a tilted two-axis saddle mount on the +X side, WALLED.

Measured (features.json): a 2-DOF saddle. LOWER pin axis (0.64,0.77,0)=50°
about Z at z10.6 carries the rounded lug (r7.5 #524 @31.2,-5.9). The mount is
a WALLED housing: oblique side-wall planes normal ±(0.64,0.77) at low z
(#453 @36.4,0.2 / #539 @28,-7.1 / #540 @31.8,-2.5 / #331 @28.1,-13.7). An
UPPER tower carries the 2nd saddle axis: pin r7 (#300 @39.3,-11.4,z16.6, axis
0.77,-0.64) + #172, wall #241 @36.6,-10.4,z18.7. Region bbox x[22,42]
y[-24,4] z[4.6,26]. Built with big primitives: a tilted walled housing + the
lower lug + the upper tower. Refine here: wall extents, tower size/bore.
"""
from palm_parts.common import Z_DECK, box, cyl

TH_C = [31.2, -5.9, Z_DECK]        # lower-lug pin centre xy, base on the deck
TH_ANG = 50.0                      # tilt (oblique walls normal 0.64,0.77)
CR_R = 7.5                         # lower lug tip crown radius (#524)
PIN_Z = 10.62 - Z_DECK             # lower pin height above the deck
T = 6.0                            # lug plate thickness (along the pin)
WALL_H = 8.0                       # walled-housing height above the deck


def build():
    # --- local (50°-tilted) frame: pin along local X, seated on the deck ---
    # walled housing base: a tilted block (its faces ARE the ±50° side walls),
    # reaching from the body (-local-x) out under the lug
    housing = box("thumb_housing", (-15, -8.5, 0), (22, 17, WALL_H),
                  "thumb mount housing: tilted walled base (±50° side walls, "
                  "planes #453/#539/#540/#331)")
    # lower lug paddle rising to the pin, rounded r7.5 tip, pivot bore r2.7
    lug = {"op": "difference", "children": [
        {"op": "union", "children": [
            box("thumb_lug", (-T/2, -CR_R, 0), (T, 2 * CR_R, PIN_Z),
                "thumb lug paddle (rises from the housing to the pin)"),
            cyl("thumb_crown", (-T/2, 0, PIN_Z), (T/2, 0, PIN_Z), CR_R,
                "thumb lug rounded tip: exact r7.5 (face #524) at z10.6"),
        ]},
        cyl("thumb_bore", (-T/2 - 1, 0, PIN_Z), (T/2 + 1, 0, PIN_Z), 2.7,
            "thumb lower pivot bore: exact r2.7 (faces #226/#184)"),
    ]}
    local = {"op": "union", "children": [housing, lug]}
    thumb = {"transform": {"translate": TH_C, "rotate_deg": [0, 0, TH_ANG]},
             "name": "thumb", "child": local}

    # --- upper tower (2nd saddle axis), built in world coords (axis differs) ---
    # r7 pin #300 @(39.3,-11.4,16.6), axis (0.77,-0.64,0); wall #241 z18.7
    ux, uy, uz = 39.3, -11.4, 16.6
    ax = (0.77, -0.64, 0.0)
    tower = {"op": "difference", "children": [
        box("thumb_tower", (33.0, -16.0, Z_DECK), (9.0, 10.0, uz + 3 - Z_DECK),
            "thumb upper tower: raised block carrying the 2nd saddle pin"),
        cyl("thumb_upbore", (ux - ax[0]*7, uy - ax[1]*7, uz),
            (ux + ax[0]*7, uy + ax[1]*7, uz), 3.0,
            "thumb upper pin bore (face #300 region)"),
    ]}
    return [thumb, tower], []
