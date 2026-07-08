"""Pinky finger knuckle.

Measured (ref + faces): the pinky clevis is ROUND/ROUND — two r6 x-axis crown
prongs (#623 x-31.1, #441 x-21.1), a ROUND r2.5 pin bore (#234 at x-24.5,
pin midpoint x-26.1 z10.6) plus a shallow r3.25 counterbore (#248 at x-22.5).
Knuckle material spans x[-32.4,-17.1] (width 15.3). Not flat, not oblong.
Refine here: span, slot, counterbore.
"""
from palm_parts.common import cyl
from palm_parts.fingerlib import build_clevis

CX, KY, KN_Z = -26.1, 29.1, 10.62   # pin midpoint (measured)


def build():
    clevis = build_clevis(CX, KY, "pinky", kn_z=KN_Z, kn_r=6.0, kn_hw=7.5,
                          slot_w=6.0, tip="round", bore="round", bore_r=2.5)
    # shallow r3.25 counterbore on the inner prong's outer face (pin-head recess)
    cbore = cyl("pinky_cbore", (-22.5, KY, KN_Z), (-19.0, KY, KN_Z), 3.25,
                "pinky counterbore: exact r3.25 (#248) pin-head recess")
    return [{"op": "difference", "children": [clevis, cbore]}], []
