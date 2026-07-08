"""Ring finger encaixe + CHANNEL WALLS.

Measured (features.json planes + ref sections):
- The clevis is two prongs whose crowns are exact r6 x-axis (#465 x-17.1 /
  #462 x-7.1) with the pin at z10.6; round r2.5 bore (#286) + r3.25
  counterbores (#249/#318).
- The finger CHANNEL is formed by two side-WALL plates (~4mm thick) at the
  prong x's, rising from the deck to the measured wall tops z~13-15 (x-normal
  planes #673 z13.8, #459 z15.1, #674 z12.2, #461/#677) and running in Y from
  the body (~y20) forward to the pocket mouth (~y44, ahead of the pin at y35).
  The tab pocket is the OPEN gap between the two walls (no bridging cap — the
  z17-18 bridge belongs to the vault).
"""
from palm_parts.common import Z_DECK, box, cyl

XL, XR = -17.1, -7.1          # prong / wall centres (crowns #465/#462)
W_TH = 4.0                    # side-wall thickness
Y_BACK, Y_FRONT = 20.0, 44.0  # channel length in Y (body -> pocket mouth)
Z_WALL = 14.0                 # measured wall top (#673/#459 span)
KN_Z, KN_R = 10.62, 6.0       # pin height / crown radius
KY = 35.1                     # pin y (bore/crown line)
BORE_R, CB_R, CB_D = 2.5, 3.25, 1.6


def _prong(xc, nm):
    """One channel wall plate + its rounded knuckle crown at the pin."""
    return {"op": "union", "children": [
        box(f"ring_wall_{nm}", (xc - W_TH/2, Y_BACK, Z_DECK),
            (W_TH, Y_FRONT - Y_BACK, Z_WALL - Z_DECK),
            f"ring channel wall {nm}: side plate x[{xc-W_TH/2:.1f},"
            f"{xc+W_TH/2:.1f}] deck->z{Z_WALL:.0f} (planes #673/#459)"),
        cyl(f"ring_crown_{nm}", (xc - W_TH/2, KY, KN_Z),
            (xc + W_TH/2, KY, KN_Z), KN_R,
            f"ring knuckle crown {nm}: exact r6 x-axis (#465/#462)"),
    ]}


def build():
    walls = {"op": "union", "children": [_prong(XL, "L"), _prong(XR, "R")]}
    cuts = [
        cyl("ring_bore", (XL - W_TH, KY, KN_Z), (XR + W_TH, KY, KN_Z), BORE_R,
            "ring pin bore: exact r2.5 x-axis (#286) — round hole"),
        cyl("ring_cbore_L", (XL - W_TH/2, KY, KN_Z),
            (XL - W_TH/2 + CB_D, KY, KN_Z), CB_R,
            "ring counterbore L: exact r3.25 (#249/#318)"),
        cyl("ring_cbore_R", (XR + W_TH/2, KY, KN_Z),
            (XR + W_TH/2 - CB_D, KY, KN_Z), CB_R,
            "ring counterbore R: exact r3.25 (#249/#318)"),
    ]
    return [{"op": "difference", "children": [walls] + cuts}], []
