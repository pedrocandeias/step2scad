"""Thumb (polegar): a tilted keyhole clevis on the +X side.

Measured: clevis crown r7.5 (#524) centred (31.2,-5.9,z10.6) on a horizontal
pin whose axis is (0.64,0.77,0)=50° tilt about Z; pivot bore r2.7 (#226).
The real form (ref render) is a KEYHOLE FORK: two tombstone prong-plates
(rounded top around the pin hole) standing up from the deck, separated ALONG
the pin axis by a fork slot (where the thumb tab inserts), pin bore through
both. Built in a local frame (pin along local X) then rotated 50° about Z and
seated on the deck. Refine here: prong width, slot gap, crown radius.
"""
from palm_parts.common import Z_DECK, box, cyl

TH_C = [31.2, -5.9, Z_DECK]        # crown centre xy, base on the deck
TH_ANG = 50.0                      # tilt (oblique faces normal 0.64,0.77)
CR_R = 7.5                         # keyhole crown radius (#524)
PIN_Z = 10.62 - Z_DECK             # pin height above the deck (world z10.62)
T = 4.0                            # prong-plate thickness (along the pin)
GAP = 4.5                          # fork slot (tab clearance, along the pin)
WY = CR_R                          # prong half-width in Y (tombstone)


def _prong(nm, x0):
    # a tombstone plate PERPENDICULAR to the pin: a rectangular shaft rising
    # deck->pin, capped by the rounded crown half-disc at the pin height.
    return {"op": "union", "children": [
        box(f"thumb_shaft_{nm}", (x0, -WY, 0), (T, 2 * WY, PIN_Z),
            f"thumb prong {nm} shaft (deck -> pin)"),
        cyl(f"thumb_crown_{nm}", (x0, 0, PIN_Z), (x0 + T, 0, PIN_Z), CR_R,
            f"thumb prong {nm} keyhole crown: exact r7.5 (face #524)"),
    ]}


def build():
    fork = {"op": "difference", "children": [
        {"op": "union", "children": [
            _prong("a", GAP / 2),          # plate on +X side of the slot
            _prong("b", -GAP / 2 - T),     # plate on -X side of the slot
        ]},
        cyl("thumb_bore", (-GAP/2 - T - 1, 0, PIN_Z), (GAP/2 + T + 1, 0, PIN_Z),
            2.7, "thumb pivot bore: exact r2.7 (faces #226/#184)"),
    ]}
    thumb = {"transform": {"translate": TH_C, "rotate_deg": [0, 0, TH_ANG]},
             "name": "thumb", "child": fork}
    # low connector tying the thumb base back toward the palm body
    neck = box("thumb_neck", (18.0, -14.0, Z_DECK), (16.0, 14.0, 5.0),
               "thumb base connector into the palm body")
    return [thumb, neck], []
