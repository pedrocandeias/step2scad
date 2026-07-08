"""Ring finger knuckle (encaixe). Measured (ref sections + faces):

The knuckle is a single r6 tube along X (crowns #462 x-7.1 / #465 x-17.1,
same y35.1 z10.6 axis) cut by a FULL-HEIGHT tab slot into two separate prongs
+ round r2.5 bore (#286) + r3.25 pin-head counterbores (#249/#318).

Section validation (recon vs ref at x-12.1, YZ): the reference is OPEN at the
slot centre (its only material there is the z17-18 vault-merge bar) — so the
tab pocket must stay OPEN top-to-bottom. fingerlib's rounded U-slot cap
BRIDGES the prongs (solid crown at the centre) — wrong here — so this module
builds the clevis inline with a full-height slot (rounded front corner for a
clean pocket, but open to the top). The high bridge belongs to the vault.
"""
from palm_parts.common import Z_DECK, box, cyl

CX, KY, KN_Z, KN_R, KN_HW = -12.1, 35.1, 10.62, 6.0, 7.0
SLOT_W, NECK_LEN = 5.0, 15.0
CB_R, CB_D = 3.25, 1.6


def build():
    y0 = KY - NECK_LEN
    top_z = KN_Z + KN_R
    solid = {"op": "union", "children": [
        box("neck_ring", (CX - KN_HW, y0, Z_DECK),
            (2 * KN_HW, KY - y0, KN_Z - Z_DECK),
            "ring finger neck (low base into the body)"),
        cyl("knuckle_ring", (CX - KN_HW, KY, KN_Z), (CX + KN_HW, KY, KN_Z),
            KN_R, "ring knuckle tube: exact r6 x-axis (crowns #462/#465)"),
    ]}
    # FULL-HEIGHT tab slot keeping the two prongs separate; front (+Y) open,
    # back corner rounded (a clean rounded-end pocket, not a sharp box, but
    # NOT bridged over the top)
    sy0, sy1 = y0 + 3, KY + KN_R + 1
    slot = {"op": "union", "children": [
        box("slot_ring", (CX - SLOT_W/2, sy0, Z_DECK - 1),
            (SLOT_W, sy1 - sy0, top_z + 2),
            "ring tab slot channel (full height -> prongs stay separate)"),
        cyl("slot_ring_back", (CX, sy0, Z_DECK - 1 + SLOT_W/2),
            (CX, sy0, top_z + 1), SLOT_W/2,
            "ring slot rounded back corner (clean pocket end)"),
    ]}
    cbore = [
        cyl("ring_cbore_L", (CX - KN_HW, KY, KN_Z),
            (CX - KN_HW + CB_D, KY, KN_Z), CB_R,
            "ring counterbore L: exact r3.25 (#249/#318)"),
        cyl("ring_cbore_R", (CX + KN_HW, KY, KN_Z),
            (CX + KN_HW - CB_D, KY, KN_Z), CB_R,
            "ring counterbore R: exact r3.25 (#249/#318)"),
    ]
    clevis = {"op": "difference", "children": [
        solid, slot,
        cyl("bore_ring", (CX - KN_HW - 1, KY, KN_Z), (CX + KN_HW + 1, KY, KN_Z),
            2.5, "ring pin bore: exact r2.5 (#286)"),
    ] + cbore}
    return [clevis], []
