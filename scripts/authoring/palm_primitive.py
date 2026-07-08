"""Palm_left — COARSE BIG-PRIMITIVE reconstruction (author's directive:
prefer smooth FORM over IoU fidelity; use only large primitives).

Not a band/loft model: the palm is replicated with a handful of big shapes —
a base plate + body box, a flattened-sphere dorsal dome, tube finger sockets,
disc wrist ears, and a tilted thumb block (two parallel boxes + a bored top).
Every dimension is measured (features.json exact faces + ref bbox), never
guessed. Emitted as a SEPARATE variant (slug Palm_left_primitive) so the
committed loft palm (0.9641) is untouched.

Run: python3 scripts/authoring/palm_primitive.py
"""
import json
from pathlib import Path

OUT = Path("output/Palm_left")
R = lambda x: round(float(x), 3)

# ---- measured anchors (from features.json exact faces + ref tessellation) ----
Z_BOT   = 4.62      # exact bottom plane #829 (flat underside)
Z_DECK  = 6.62      # exact deck plane #828 (top of the palmar plate, ~2mm)
Z_APEX  = 29.3      # measured dome apex (broad flattened cap, centre xy≈(2,4.5))

box = lambda name, mn, sz, src: {
    "prim": "box", "name": name, "min": [R(mn[0]), R(mn[1]), R(mn[2])],
    "size": [R(sz[0]), R(sz[1]), R(sz[2])], "source": src}
cyl = lambda name, p0, p1, r, src: {
    "prim": "cylinder", "name": name, "p0": [R(p0[0]), R(p0[1]), R(p0[2])],
    "p1": [R(p1[0]), R(p1[1]), R(p1[2])], "r": R(r), "source": src}

# =============================================================== SOLID
add = []   # unioned material
cut = []   # subtracted holes

# --- 1. base plate: the flat bottom the user wants clean (one box, palm-sized)
add.append(box("base_plate", (-38, -42, Z_BOT), (60, 78, Z_DECK - Z_BOT),
               "flat palmar floor: exact planes #829 (z4.62) / #828 (z6.62); "
               "palm-proper footprint (not the full bbox)"))

# --- 2. body block: the main palm mass (a parallelepiped) ---
add.append(box("body_block", (-36, -40, Z_DECK), (54, 72, 10.0),
               "main palm body — coarse box; dorsal hump added by the dome"))

# --- 3. dorsal dome: a FLATTENED SPHERE (esfera espalmada) capping the top ---
# broad low cap covering the palm footprint, springing from the body top.
add.append({"transform": {"translate": [-6.0, -3.0, 6.0],
                          "scale": [34.0, 40.0, 23.3]},
            "name": "dome",
            "child": {"prim": "sphere", "name": "dome_unit",
                      "center": [0, 0, 0], "r": 1.0,
                      "source": "flattened-sphere dorsal dome (esfera "
                      "espalmada): apex z≈29.3, broad low cap over the palm"}})

# --- 4. finger sockets (+Y knuckle): 4 tubes (x-axis r6) at the finger x's ---
FINGERS = [(-21.0, "pinky"), (-7.9, "ring"), (5.5, "middle"), (16.2, "index")]
SOCK_Y, SOCK_Z, SOCK_R, SOCK_HW = 39.05, 10.62, 6.0, 8.0
for cx, nm in FINGERS:
    add.append(cyl(f"sock_{nm}", (cx - SOCK_HW, SOCK_Y, SOCK_Z),
                   (cx + SOCK_HW, SOCK_Y, SOCK_Z), SOCK_R,
                   f"{nm} finger socket: exact r6.000 x-axis clevis tube "
                   "(faces #277/#337/#350...) at y39.05 z10.62"))
    cut.append(cyl(f"sock_bore_{nm}", (cx - SOCK_HW - 1, SOCK_Y, SOCK_Z),
                   (cx + SOCK_HW + 1, SOCK_Y, SOCK_Z), 2.5,
                   f"{nm} pin bore: exact r2.5 (faces #228/#234/#286...)"))

# --- 5. wrist ears (-Y): 2 discs (short fat x-axis cylinders r8) + bores ---
EARS = [(-38.9, "L"), (17.5, "R")]
EAR_Y, EAR_Z, EAR_R, EAR_W = -38.95, 12.62, 8.0, 5.0
for cx, nm in EARS:
    s = 1 if cx < 0 else -1
    add.append(cyl(f"ear_{nm}", (cx, EAR_Y, EAR_Z),
                   (cx + s * EAR_W, EAR_Y, EAR_Z), EAR_R,
                   f"wrist ear {nm}: exact r8.000 disc (faces #534/#535) "
                   "at y-38.95 z12.62"))
    cut.append(cyl(f"ear_bore_{nm}", (cx - 2, EAR_Y, EAR_Z),
                   (cx + s * EAR_W + 2, EAR_Y, EAR_Z), 3.0,
                   f"wrist ear {nm} pin bore: exact r3.0 (faces #93/#246)"))

# --- 6. thumb (+X): two parallel boxes + a bored top box, in a tilted frame ---
# thumb axis tilted ≈50° (oblique planes normal (0.64,0.77)); bbox x[24,42]
# y[-20,5] z[4.6,24.6]. Modelled in a rotate-Z frame about its base centre.
TH_C = [30.0, -7.0, 4.62]         # thumb base centre (measured region)
TH_ANG = 50.0
thumb = {"op": "union", "children": [
    # two parallel side plates (walls of the thumb clevis)
    box("thumb_wall_a", (-9, -3.5, 0), (18, 3.0, 18),
        "thumb clevis wall A — parallel box"),
    box("thumb_wall_b", (-9, 3.5 - 3.0, 0), (18, 3.0, 18),
        "thumb clevis wall B — parallel box"),
    # top box bridging the two walls, with the pivot bore
    box("thumb_top", (-9, -6.5, 14), (18, 13, 8),
        "thumb top box bridging the walls (bored below)"),
]}
thumb_bored = {"op": "difference", "children": [thumb,
    cyl("thumb_bore", (-2, 0, 18), (16, 0, 18), 2.7,
        "thumb pivot bore: exact r2.7 (faces #226/#319)")]}
add.append({"transform": {"translate": TH_C, "rotate_deg": [0, 0, TH_ANG]},
            "name": "thumb", "child": thumb_bored})

# --- 7. clip the whole solid to the true height (flat-bottom, flat dome trim)
solid = {"op": "difference", "children": [{"op": "union", "children": add}] + cut}
# trim below the plate and above the apex so stray primitive bulk is clean
solid = {"op": "intersection", "children": [solid,
    box("envelope", (-42, -48, Z_BOT), (84, 93, Z_APEX + 6 - Z_BOT),
        "envelope: clip to measured bbox (flat bottom at z4.62)")]}

# named editable anchors (a real parameter block at the top of the .scad)
params = [
    {"name": "z_bot", "value": Z_BOT, "source": "exact bottom plane #829 (flat underside)"},
    {"name": "z_deck", "value": Z_DECK, "source": "exact deck plane #828 (palmar plate top)"},
    {"name": "z_apex", "value": Z_APEX, "source": "measured dome apex (broad cap)"},
    {"name": "sock_r", "value": SOCK_R, "source": "exact r6.000 finger-socket tubes"},
    {"name": "ear_r", "value": EAR_R, "source": "exact r8.000 wrist-ear discs"},
    {"name": "thumb_ang", "value": TH_ANG, "source": "thumb tilt (oblique faces normal 0.64,0.77 ≈ 50°)"},
]
plan = {"version": 1, "source": "models/phoenix_components/Palm_left.step",
        "bodies": [{"body_id": 0, "strategy": "csg", "params": params,
                    "notes": "COARSE big-primitive reconstruction (author's "
                    "directive: smooth form over IoU). Base plate + body box + "
                    "flattened-sphere dome + tube sockets + disc ears + tilted "
                    "thumb block. All dims measured; expect lower IoU by design.",
                    "csg": solid}]}
(OUT / "plan_primitive.json").write_text(json.dumps(plan, indent=1))
print(f"wrote {OUT/'plan_primitive.json'}: "
      f"{len(add)} add + {len(cut)} cut primitives")
