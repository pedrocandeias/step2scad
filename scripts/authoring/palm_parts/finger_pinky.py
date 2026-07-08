"""Pinky finger knuckle + CHANNEL WALLS — built INLINE.

Encaixe (measured, ref section @z10.6): knuckle centre (-26.3, 35.8); two
ROUND r6 prong bosses at x-33.1 / x-19.1 (span x[-35.3,-17.5]=17.8, ~10mm
gap). ROUND r2.5 bore + r3.25 counterbore (#248). Tab pocket OPEN full height.

Channel WALLS (measured, normal-Y sections of the ref): the finger is a
channel of two tine-walls rising from the deck, tapering front->back:
  inner tine (x-21..-17.5): z18-19 at y29-33 -> z11 at y41 (reaches the front)
  outer tine (x-34..-31):   z18 at y29     -> z11, ends ~y35 (shorter)
The high z18-20 toward the body (y28-32) is the vault-merge. Modelled as two
tapering wall plates (hull of a tall body-end box + a short knuckle-end box)
flanking the open pocket, plus the r6 knuckle crown + bore at the front.
"""
from palm_parts.common import Z_DECK, box, cyl

CX, KY, KN_Z = -26.3, 35.8, 10.62   # measured knuckle centre
KN_R, KN_HW = 6.0, 8.9              # crown radius / half-width (span 17.8)
SLOT_W = 10.0                       # prong gap (measured)
TOP_Z = KN_Z + KN_R


def _wall(nm, x0, x1, y_body, z_body, y_front, z_front):
    """A tapering tine-wall: tall at the body end, short at the knuckle end."""
    return {"op": "hull", "children": [
        box(f"wall_{nm}_body", (x0, y_body, Z_DECK),
            (x1 - x0, 2.0, z_body - Z_DECK),
            f"pinky {nm} channel wall (body end, rises to z{z_body:.0f})"),
        box(f"wall_{nm}_front", (x0, y_front - 2, Z_DECK),
            (x1 - x0, 2.0, z_front - Z_DECK),
            f"pinky {nm} channel wall (knuckle end, z{z_front:.0f})"),
    ]}


def build():
    solid = {"op": "union", "children": [
        # rising channel walls (measured tine-wall heights, tapering front-back)
        _wall("outer", -34.0, -31.0, 28.0, 17.5, 35.5, 11.5),
        _wall("inner", -21.0, -17.5, 28.0, 18.5, 41.0, 11.5),
        # low base tying the two walls into the body (below the pin)
        box("neck_pinky", (CX - KN_HW, KY - 9, Z_DECK),
            (2 * KN_HW, 9, KN_Z - Z_DECK),
            "pinky neck (low base under the pin, tying the fork to the body)"),
        # r6 knuckle crown (rounded pin boss) at the front
        cyl("knuckle_pinky", (CX - KN_HW, KY, KN_Z), (CX + KN_HW, KY, KN_Z),
            KN_R, "pinky knuckle crown: r6 x-axis at y35.8 z10.6"),
    ]}
    clevis = {"op": "difference", "children": [
        solid,
        # full-height OPEN tab pocket (prongs stay separate; NOT capped)
        box("slot_pinky", (CX - SLOT_W/2, KY - 6, Z_DECK - 1),
            (SLOT_W, (KY + KN_R) - (KY - 6), TOP_Z + 2),
            "pinky fork slot: open tab pocket, full height between the prongs"),
        cyl("bore_pinky", (CX - KN_HW - 1, KY, KN_Z), (CX + KN_HW + 1, KY, KN_Z),
            2.5, "pinky pin bore: exact round r2.5 (#234)"),
        cyl("cbore_pinky", (-22.5, KY, KN_Z), (-19.0, KY, KN_Z), 3.25,
            "pinky counterbore: exact r3.25 (#248) pin-head recess"),
    ]}
    return [clevis], []
