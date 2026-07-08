"""Wrist (punho): 2 gauntlet side walls each ending in an r8 ear + hinge bore.

Side walls run along Y (measured wall planes at y-28.6: left x[-38,-33] faces
#469/#470, right x[18,23] faces #438/#92). Measured: the wall top RISES from
~z22 at the ear to ~z30 at the body (the gauntlet cuff curving up to the dome
rim) — modelled as a hull of a low ear-end box and a high body-end box (one
clean sloped wall). Each caps at an r8 ear disc (#534/#535 at y-38.9 z12.6)
with an r3 hinge bore (#246/#93) and a shallow counterbore (template r3.88
d0.9) on the inner face. Refine here: wall slope/length, ear detail.
"""
from palm_parts.common import Z_DECK, box, cyl

EAR_Y, EAR_Z, EAR_R, EAR_W = -38.95, 12.62, 8.0, 5.0
Z_EAR_TOP, Z_BODY_TOP = 22.0, 30.0     # measured wall-top rise (ear -> body)
Y_ROOT = -14.0                          # wall root into the body
CB_R, CB_D = 3.88, 0.9                  # ear counterbore (template)
# (x0 = wall/ear near-x, inner = +1/-1 toward the cuff centre for the bore CB)
WRIST = [(-38.5, "L", +1), (17.5, "R", -1)]


def build():
    add, cut = [], []
    for x0, nm, inner in WRIST:
        # rising gauntlet wall = hull(low ear-end box, high body-end box)
        add.append({"op": "hull", "children": [
            box(f"wrist_wall_{nm}_ear", (x0, EAR_Y, Z_DECK),
                (EAR_W, 5.0, Z_EAR_TOP - Z_DECK),
                f"wrist wall {nm} ear-end (low): x[{x0:.0f},{x0+EAR_W:.0f}]"),
            box(f"wrist_wall_{nm}_body", (x0, Y_ROOT - 3, Z_DECK),
                (EAR_W, 3.0, Z_BODY_TOP - Z_DECK),
                f"wrist wall {nm} body-end (high, rises to the dome rim z30)"),
        ]})
        # r8 ear disc + r3 hinge bore
        add.append(cyl(f"ear_{nm}", (x0, EAR_Y, EAR_Z),
                       (x0 + EAR_W, EAR_Y, EAR_Z), EAR_R,
                       f"wrist ear {nm}: exact r8.000 disc (#534/#535) y-38.9 z12.6"))
        cut.append(cyl(f"ear_bore_{nm}", (x0 - 2, EAR_Y, EAR_Z),
                       (x0 + EAR_W + 2, EAR_Y, EAR_Z), 3.0,
                       f"wrist ear {nm} pin bore: exact r3.0 (#93/#246)"))
        # shallow counterbore on the inner face (pin-head recess)
        inner_face = x0 + EAR_W if inner > 0 else x0
        cut.append(cyl(f"ear_cbore_{nm}", (inner_face, EAR_Y, EAR_Z),
                       (inner_face - inner * CB_D, EAR_Y, EAR_Z), CB_R,
                       f"wrist ear {nm} counterbore r3.88 d0.9 (pin-head recess)"))
    return add, cut
