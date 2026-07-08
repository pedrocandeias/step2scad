"""Index finger encaixe + CHANNEL WALLS (built inline; most +X finger).

Measured: two asymmetric prongs — left x[2.5,10.5] (~8mm), right x[16.5,20]
(~3.5mm) — with the tab pocket the OPEN gap between them (slot x[10.5,16.5]).
Round r6 crown (#350) at the pin y39.1 z10.6, round r2.5 bore (#338). The
finger CHANNEL is the two side-WALL plates at the prong x's rising deck->z~14
and running in Y from the body past the pin. (The "flat top" in a normal-Y
section is just the round x-axis crown sectioned along its own axis.)
"""
from palm_parts.common import Z_DECK, box, cyl

PRONGS = [(2.5, 10.5, "L"), (16.5, 20.0, "R")]   # (x0, x1, name) — measured
Y_BACK, Y_FRONT = 30.0, 44.0     # channel length in Y (body -> pocket mouth)
Z_WALL = 14.0                    # measured wall top
KN_Z, KN_R, KY = 10.62, 6.0, 39.1
BORE_R = 2.5


def _prong(x0, x1, nm):
    return {"op": "union", "children": [
        box(f"index_wall_{nm}", (x0, Y_BACK, Z_DECK),
            (x1 - x0, Y_FRONT - Y_BACK, Z_WALL - Z_DECK),
            f"index channel wall {nm}: side plate x[{x0:.1f},{x1:.1f}] "
            f"deck->z{Z_WALL:.0f}"),
        cyl(f"index_crown_{nm}", (x0, KY, KN_Z), (x1, KY, KN_Z), KN_R,
            f"index knuckle crown {nm}: exact r6 x-axis (#350)"),
    ]}


def build():
    walls = {"op": "union", "children": [_prong(*p) for p in PRONGS]}
    bore = cyl("index_bore", (1.0, KY, KN_Z), (21.0, KY, KN_Z), BORE_R,
               "index pin bore: exact round r2.5 (#338) x-axis")
    return [{"op": "difference", "children": [walls, bore]}], []
