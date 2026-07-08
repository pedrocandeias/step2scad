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

# --- 1. base plate: the flat palmar floor (one box) ---
add.append(box("base_plate", (-38, -42, Z_BOT), (60, 78, Z_DECK - Z_BOT),
               "flat palmar floor: exact planes #829 (z4.62) / #828 (z6.62)"))

# --- 2+3. dorsal body = HOLLOW ARCH VAULT (measured, not a solid dome) -------
# The palm is an arched shell running along Y, ~5mm wall, open underneath.
# Crown section (y=0): floor z6.6, INNER ceiling z29.1, OUTER top z34.1.
# Modelled as an outer scaled Y-cylinder (ellipse XZ arch) minus an inner one.
X_C, Z_BASE = -8.0, Z_DECK           # arch centre x (leaves +X for the thumb)
VX_OUT, VZ_OUT = 32.0, 27.6          # outer half-width / height -> top z34.2
VX_IN,  VZ_IN  = 27.0, 22.5          # inner (5mm wall at crown & sides)
Y0, Y1 = -34.0, 30.0                 # central body only; fingers/wrist project
vault_outer = {"transform": {"translate": [X_C, 0, Z_BASE],
                             "scale": [VX_OUT, 1, VZ_OUT]}, "name": "vault_outer",
    "child": cyl("vault_o", (0, Y0, 0), (0, Y1, 0), 1.0,
                 "outer arch (esfera espalmada em Y): ellipse XZ, top z34.2")}
vault_inner = {"transform": {"translate": [X_C, 0, Z_BASE],
                             "scale": [VX_IN, 1, VZ_IN]}, "name": "vault_inner",
    "child": cyl("vault_i", (0, Y0 + 3, 0), (0, Y1 - 3, 0), 1.0,
                 "inner cavity: 5mm wall, inner ceiling z29.1 (measured)")}
# the arch shell = outer minus inner, kept above the deck (open bottom)
add.append({"op": "difference", "children": [
    {"op": "intersection", "children": [vault_outer,
        box("vault_clip", (-42, Y0, Z_DECK), (84, Y1 - Y0, 40),
            "keep the arch above the deck (open underneath)")]},
    vault_inner]})

# --- 4. finger clevises (+Y): 4 projecting forks (knuckle crown + neck + slot)
# Each finger = an x-axis r6 rounded knuckle crown at the +Y edge, a neck box
# tying it back to the body, a central slot splitting it into a fork, and the
# r2.5 pin bore. Projects forward from the vault (measured knuckle y39, z10.6).
FINGERS = [(-21.0, "pinky"), (-7.9, "ring"), (5.5, "middle"), (16.2, "index")]
KN_Y, KN_Z, KN_R, KN_HW = 40.0, 10.62, 6.0, 4.5   # knuckle y/z/radius/half-width X
for cx, nm in FINGERS:
    clevis = {"op": "difference", "children": [
        {"op": "union", "children": [
            box(f"neck_{nm}", (cx - KN_HW, 26.0, Z_DECK), (2 * KN_HW, KN_Y - 26.0, KN_Z + KN_R - Z_DECK),
                f"{nm} finger neck: ties the knuckle back into the body"),
            cyl(f"knuckle_{nm}", (cx - KN_HW, KN_Y, KN_Z), (cx + KN_HW, KN_Y, KN_Z), KN_R,
                f"{nm} knuckle crown: exact r6.000 x-axis (faces #277/#337/#350...)"),
        ]},
        box(f"slot_{nm}", (cx - 1.2, 30.0, Z_DECK - 1), (2.4, 18.0, KN_R + 3),
            f"{nm} fork slot (splits the knuckle into two prongs)"),
        cyl(f"bore_{nm}", (cx - KN_HW - 1, KN_Y, KN_Z), (cx + KN_HW + 1, KN_Y, KN_Z), 2.5,
            f"{nm} pin bore: exact r2.5 (faces #228/#234/#286...)"),
    ]}
    add.append(clevis)

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
TH_C = [29.0, -8.0, 4.62]         # thumb base centre (measured region)
TH_ANG = 50.0                     # tilt (oblique faces normal 0.64,0.77)
# thumb clevis: two prong boxes (the fork tines), a rounded top bridging them
# (half-cylinder = the keyhole crown), pivot bore through the crown, U-slot
# between the prongs. Built in a local frame, then tilted/placed.
PW, PGAP, PH, PL = 3.0, 3.4, 16.0, 15.0   # prong width, slot gap, height, length
crown_z, crown_r = PH, (PGAP / 2 + PW)     # crown radius spans both prongs
thumb = {"op": "difference", "children": [
    {"op": "union", "children": [
        box("thumb_prong_a", (-PL/2, PGAP/2, 0), (PL, PW, PH),
            "thumb fork prong A (parallel box)"),
        box("thumb_prong_b", (-PL/2, -PGAP/2 - PW, 0), (PL, PW, PH),
            "thumb fork prong B (parallel box)"),
        cyl("thumb_crown", (-PL/2, 0, crown_z), (PL/2, 0, crown_z), crown_r,
            "thumb keyhole crown: half-cylinder bridging the prongs"),
    ]},
    cyl("thumb_bore", (-PL/2 - 1, 0, crown_z), (PL/2 + 1, 0, crown_z), 2.7,
        "thumb pivot bore: exact r2.7 (faces #226/#319)"),
]}
add.append({"transform": {"translate": TH_C, "rotate_deg": [0, 0, TH_ANG]},
            "name": "thumb", "child": thumb})

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
    {"name": "sock_r", "value": KN_R, "source": "exact r6.000 finger knuckle crowns"},
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
