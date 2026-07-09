"""Thumb (polegar) — 3 parts (author's description): a left prong and a right
prong with an OPEN space between them, bridged by a third box on top. The
prongs have a QUARTER-CIRCLE bottom (front-bottom corner rounded). Tuned
against the ghost: the left (Red) prong receded, the right (Blue) prong moved
toward the left. Plus the round pin bore. Tilted 50deg. Clean primitives.

Adjust knobs: L_X/L_Y (red position), R_X/R_Y (blue position), RC (bottom
quarter-circle radius), prong sizes W/L/H.
"""
import numpy as np

from palm_parts.common import box, cyl

R = lambda x: round(float(x), 3)

# --- prong placement (tuned to the ghost) ---
L_X, L_Y = 25.8, -9.0          # red (left) prong — RECEDED (was x27.3)
R_X, R_Y = 33.5, -3.0          # blue (right) prong — moved toward red (was y0)
W, PL, PH = 5.2, 19.0, 20.0    # prong thickness / length / height
RC = 4.0                       # bottom quarter-circle radius
ANG = 50.0


def _prong_profile(rc):
    """(l,h) profile: rectangle with the FRONT-BOTTOM corner a quarter circle."""
    l, h = PL, PH
    pts = [[-l/2, -h/2]]                       # back-bottom
    for a in np.linspace(-90, 0, 10):         # front-bottom quarter arc
        pts.append([l/2 - rc + rc*np.cos(np.radians(a)),
                    -h/2 + rc + rc*np.sin(np.radians(a))])
    pts += [[l/2, h/2], [-l/2, h/2]]           # front-top, back-top
    return [[R(p[0]), R(p[1])] for p in pts]


def _prong(name, x, y, color):
    prof = _prong_profile(RC)
    block = {"prim": "extrude", "axis": "x", "name": name,
             "profile": prof, "z0": R(-W/2), "z1": R(W/2),
             "source": f"{name}: prong, quarter-circle bottom, extruded along x"}
    return {"transform": {"translate": [R(x), R(y), 0], "rotate_deg": [0, 0, ANG]},
            "name": name, "color": color,
            "child": {"transform": {"translate": [0, 0, R(PH/2)]}, "child": block}}


def _gbox(name, x, y, z, w, l, h, rot, tilt, az, src, color=None):
    node = {"transform": {"translate": [R(x), R(y), R(z)], "rotate_deg": [0, R(tilt), R(rot)]},
            "name": name,
            "child": {"transform": {"translate": [0, 0, R(az*h/2)]},
                      "child": box(name, [-w/2, -l/2, -h/2], [w, l, h], src)}}
    if color:
        node["color"] = color
    return node


def build():
    add = [
        _prong("th_prong_L", L_X, L_Y, "Red"),
        _prong("th_prong_R", R_X, R_Y, "Blue"),
        _gbox("th_bridge", 30.4, -6.0, 20, 9, 11, 3, 50, 0, -1, "top bridge (Green)", "Green"),
    ]
    bc = [28.7, -9.6, 5.8]
    cut = [{"transform": {"translate": bc, "rotate_deg": [0, 0, 50.3]}, "name": "th_bore",
            "child": {"transform": {"rotate_deg": [0, 90, 0]},
                      "child": cyl("th_bore", [0, 0, -8], [0, 0, 8], 2.6,
                                   "thumb pin bore r2.6 through both prongs")}}]
    return add, cut
