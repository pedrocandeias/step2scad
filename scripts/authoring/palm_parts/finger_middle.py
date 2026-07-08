"""Middle finger knuckle (projecting clevis at the +Y edge) — built INLINE.

MEASURED (ref contains()-scans):
  - fork centred at x-0.25 (NOT -3.1): left prong x[-7.2,-3.6], slot
    x[-3.5,3.0] (~6.5mm), right prong x[2.8,8.8] at the tips (y43-45, z10.6).
  - the tab pocket is OPEN top-to-bottom (ref material in the slot zone
    x±1.5,y34-40,z7-16.6 == 0 pts) — the high z17-18 bridge is the VAULT,
    NOT the knuckle, so the slot must NOT be capped (fingerlib's U-cap
    bridged it: 95 phantom pts). Built inline here with a full-height open
    slot to keep the two prongs separate.
  - termination ROUND (r6 crowns #277/#337), bore ROUND r2.5 (#228).
"""
from palm_parts.common import Z_DECK, box, cyl

CX, KY = -0.25, 39.1
KN_Z, KN_R, KN_HW, SLOT_W, NECK_LEN = 10.62, 6.0, 7.5, 6.5, 15.0


def build():
    y0 = KY - NECK_LEN
    top_z = KN_Z + KN_R
    solid = {"op": "union", "children": [
        box("neck_middle", (CX - KN_HW, y0, Z_DECK),
            (2 * KN_HW, KY - y0, KN_Z - Z_DECK),
            "middle finger neck (low base into the body)"),
        cyl("knuckle_middle", (CX - KN_HW, KY, KN_Z), (CX + KN_HW, KY, KN_Z),
            KN_R, "middle knuckle crown: exact r6 x-axis (#277/#337) at y39 z10.6"),
    ]}
    cuts = [
        # OPEN full-height tab pocket (measured empty top-to-bottom) — splits
        # the crown into two separate rounded prongs; NOT capped.
        box("slot_middle", (CX - SLOT_W/2, y0 + 3, Z_DECK - 1),
            (SLOT_W, (KY + KN_R) - (y0 + 3), (top_z + 1) - (Z_DECK - 1)),
            "middle fork slot: OPEN tab pocket (measured 0 material), width 6.5"),
        cyl("bore_middle", (CX - KN_HW - 1, KY, KN_Z), (CX + KN_HW + 1, KY, KN_Z),
            2.5, "middle pin bore: exact round r2.5 (#228) x-axis"),
    ]
    return [{"op": "difference", "children": [solid] + cuts}], []
