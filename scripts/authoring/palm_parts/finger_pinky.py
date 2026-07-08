"""Pinky finger knuckle — built INLINE with a full-height OPEN fork slot.

Measured (ref section @z10.6): knuckle centre (-26.3, 35.8); two ROUND r6
prong bosses at x-33.1 / x-19.1 (span x[-35.3,-17.5]=17.8, ~10mm gap between
them). ROUND r2.5 pin bore + r3.25 counterbore (#248). The tab pocket is OPEN
top-to-bottom (prongs separate) — the fingerlib U-cap wrongly bridged it, and
the high z17-18 material is the VAULT, not the knuckle. So the slot is FULL
HEIGHT and open (front +Y open, back corner rounded). Refine: span, gap.
"""
from palm_parts.common import Z_DECK, box, cyl

CX, KY, KN_Z = -26.3, 35.8, 10.62   # MEASURED knuckle centre
KN_R, KN_HW = 6.0, 8.9              # crown radius / half-width (span 17.8)
SLOT_W, NECK = 10.0, 9.0            # prong gap (measured) / neck reach
TOP_Z = KN_Z + KN_R
Y0 = KY - NECK


def build():
    solid = {"op": "union", "children": [
        box("neck_pinky", (CX - KN_HW, Y0, Z_DECK),
            (2 * KN_HW, KY - Y0, KN_Z - Z_DECK),
            "pinky neck (low base tying the fork into the body)"),
        cyl("knuckle_pinky", (CX - KN_HW, KY, KN_Z), (CX + KN_HW, KY, KN_Z),
            KN_R, "pinky knuckle crown: r6 x-axis at y35.8 z10.6"),
    ]}
    clevis = {"op": "difference", "children": [
        solid,
        # full-height OPEN tab pocket (prongs stay separate; NOT capped)
        box("slot_pinky", (CX - SLOT_W/2, Y0 + 3, Z_DECK - 1),
            (SLOT_W, (KY + KN_R) - (Y0 + 3), TOP_Z + 2),
            "pinky fork slot: open tab pocket, full height between the prongs"),
        cyl("slot_back_pinky", (CX, Y0 + 3, KN_Z), (CX, Y0 + 3, TOP_Z), SLOT_W/2,
            "pinky slot rounded back corner (z-axis)"),
        cyl("bore_pinky", (CX - KN_HW - 1, KY, KN_Z), (CX + KN_HW + 1, KY, KN_Z),
            2.5, "pinky pin bore: exact round r2.5 (#234)"),
        cyl("cbore_pinky", (-22.5, KY, KN_Z), (-19.0, KY, KN_Z), 3.25,
            "pinky counterbore: exact r3.25 (#248) pin-head recess"),
    ]}
    return [clevis], []
