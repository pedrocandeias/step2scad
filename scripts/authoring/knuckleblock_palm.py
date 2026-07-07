"""Claim the palm's mating architecture as named parameters (coverage audit).

The author spotted that the fin/clip mating geometry went unrecognized. The
coverage audit (report.unclaimed_faces) surfaced it as exact-face families;
measurement decoded the knuckle-block architecture:

  - 4 finger sockets, each EXACTLY 6.00 wide (x-normal plane pairs
    #458/#452, #451/#824, #459/#673, #637/#467) between the r6.000-crowned
    clevis walls — mating the measured PROXIMAL beam width 5.200
    (beam_wall_x1 - beam_wall_x0 in output/Proximals/plan.json) with 0.80
    total clearance, lobe r6.000 articulating on crown r6.000 flush;
  - elastic-return slots 2.20 wide with r1.10 rounded ends on each socket
    centerline (planes #163/#188, #167/#260, #258/#166; z-cylinders
    #186/#187/#204/#257);
  - dorsal snap tabs 2.64 wide over each socket (plane pairs #213/#306,
    #182/#183, #221/#225, #196/#198; thumb #178/#180);
  - the THUMB clevis in a frame tilted EXACTLY 50.000 deg (axis
    (0.6428, 0.766, 0)): two 5.00 walls (#331/#539, #540/#453) crowned by
    exact r6.000 cylinders (#433, #541; outer crown #210), a 6.00 throat
    (same width as the finger sockets) floored by the exact r7.5 cylinder
    #524, counterbores r2.7/#226/#319/#320 and r2.5/#184;
  - the 5.00 wrist support wall (#469/#470).

These features are geometrically CORRECT in the plan already (vertical
planes are exact in the band footprints; the crowns were fixed by the
round-region surgery) — this stage makes them EXPLAINED: named reference
parameters with face-cited provenance, so the coverage audit counts them
claimed and a human editing the .scad sees the mating dims.

Thumb-clevis band replacement was measured as NOT safely feasible: the
bands there are full-width palm sections (the clevis is a lobe of each
footprint), so drop-and-replace would require carving ~30 wide-band
footprints — the anatomical re-segmentation already noted as future work.
The tilted arcs remain represented per-band (the (z,x) profiles carry the
local arc; the staircase amplitude along y is bounded by the 0.6 band
pitch).

Chained from author_palm_left_parametric.py after roundregions_palm.
"""
import json
from pathlib import Path

OUT = Path("output/Palm_left")

MATING_PARAMS = [
    ("socket_w", 6.0,
     "EXACT finger-socket width: x-normal plane pairs #458/#452, #451/#824, "
     "#459/#673, #637/#467 (all four sockets 6.000) — mates the measured "
     "proximal beam width 5.200 (Proximals plan beam_wall_x0/x1) with 0.80 "
     "total clearance; walls crowned r6.000 articulate the proximal "
     "r6.000 lobes flush"),
    ("elastic_slot_w", 2.2,
     "EXACT elastic-return slot width on each socket centerline: plane "
     "pairs #163/#188, #167/#260, #258/#166"),
    ("elastic_slot_end_r", 1.1,
     "EXACT slot rounded ends: z-axis cylinder faces #186/#187/#204/#257 "
     "(2*r == elastic_slot_w)"),
    ("snap_tab_w", 2.64,
     "EXACT dorsal snap-tab width over each socket: plane pairs #213/#306, "
     "#182/#183, #221/#225, #196/#198 (thumb: #178/#180)"),
    ("thumb_axis_deg", 50.0,
     "EXACT thumb clevis frame angle: every face of the tilted family has "
     "axis/normal (0.6428, 0.766, 0) = 50.000 deg from +x"),
    ("thumb_socket_w", 6.0,
     "EXACT thumb throat width: tilted plane pair #539/#540 — same 6.00 as "
     "the finger sockets (design family)"),
    ("thumb_wall_t", 5.0,
     "EXACT thumb clevis wall thickness: tilted plane pairs #331/#539 and "
     "#540/#453"),
    ("thumb_crown_r", 6.0,
     "EXACT thumb wall crowns: tilted r6.000 cylinder faces #433/#541 "
     "(outer crown #210) — same r6.000 family as the finger clevis walls; "
     "kept as measured bands: the bands here are full-width palm sections "
     "(footprint carving = future anatomical re-segmentation)"),
    ("thumb_throat_r", 7.5,
     "EXACT thumb throat floor: tilted r7.5 cylinder face #524; "
     "counterbores r2.7 #226/#319/#320 and r2.5 #184"),
    ("wrist_wall_t", 5.0,
     "EXACT wrist support wall thickness: x-normal plane pairs #469/#470 "
     "(left, x -38.17..-33.17, carries ear #534) and #438/#92 (right, "
     "x 18.3..23.2, carries ear #535)"),
    ("thumb_outer_r", 7.0,
     "EXACT thumb clevis outer round: tilted r7.0 cylinder face #300 "
     "(same 50.0 deg frame)"),
    ("deck_floor_z", 4.62,
     "EXACT bottom-grid ceiling plane #829 (area 3447, normal -z) — "
     "geometrically realized by the band z-boundaries (horizontal planes "
     "are exact in the y-band representation)"),
    ("cavity_floor_z", 6.62,
     "EXACT cavity floor plane #828 (area 2225, normal +z) — realized by "
     "the band z-boundaries"),
    ("tendon_tube_r", 1.15,
     "EXACT tendon-tube channel radius: the r1.15 cylinder family "
     "#4/#23/#25/#34/#36/#40/#45/#49/#60/#61/#72/#74/#96/#102/#104/#105/"
     "#108/#111/#123/#124/#129/#137/#141/#142/#143/#525 — the curved "
     "tendon paths cut by the tendon_tubes module"),
]


def main():
    plan = json.loads((OUT / "plan.json").read_text())
    body = plan["bodies"][0]
    params = body.setdefault("params", [])
    have = {p["name"] for p in params}
    added = 0
    for name, value, source in MATING_PARAMS:
        if name in have:
            continue
        params.append({"name": name, "value": value, "source": source})
        added += 1
    note = ("knuckle-block mating architecture claimed as named reference "
            "params (sockets 6.00 mating the 5.20 proximal beam, elastic "
            "slots 2.2/r1.1, snap tabs 2.64, thumb clevis at exactly 50.0 "
            "deg with the same 6.00 socket family) — faces cited per param; "
            "thumb bands kept (full-width sections, see "
            "knuckleblock_palm.py)")
    if "knuckle-block mating architecture" not in body.get("notes", ""):
        body["notes"] = body.get("notes", "") + " | " + note
    (OUT / "plan.json").write_text(json.dumps(plan, indent=1))
    print(f"knuckleblock: {added} params de acoplamento reivindicados")


if __name__ == "__main__":
    main()
