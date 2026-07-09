"""Thumb (polegar) — 3 parts (author's description): two parallelepipeds (a
left prong and a right prong) with an OPEN space between them, bridged by a
third parallelepiped on top connecting the two. Plus the round pin bore
through both prongs. Tilted 50deg about Z, placed at the measured thumb
position (dialed in the hand template Palm_left_V2_thumb.scad). Clean simple
primitives, no stairs, no slices.
"""
from palm_parts.common import box, cyl

R = lambda x: round(float(x), 3)


def _gbox(name, x, y, z, w, l, h, rot, tilt, az, src):
    """box(w,l,h) at (x,y,z), rot(tilt about Y, rot about Z), grown up (az)."""
    return {"transform": {"translate": [R(x), R(y), R(z)], "rotate_deg": [0, R(tilt), R(rot)]},
            "name": name,
            "child": {"transform": {"translate": [0, 0, R(az*h/2)]},
                      "child": box(name, [-w/2, -l/2, -h/2], [w, l, h], src)}}


def build():
    add = [
        _gbox("th_prong_L", 27.3, -9.0, 0, 5.2, 19, 20, 50, 0, 1, "left prong"),
        _gbox("th_prong_R", 33.5, 0.0, 0, 5.0, 17, 20, 50, 0, 1, "right prong"),
        # top bridge parallelepiped connecting the two prongs
        _gbox("th_bridge", 30.4, -4.5, 20, 9, 11, 3, 50, 0, -1, "top bridge"),
    ]
    # round pin bore through both prongs, on the 50deg pin axis
    bc = [28.7, -9.6, 5.8]
    cut = [{"transform": {"translate": bc, "rotate_deg": [0, 0, 50.3]}, "name": "th_bore",
            "child": {"transform": {"rotate_deg": [0, 90, 0]},
                      "child": cyl("th_bore", [0, 0, -8], [0, 0, 8], 2.6,
                                   "thumb pin bore r2.6 through both prongs")}}]
    return add, cut
