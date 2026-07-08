"""Middle finger encaixe + CHANNEL WALLS (built inline).

Measured: two prongs — left x[-7.2,-3.6], right x[2.8,8.8] — with the tab
pocket the OPEN gap between them (ref material in the slot zone = 0; the high
z17-18 bridge is the VAULT, not the knuckle, so NO cap). Round r6 crowns
(#277/#337) at the pin y39.1 z10.6, round r2.5 bore (#228). The finger CHANNEL
is the two side-WALL plates at the prong x's rising deck->z~14 (walls #458
z14.9) running in Y from the body past the pin; middle projects furthest (y~45).
"""
from palm_parts.common import Z_DECK, box, cyl

PRONGS = [(-7.2, -3.6, "L"), (2.8, 8.8, "R")]   # (x0, x1, name) — measured
Y_BACK, Y_FRONT = 24.0, 45.0     # channel length in Y (body -> pocket mouth)
Z_WALL = 14.0                    # measured wall top
KN_Z, KN_R, KY = 10.62, 6.0, 39.1
BORE_R = 2.5


def _prong(x0, x1, nm):
    return {"op": "union", "children": [
        box(f"mid_wall_{nm}", (x0, Y_BACK, Z_DECK),
            (x1 - x0, Y_FRONT - Y_BACK, Z_WALL - Z_DECK),
            f"middle channel wall {nm}: side plate x[{x0:.1f},{x1:.1f}] "
            f"deck->z{Z_WALL:.0f} (#458)"),
        cyl(f"mid_crown_{nm}", (x0, KY, KN_Z), (x1, KY, KN_Z), KN_R,
            f"middle knuckle crown {nm}: exact r6 x-axis (#277/#337)"),
    ]}


def build():
    walls = {"op": "union", "children": [_prong(*p) for p in PRONGS]}
    bore = cyl("mid_bore", (-9.0, KY, KN_Z), (10.0, KY, KN_Z), BORE_R,
               "middle pin bore: exact round r2.5 (#228) x-axis")
    return [{"op": "difference", "children": [walls, bore]}], []
