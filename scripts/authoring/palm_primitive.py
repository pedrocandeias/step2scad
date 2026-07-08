"""Palm_left — COARSE BIG-PRIMITIVE reconstruction (author's directive:
prefer smooth FORM over IoU fidelity; use only large primitives).

The palm is replicated from a handful of big measured primitives, one module
per component so each can be refined independently:

    palm_parts/floor.py    flat perforated palmar plate (real outline + vents)
    palm_parts/fingers.py  4 finger clevis forks on the angled knuckle line
    palm_parts/wrist.py    2 gauntlet walls + r8 ears + hinge bores
    palm_parts/thumb.py    tilted keyhole clevis (+X)
    (dorsal arch VAULT lives here, behind SHOW_VAULT — refined last)

Every dimension is measured (exact B-rep faces / ref tessellation), never
guessed. Emitted as slug Palm_left_primitive so the committed loft palm
(0.9641) is untouched.

Run: python3 scripts/authoring/palm_primitive.py
"""
import json
import sys
from pathlib import Path

sys.path.insert(0, "scripts/authoring")
from palm_parts import common as C
from palm_parts import fingers, floor, thumb, wrist

SHOW_VAULT = False   # hide the dorsal arch for now (refine the rest first)

R, Z_BOT, Z_DECK, Z_APEX, box, cyl = C.R, C.Z_BOT, C.Z_DECK, C.Z_APEX, C.box, C.cyl

add, cut = [], []
for part in (floor, fingers, wrist, thumb):
    a, c = part.build()
    add += a
    cut += c

# --- dorsal body = HOLLOW ARCH VAULT (measured; refined last, hidden for now)
X_C, Z_BASE = -3.0, Z_DECK
VX_OUT, VZ_OUT = 37.0, 28.0
VX_IN, VZ_IN = 32.0, 23.0
Y0, Y1 = -34.0, 30.0
if SHOW_VAULT:
    vault_outer = {"transform": {"translate": [X_C, 0, Z_BASE],
                                 "scale": [VX_OUT, 1, VZ_OUT]}, "name": "vault_outer",
        "child": cyl("vault_o", (0, Y0, 0), (0, Y1, 0), 1.0, "outer arch")}
    vault_inner = {"transform": {"translate": [X_C, 0, Z_BASE],
                                 "scale": [VX_IN, 1, VZ_IN]}, "name": "vault_inner",
        "child": cyl("vault_i", (0, Y0 + 3, 0), (0, Y1 - 3, 0), 1.0,
                     "inner cavity: 5mm wall, inner ceiling z29.1")}
    add.append({"op": "difference", "children": [
        {"op": "intersection", "children": [vault_outer,
            box("vault_clip", (-42, Y0, Z_DECK), (84, Y1 - Y0, 40),
                "keep the arch above the deck (open underneath)")]},
        vault_inner]})

# --- assemble: union(add) - cut, clipped to the measured envelope ---
solid = {"op": "difference", "children": [{"op": "union", "children": add}] + cut}
solid = {"op": "intersection", "children": [solid,
    box("envelope", (-42, -48, Z_BOT), (84, 93, Z_APEX + 6 - Z_BOT),
        "envelope: clip to measured bbox (flat bottom at z4.62)")]}

params = [
    {"name": "z_bot", "value": Z_BOT, "source": "exact bottom plane #829"},
    {"name": "z_deck", "value": Z_DECK, "source": "exact deck plane #828"},
    {"name": "z_apex", "value": Z_APEX, "source": "measured dome apex"},
]
plan = {"version": 1, "source": "models/phoenix_components/Palm_left.step",
        "bodies": [{"body_id": 0, "strategy": "csg", "params": params,
                    "notes": "COARSE big-primitive reconstruction (smooth form "
                    "over IoU): per-component modules in palm_parts/. Vault "
                    f"{'shown' if SHOW_VAULT else 'HIDDEN'}.",
                    "csg": solid}]}
(C.OUT / "plan_primitive.json").write_text(json.dumps(plan, indent=1))
print(f"wrote plan_primitive.json: {len(add)} add + {len(cut)} cut "
      f"(vault {'ON' if SHOW_VAULT else 'off'})")
