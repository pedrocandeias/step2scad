"""Thumb (polegar) — the real simple form (author's description): a CUBE with
the front top/bottom corners rounded, minus a DISC removed from the middle
(the clevis slot). Measured in the 50deg pin-local frame:
- block (ly,z): ly[-6,12.9] z[5,24], front (high-ly) corners rounded (RC);
- thickness perp to the pin: local-x [LX0,LX1] (measured ~[-8,7.8]);
- DISC void (r) at (ly=-1, z=12.3), axis along local-x -> the open slot;
extruded along local-x, tilted 50deg, placed at the pin centre. Clean prism,
no stairs, slot stays open. Pin bore r2.7 through it.
"""
import numpy as np

from palm_parts.common import R, cyl

TH_C = [31.2, -5.9, 0.0]
TH_ANG = 50.0
LX0, LX1 = -8.0, 7.8           # thickness perpendicular to the pin (measured)
LY0, LY1 = -6.0, 12.9          # along the pin (front = LY1)
Z0, Z1 = 5.0, 23.9
RC = 3.5                       # front top/bottom corner round
DISC = (-1.0, 12.3, 4.5)       # (ly, z, radius) removed disc = the clevis slot
BORE_R = 2.7


def _outer():
    pts = [[LY0, Z0]]
    for a in np.linspace(-90, 0, 8):
        pts.append([LY1 - RC + RC*np.cos(np.radians(a)), Z0 + RC + RC*np.sin(np.radians(a))])
    for a in np.linspace(0, 90, 8):
        pts.append([LY1 - RC + RC*np.cos(np.radians(a)), Z1 - RC + RC*np.sin(np.radians(a))])
    pts.append([LY0, Z1])
    return [[R(p[0]), R(p[1])] for p in pts]


def build():
    dy, dz, rr = DISC
    disc = [[R(dy + rr*np.cos(t)), R(dz + rr*np.sin(t))]
            for t in np.linspace(0, 2*np.pi, 28, endpoint=False)]
    block = {"prim": "extrude", "axis": "x", "name": "thumb_block",
             "profile2d": {"op2d": "difference", "children": [
                 {"poly": _outer()}, {"poly": disc}]},
             "z0": R(LX0), "z1": R(LX1),
             "source": "thumb cube (front corners rounded) minus the middle "
                       "disc (open clevis slot), extruded along the perp axis"}
    add = [{"transform": {"translate": TH_C, "rotate_deg": [0, 0, TH_ANG]},
            "name": "thumb", "child": block}]
    cut = [cyl("thumb_bore", (28.0 - 6*0.64, -11.7 - 6*0.77, 10.4),
               (28.0 + 12*0.64, -11.7 + 12*0.77, 10.4), BORE_R,
               "thumb pivot bore: exact r2.7 (#226) on the 50deg pin axis")]
    return add, cut
