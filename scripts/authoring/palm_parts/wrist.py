"""Wrist (punho): 2 gauntlet side walls each ending in an r8 ear + hinge bore.

Side walls run along Y (measured wall planes at y-28.6): left x[-38,-33],
right x[18,23], rising from the deck. Each caps at an r8 ear disc (faces
#534/#535 at y-38.9 z12.6) with an r3 hinge bore (#246/#93). Refine here:
wall curve/length (the gauntlet), ear counterbore, the cuff opening.
"""
from palm_parts.common import Z_DECK, box, cyl

EAR_Y, EAR_Z, EAR_R, EAR_W = -38.95, 12.62, 8.0, 5.0
WALL_Y0, WALL_Y1, WALL_TOP = EAR_Y, -16.0, 20.0
WRIST = [(-38.5, "L"), (17.5, "R")]   # wall/ear near-x per side


def build():
    add, cut = [], []
    for x0, nm in WRIST:
        add.append(box(f"wrist_wall_{nm}", (x0, WALL_Y0, Z_DECK),
                       (EAR_W, WALL_Y1 - WALL_Y0, WALL_TOP - Z_DECK),
                       f"wrist gauntlet wall {nm}: measured side wall "
                       f"(planes #438/#92 or #469/#470) x[{x0:.0f},{x0+EAR_W:.0f}]"))
        add.append(cyl(f"ear_{nm}", (x0, EAR_Y, EAR_Z),
                       (x0 + EAR_W, EAR_Y, EAR_Z), EAR_R,
                       f"wrist ear {nm}: exact r8.000 disc (#534/#535) y-38.9 z12.6"))
        cut.append(cyl(f"ear_bore_{nm}", (x0 - 2, EAR_Y, EAR_Z),
                       (x0 + EAR_W + 2, EAR_Y, EAR_Z), 3.0,
                       f"wrist ear {nm} pin bore: exact r3.0 (#93/#246)"))
    return add, cut
