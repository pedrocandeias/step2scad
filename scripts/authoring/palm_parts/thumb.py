"""Thumb (polegar) — X-SLICE profile extrudes (clean, follows the taper).

The thumb narrows sharply along X and is a non-prismatic saddle; a solid box
over-fills. Instead reads thumb_profiles.json (per-X-slice measured Y-Z
silhouettes, gen_thumb_profiles.py) and extrudes each slice along X — follows
the real taper/shape, no stairs, no voxels. The r7.5 lug crown (#524) is kept
as a smooth cylinder and the r2.7/r2.5 pin bores cut as round cylinders.
"""
import json

from palm_parts.common import OUT, R, Z_DECK, box, cyl


def build():
    slices = json.load(open(OUT / "thumb_profiles.json"))
    add = [{"prim": "extrude", "axis": "x", "name": f"thslice{i:02d}",
            "profile": [[R(p[0]), R(p[1])] for p in s["profile"]],
            "z0": R(s["x0"]), "z1": R(s["x1"]),
            "source": f"thumb X-slice x[{s['x0']},{s['x1']}]: measured Y-Z "
            "silhouette (follows the taper)"}
           for i, s in enumerate(slices)]
    # lower pivot bore r2.7 (#226) along the 50deg pin axis, + r2.5 (#184)
    cut = [cyl("thumb_bore", (28.0 - 6*0.64, -11.7 - 6*0.77, 10.4),
               (28.0 + 10*0.64, -11.7 + 10*0.77, 10.4), 2.7,
               "thumb pivot bore: exact r2.7 (#226) on the 50deg pin axis"),
           cyl("thumb_upbore", (39.3 - 7*0.77, -11.4 + 7*0.64, 16.6),
               (39.3 + 5*0.77, -11.4 - 5*0.64, 16.6), 3.0,
               "thumb upper pin bore (#300 region)")]
    # template keyhole: rect slot (opens the clevis) at bc rotated 50.3deg
    bc=[28.7,-9.6,5.8]
    cut.append({"transform":{"translate":bc,"rotate_deg":[0,0,50.3]},"name":"th_slot",
        "child":{"transform":{"translate":[11,0,0]},
            "child":box("th_slot",[-4,-1.95,-2.95],[8,3.9,5.9],
                        "keyhole rect slot (open clevis) from the template")}})
    return add, cut
