"""PLAN schema — the explicit, measured reconstruction plan the agent authors.

Rule 7 split: the AGENT decides strategy (which primitives, which booleans,
which dims — every number measured from the B-rep via features.json / the
report digest / the probe) and writes it down as a plan.json; the EMIT script
(emit/csg.py) executes that plan exactly, with zero judgment of its own.

Plan file layout:

    {
      "version": 1,
      "source": "models/....step",          # optional, informational
      "bodies": [
        {"body_id": 0, "strategy": "csg", "notes": "...", "csg": <node>},
        {"body_id": 1, "strategy": "instance_of", "of": 0,
         "translate": [dx, dy, dz]},
        {"body_id": 2, "strategy": "rotate_extrude"}   # existing revolve path
      ]
    }

<node> is either a boolean combinator over children:

    {"op": "union" | "difference" | "intersection" | "hull",
     "children": [<node>, ...]}
    (difference = children[0] minus the rest)

or a primitive. EVERY primitive carries `name` (readable variable prefix in
the emitted .scad) and `source` (provenance: which B-rep faces/measurements
the dims came from — the emitter writes it as the comment):

    {"prim": "box",  "name": "shaft", "source": "planes #0/#31 ...",
     "min": [x,y,z], "size": [dx,dy,dz]}                       # axis-aligned
    {"prim": "box",  "center": [x,y,z], "size": [dx,dy,dz],
     "rotate_deg": [rx,ry,rz], ...}                # rotated about its center
    {"prim": "cylinder", "p0": [..], "p1": [..], "r": 1.5}     # axis p0->p1
        optional "r2": frustum (r at p0 -> r2 at p1)
    {"prim": "sphere", "center": [..], "r": ..}
    {"prim": "extrude", "axis": "x"|"y"|"z", "profile": [[u,v], ...],
     "z0": .., "z1": ..}
        linear_extrude of a measured 2D section polygon along a world axis;
        z0/z1 = extent along that axis. Profile coordinates are the two
        in-plane WORLD axes in right-handed cyclic order:
            axis "x" -> profile points are (y, z)
            axis "y" -> profile points are (z, x)
            axis "z" -> profile points are (x, y)   (default)

Booleans need clean overlaps: the PLAN states any overshoot explicitly (e.g.
a subtracted bore runs z0-1 .. z1+1) — the emitter never pads on its own.
"""

from __future__ import annotations

import json
from pathlib import Path

STRATEGIES = ("csg", "instance_of", "rotate_extrude", "linear_extrude", "freeform")
OPS = ("union", "difference", "intersection", "hull")
PRIMS = ("box", "cylinder", "sphere", "extrude")


class PlanError(ValueError):
    """A plan that cannot be executed exactly as written."""


def _require(cond: bool, where: str, msg: str) -> None:
    if not cond:
        raise PlanError(f"{where}: {msg}")


def _is_vec(v, n: int = 3) -> bool:
    return (
        isinstance(v, (list, tuple))
        and len(v) == n
        and all(isinstance(x, (int, float)) for x in v)
    )


def _validate_node(node: dict, where: str, names: set[str]) -> None:
    _require(isinstance(node, dict), where, "node must be an object")
    if "op" in node:
        _require(node["op"] in OPS, where, f"unknown op {node['op']!r} (want {OPS})")
        kids = node.get("children")
        _require(isinstance(kids, list) and len(kids) >= 1, where,
                 "op node needs a non-empty 'children' list")
        if node["op"] == "difference":
            _require(len(kids) >= 2, where, "difference needs >= 2 children")
        for i, kid in enumerate(kids):
            _validate_node(kid, f"{where}.children[{i}]", names)
        return

    prim = node.get("prim")
    _require(prim in PRIMS, where, f"unknown prim {prim!r} (want {PRIMS})")
    _require(bool(node.get("name")), where, "primitive needs a 'name'")
    _require(bool(node.get("source")), where,
             "primitive needs a 'source' provenance string (rule 2)")
    name = node["name"]
    _require(name not in names, where, f"duplicate primitive name {name!r}")
    names.add(name)

    if prim == "box":
        _require(_is_vec(node.get("size")), where, "box needs 'size' [dx,dy,dz]")
        _require(all(s > 0 for s in node["size"]), where, "box size must be > 0")
        has_min, has_center = "min" in node, "center" in node
        _require(has_min != has_center, where, "box needs exactly one of 'min'/'center'")
        _require(_is_vec(node["min" if has_min else "center"]), where,
                 "box 'min'/'center' must be [x,y,z]")
        if "rotate_deg" in node:
            _require(has_center, where, "rotated box must be center-based")
            _require(_is_vec(node["rotate_deg"]), where, "'rotate_deg' must be [rx,ry,rz]")
    elif prim == "cylinder":
        _require(_is_vec(node.get("p0")) and _is_vec(node.get("p1")), where,
                 "cylinder needs 'p0' and 'p1' [x,y,z]")
        _require(node["p0"] != node["p1"], where, "cylinder p0 == p1 (zero length)")
        _require(isinstance(node.get("r"), (int, float)) and node["r"] > 0, where,
                 "cylinder needs 'r' > 0")
        if "r2" in node:
            _require(isinstance(node["r2"], (int, float)) and node["r2"] >= 0, where,
                     "'r2' must be >= 0")
    elif prim == "sphere":
        _require(_is_vec(node.get("center")), where, "sphere needs 'center' [x,y,z]")
        _require(isinstance(node.get("r"), (int, float)) and node["r"] > 0, where,
                 "sphere needs 'r' > 0")
    elif prim == "extrude":
        prof = node.get("profile")
        _require(isinstance(prof, list) and len(prof) >= 3
                 and all(_is_vec(p, 2) for p in prof), where,
                 "extrude needs 'profile' = [[x,y], ...] with >= 3 points")
        _require(isinstance(node.get("z0"), (int, float))
                 and isinstance(node.get("z1"), (int, float))
                 and node["z1"] > node["z0"], where, "extrude needs z1 > z0")
        _require(node.get("axis", "z") in ("x", "y", "z"), where,
                 "extrude 'axis' must be 'x', 'y' or 'z'")


def validate_plan(plan: dict) -> dict:
    """Validate a plan dict; returns it unchanged. Raises PlanError."""
    _require(isinstance(plan, dict), "plan", "plan must be a JSON object")
    _require(plan.get("version") == 1, "plan", "plan needs \"version\": 1")
    bodies = plan.get("bodies")
    _require(isinstance(bodies, list) and bodies, "plan", "plan needs a 'bodies' list")
    seen_ids: set[int] = set()
    for i, b in enumerate(bodies):
        where = f"bodies[{i}]"
        _require(isinstance(b.get("body_id"), int), where, "needs integer 'body_id'")
        _require(b["body_id"] not in seen_ids, where, f"duplicate body_id {b['body_id']}")
        seen_ids.add(b["body_id"])
        strat = b.get("strategy")
        _require(strat in STRATEGIES, where,
                 f"unknown strategy {strat!r} (want {STRATEGIES})")
        if strat == "csg":
            _require("csg" in b, where, "csg strategy needs a 'csg' node tree")
            _validate_node(b["csg"], f"{where}.csg", set())
        elif strat == "instance_of":
            _require(isinstance(b.get("of"), int), where, "instance_of needs 'of' body_id")
            _require(b["of"] in seen_ids, where,
                     f"'of' body {b['of']} must be defined earlier in the plan")
            _require(_is_vec(b.get("translate")), where,
                     "instance_of needs 'translate' [dx,dy,dz]")
    return plan


def load_plan(path: str | Path) -> dict:
    """Read + validate a plan.json."""
    plan = json.loads(Path(path).read_text())
    return validate_plan(plan)


def plan_bodies(plan: dict | None) -> dict[int, dict]:
    """body_id -> plan entry (empty when no plan)."""
    if not plan:
        return {}
    return {b["body_id"]: b for b in plan["bodies"]}


def apply_plan_to_classification(classification: dict, plan: dict | None) -> dict:
    """Override the heuristic strategy with the agent's plan (recorded as such).

    The heuristic result is kept in 'suggested_strategy' for audit; strategy
    selection is a STRATEGY decision and belongs to the agent (rule 7).
    """
    by_id = plan_bodies(plan)
    for c in classification["bodies"]:
        entry = by_id.get(c["body_id"])
        if entry is None:
            continue
        if c["strategy"] != entry["strategy"]:
            c["suggested_strategy"] = c["strategy"]
            c["strategy"] = entry["strategy"]
        if "axis" in entry:  # e.g. agent-supplied revolve axis
            c["axis"] = entry["axis"]
        c["reasoning"] = (
            f"agent plan ({entry.get('notes', 'no notes')}); "
            f"heuristic suggested: {c.get('suggested_strategy', c['strategy'])} — "
            + c["reasoning"]
        )
    return classification
