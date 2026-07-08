"""Index finger knuckle (most +X finger, near the thumb).

MEASURED (ref normal-Y sections y37.5/y40.5 — SECTIONS, not contains() which
phantoms here): the index encaixe is a FORK of two ROUND-crowned tines with an
OFF-CENTRE slot (my earlier single solid crown + narrow centred slot was
wrong; the "flat top" seen in a normal-Y section is just the round x-axis
crown's silhouette along its own axis):
  - left  tine  x[2.5, 10.5]  (~8 mm wide)
  - right tine  x[16.5, 20.0] (~3.5 mm wide)
  - fork slot (tab pocket)  x[10.5, 16.5]  (~6 mm gap)
  - each tine = neck (deck->pin) + round r6 crown (#350) at (y39.1, z10.6)
  - round r2.5 pin bore (#338) through both — the hole IS round
Built inline (self-contained): asymmetric tines differ from the symmetric
build_clevis. Refine here: tine widths, slot gap, crown radius.
"""
from palm_parts.common import Z_DECK, box, cyl

KY, BZ, KN_R = 39.1, 10.62, 6.0     # pin y / z, crown radius
Y0, Y1 = 33.5, 41.6                 # tine root (into body) / front reach
TINES = [(2.5, 8.0, "L"), (16.5, 3.5, "R")]   # (x0, width, name)


def build():
    parts = []
    for x0, w, nm in TINES:
        parts.append(box(f"index_neck_{nm}", (x0, Y0, Z_DECK),
                         (w, KY - Y0, BZ - Z_DECK),
                         f"index tine {nm} neck (deck->pin) x[{x0:.1f},{x0+w:.1f}]"))
        parts.append(cyl(f"index_crown_{nm}", (x0, KY, BZ), (x0 + w, KY, BZ),
                         KN_R, f"index tine {nm} round crown: exact r6 (#350)"))
    solid = {"op": "union", "children": parts}
    bore = cyl("index_bore", (1.0, KY, BZ), (21.0, KY, BZ), 2.5,
               "index pin bore: exact r2.5 x-axis (#338) — round hole")
    return [{"op": "difference", "children": [solid, bore]}], []
