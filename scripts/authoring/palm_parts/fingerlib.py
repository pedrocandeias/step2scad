"""Shared finger-clevis builder — one call per finger, options per knuckle.

Each finger's own module (finger_pinky/ring/middle/index) calls build_clevis()
with its MEASURED params. Knuckles differ: some terminate ROUND (r6 crown),
some FLAT (a boxy top); pin holes are not always round (some are slots). The
options cover those; if a finger needs something else, build the node inline
in its own module (self-contained) instead of extending this shared helper.
"""
from palm_parts.common import Z_DECK, box, cyl


def build_clevis(cx, ky, nm, kn_z=10.62, kn_r=6.0, kn_hw=7.0, slot_w=4.5,
                 neck_len=15.0, tip="round", bore="round", bore_r=2.5,
                 bore_slot=None):
    """One finger clevis at centre (cx, ky).

    tip  : "round" -> r=kn_r x-axis crown cap; "flat" -> boxy flat top at
           z = kn_z + kn_r (a flat knuckle end).
    bore : "round" -> r=bore_r x-axis hole; "slot" -> an oblong hole of
           bore_slot=(len_y, dia) along Y (a non-round pin hole).
    Returns a single CSG difference node.
    """
    y0 = ky - neck_len
    top_z = kn_z + kn_r
    if tip == "flat":
        knuckle = box(f"knuckle_{nm}", (cx - kn_hw, ky - kn_r, Z_DECK),
                      (2 * kn_hw, 2 * kn_r, top_z - Z_DECK),
                      f"{nm} knuckle: FLAT termination (measured flat end)")
    else:
        knuckle = cyl(f"knuckle_{nm}", (cx - kn_hw, ky, kn_z),
                      (cx + kn_hw, ky, kn_z), kn_r,
                      f"{nm} knuckle crown: exact r{kn_r:g} x-axis at y{ky:.0f}")
    solid = {"op": "union", "children": [
        box(f"neck_{nm}", (cx - kn_hw, y0, Z_DECK),
            (2 * kn_hw, ky - y0, kn_z - Z_DECK),
            f"{nm} finger neck (low base tying the fork into the body)"),
        knuckle,
    ]}
    # fork slot = a ROUNDED U-channel (not a sharp rectangle): a box up to the
    # pin height capped by a Y-axis half-cylinder, so the tab pocket reads as a
    # round-topped slot under the round crown (matches the reference clevis).
    sy0, sy1 = y0 + 3, ky + kn_r
    cuts = [
        box(f"slot_{nm}", (cx - slot_w/2, sy0, Z_DECK - 1),
            (slot_w, sy1 - sy0, kn_z - (Z_DECK - 1)),
            f"{nm} fork slot channel (tab pocket, up to the pin height)"),
        cyl(f"slot_cap_{nm}", (cx, sy0, kn_z), (cx, sy1, kn_z), slot_w/2,
            f"{nm} fork slot rounded top (U-slot, radius = slot half-width)"),
    ]
    if bore == "slot" and bore_slot:
        ly, dia = bore_slot
        cuts.append({"op": "hull", "children": [
            cyl(f"bore_{nm}_a", (cx - kn_hw - 1, ky - ly/2, kn_z),
                (cx + kn_hw + 1, ky - ly/2, kn_z), dia/2,
                f"{nm} pin slot end a (non-round hole)"),
            cyl(f"bore_{nm}_b", (cx - kn_hw - 1, ky + ly/2, kn_z),
                (cx + kn_hw + 1, ky + ly/2, kn_z), dia/2,
                f"{nm} pin slot end b"),
        ]})
    else:
        cuts.append(cyl(f"bore_{nm}", (cx - kn_hw - 1, ky, kn_z),
                        (cx + kn_hw + 1, ky, kn_z), bore_r,
                        f"{nm} pin bore: exact r{bore_r:g} x-axis"))
    return {"op": "difference", "children": [solid] + cuts}
