"""Wrist (punho): 2 gauntlet side walls (clean measured Y-Z profile extrudes)
each ending in an r8 ear + hinge bore.

Side walls at the measured x-planes: left x[-38.2,-33.2] (#469/#470), right
x[18.3,23.2] (#438/#92). Each wall = its measured Y-Z silhouette (base y-44..
-13 to z18.6, then the top RAMPS back over the ear and rises to the body/dome
rim at z~31 — from wrist_wall_profile.json) extruded along X: one clean smooth
wall, no box-hull, no stairs. Each caps at an r8 ear disc (#534/#535 at y-38.9
z12.6) with an r3 hinge bore (#246/#93) and a shallow counterbore (r3.88 d0.9).
"""
import json

from palm_parts.common import OUT, R, cyl

EAR_Y, EAR_Z, EAR_R = -38.95, 12.62, 8.0
CB_R, CB_D = 3.88, 0.9
# (x0, x1, name, inner=+1/-1 toward the cuff centre for the bore counterbore)
WRIST = [(-38.2, -33.2, "L", +1), (18.3, 23.2, "R", -1)]


def build():
    prof = json.load(open(OUT / "wrist_wall_profile.json"))
    add, cut = [], []
    for x0, x1, nm, inner in WRIST:
        p = prof[nm]
        add.append({"prim": "extrude", "axis": "x", "name": f"wrist_wall_{nm}",
                    "profile": [[R(a), R(b)] for a, b in p],
                    "z0": R(x0), "z1": R(x1),
                    "source": f"wrist gauntlet wall {nm}: measured Y-Z silhouette "
                    f"extruded along X x[{x0},{x1}] (rising cuff, smooth)"})
        add.append(cyl(f"ear_{nm}", (x0, EAR_Y, EAR_Z), (x1, EAR_Y, EAR_Z), EAR_R,
                       f"wrist ear {nm}: exact r8.000 disc (#534/#535) y-38.9 z12.6"))
        cut.append(cyl(f"ear_bore_{nm}", (x0 - 2, EAR_Y, EAR_Z),
                       (x1 + 2, EAR_Y, EAR_Z), 3.0,
                       f"wrist ear {nm} pin bore: exact r3.0 (#93/#246)"))
        inner_face = x1 if inner > 0 else x0
        cut.append(cyl(f"ear_cbore_{nm}", (inner_face, EAR_Y, EAR_Z),
                       (inner_face - inner * CB_D, EAR_Y, EAR_Z), CB_R,
                       f"wrist ear {nm} counterbore r3.88 d0.9 (pin-head recess)"))
    return add, cut
