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
X_C, Z_BASE = -3.0, Z_DECK           # arch centre x (measured span -40..34)
VX_OUT, VZ_OUT = 37.0, 28.0          # wider+flatter: half-width 37, top z34.6
VX_IN,  VZ_IN  = 32.0, 23.0          # inner (5mm wall at crown & sides)
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

# --- 5. wrist (-Y): 2 gauntlet SIDE WALLS each ending in an r8 EAR + bore ---
# Side walls run along Y (measured wall planes at y-28.6): left x[-38,-33],
# right x[18,23], ~5mm thick, rising from the deck. Each caps at an r8 ear
# disc (faces #534/#535 at y-38.9 z12.6) with an r3 hinge bore (#246/#93).
EAR_Y, EAR_Z, EAR_R, EAR_W = -38.95, 12.62, 8.0, 5.0
WALL_Y0, WALL_Y1, WALL_TOP = EAR_Y, -16.0, 20.0    # wall Y span + top z
WRIST = [(-38.5, "L"), (17.5, "R")]                # wall/ear near-x per side
for x0, nm in WRIST:
    add.append(box(f"wrist_wall_{nm}", (x0, WALL_Y0, Z_DECK),
                   (EAR_W, WALL_Y1 - WALL_Y0, WALL_TOP - Z_DECK),
                   f"wrist gauntlet wall {nm}: measured side wall "
                   f"(planes #438/#92 or #469/#470) x[{x0:.0f},{x0+EAR_W:.0f}]"))
    add.append(cyl(f"ear_{nm}", (x0, EAR_Y, EAR_Z), (x0 + EAR_W, EAR_Y, EAR_Z),
                   EAR_R, f"wrist ear {nm}: exact r8.000 disc "
                   "(faces #534/#535) at y-38.95 z12.62"))
    cut.append(cyl(f"ear_bore_{nm}", (x0 - 2, EAR_Y, EAR_Z),
                   (x0 + EAR_W + 2, EAR_Y, EAR_Z), 3.0,
                   f"wrist ear {nm} pin bore: exact r3.0 (faces #93/#246)"))

# --- 6. thumb (+X): two parallel boxes + a bored top box, in a tilted frame ---
# thumb axis tilted ≈50° (oblique planes normal (0.64,0.77)); bbox x[24,42]
# y[-20,5] z[4.6,24.6]. Modelled in a rotate-Z frame about its base centre.
# Measured clevis crown r7.5 (#524) centred (31,-6,z10.6) on the tilted pin
# axis (0.64,0.77,0)=50°; pivot bore r2.7 (#226). Built in a local frame
# (pin along local X) then rotated 50° about Z and placed at the deck.
TH_C = [31.0, -6.0, Z_DECK]       # crown centre xy, base at the deck
TH_ANG = 50.0                     # tilt (oblique faces normal 0.64,0.77)
CR_R, PIN_Z = 7.5, 10.62 - Z_DECK  # crown radius; pin height above the deck
PW, PGAP, PL = 3.5, 4.0, 15.0      # prong width, slot gap, length along pin
thumb = {"op": "difference", "children": [
    {"op": "union", "children": [
        # two prongs rising from the deck to the pin, flanking the fork slot
        box("thumb_prong_a", (-PL/2, PGAP/2, 0), (PL, PW, PIN_Z + CR_R),
            "thumb fork prong A"),
        box("thumb_prong_b", (-PL/2, -PGAP/2 - PW, 0), (PL, PW, PIN_Z + CR_R),
            "thumb fork prong B"),
        # rounded keyhole crown (r7.5) around the pin axis, bridging the prongs
        cyl("thumb_crown", (-PL/2, 0, PIN_Z), (PL/2, 0, PIN_Z), CR_R,
            "thumb clevis crown: exact r7.5 (face #524) at z10.6"),
    ]},
    box("thumb_slot", (-PL/2 - 1, -PGAP/2, 0), (PL + 2, PGAP, PIN_Z + 1),
        "thumb fork slot (U-gap between the prongs, open to the deck)"),
    cyl("thumb_bore", (-PL/2 - 1, 0, PIN_Z), (PL/2 + 1, 0, PIN_Z), 2.7,
        "thumb pivot bore: exact r2.7 (faces #226/#184)"),
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
