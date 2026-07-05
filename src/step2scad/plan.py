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

SEMANTIC PLANS (v2 additions — the human-readable, truly parametric form):

    A body may carry named parameters (each a measured value with provenance):
        "params": [{"name": "slot_w", "value": 4.0,
                    "source": "exact r2.0 end-cap cylinder faces ..."}, ...]

    Any numeric field of a primitive (and any call argument) may instead be a
    STRING EXPRESSION over parameter names — e.g. "slot_w/2", "z_top - z_base"
    — using + - * / ( ) and numbers only. Validation resolves every expression
    against the params (and, inside a module, its args); the emitter writes it
    verbatim, so the emitted OpenSCAD stays symbolic and editable.

    A body may define parametric modules and instantiate them:
        "modules": {"strap_slot": {"args": ["cx", "cy", "ang"],
                                   "tree": <node using args + params>}}
        ... and, anywhere a node is expected:
        {"call": "strap_slot", "name": "slot1",
         "args": {"cx": "slot1_cx", "cy": "slot1_cy", "ang": "slot_ang"}}

    v3 additions (style reference: the hand-tuned arm-guard-v13 template):

    - Derived params: {"name": "fillet_rc", "expr": "mount_r - fillet_r",
      "source": ...} — emitted symbolically, resolved for validation.

    - Transform nodes, anywhere a node is expected:
        {"transform": {"translate": [e,e,e], "rotate_deg": [e,e,e],
                       "mirror": [1,0,0]},  # each optional, applied in order
         "name": "slotL", "child": <node>}

    - Shared 2D profiles + 2D ops: the body declares measured outlines ONCE,
        "profiles": {"outer": [[x,y], ...], ...}
      and an extrude may replace "profile" with a 2D expression tree:
        "profile2d": {"ref": "outer"}
                   | {"op2d": "offset", "delta": expr, "child": <2d>}
                   | {"op2d": "union"|"difference"|"intersection",
                      "children": [<2d>, ...]}
                   | {"rect": [x0, y0, x1, y1]}      # halfplane-style clip
                   | {"poly": [[x, y], ...]}          # small literal clip
      so derived zones (wings = outline ∩ half-plane, lips = inset outline)
      reuse one measured polygon instead of duplicating it per layer.
"""

from __future__ import annotations

import ast
import json
from pathlib import Path

STRATEGIES = ("csg", "instance_of", "rotate_extrude", "linear_extrude", "freeform")
OPS = ("union", "difference", "intersection", "hull")
PRIMS = ("box", "cylinder", "sphere", "extrude", "sweep", "offset_sweep")

# sweep height laws: h(s) along the sweep axis (v13 rib-transition idiom).
# Fitted to measured band boundaries; the fit residual must be cited in
# `source` (measure first, claim after).
SWEEP_LAWS = ("arc", "linear")

_EXPR_NODES = (ast.Expression, ast.BinOp, ast.UnaryOp, ast.Constant, ast.Name,
               ast.Load, ast.Add, ast.Sub, ast.Mult, ast.Div, ast.USub, ast.UAdd)


def eval_expr(expr, scope: dict[str, float]) -> float:
    """Safely evaluate a plan expression (numbers, params, + - * / parens)."""
    if isinstance(expr, (int, float)):
        return float(expr)
    tree = ast.parse(str(expr), mode="eval")
    for node in ast.walk(tree):
        if not isinstance(node, _EXPR_NODES):
            raise PlanError(f"expression {expr!r}: disallowed syntax "
                            f"({type(node).__name__})")
        if isinstance(node, ast.Name) and node.id not in scope:
            raise PlanError(f"expression {expr!r}: unknown parameter {node.id!r}")
    return float(eval(compile(tree, "<plan>", "eval"), {"__builtins__": {}}, scope))


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


def _is_num_or_expr(v) -> bool:
    return isinstance(v, (int, float, str))


def _is_vec_e(v, n: int = 3) -> bool:
    """Vector whose components may be numbers or parameter expressions."""
    return (isinstance(v, (list, tuple)) and len(v) == n
            and all(_is_num_or_expr(x) for x in v))


def _resolve(v, scope, where, what) -> float:
    try:
        return eval_expr(v, scope)
    except PlanError as exc:
        raise PlanError(f"{where}: {what}: {exc}") from exc


def _resolve_vec(v, scope, where, what) -> list[float]:
    return [_resolve(x, scope, where, f"{what}[{i}]") for i, x in enumerate(v)]


def _validate_2d(node, where: str, scope: dict, profiles: set) -> None:
    _require(isinstance(node, dict), where, "2D node must be an object")
    if "ref" in node:
        _require(node["ref"] in profiles, where,
                 f"unknown profile {node['ref']!r} (declared: {sorted(profiles)})")
        return
    if "poly" in node:
        _require(isinstance(node["poly"], list) and len(node["poly"]) >= 3
                 and all(_is_vec_e(p, 2) for p in node["poly"]), where,
                 "'poly' needs >= 3 [x,y] points")
        for i, p in enumerate(node["poly"]):
            _resolve_vec(p, scope, where, f"poly[{i}]")
        return
    if "rect" in node:
        _require(_is_vec_e(node["rect"], 4), where, "'rect' is [x0,y0,x1,y1]")
        _resolve_vec(node["rect"], scope, where, "rect")
        return
    op = node.get("op2d")
    if op == "offset":
        _require(_is_num_or_expr(node.get("delta")), where, "offset needs 'delta'")
        _resolve(node["delta"], scope, where, "delta")
        _validate_2d(node.get("child"), f"{where}.child", scope, profiles)
        return
    _require(op in ("union", "difference", "intersection"), where,
             f"unknown 2D node (keys {sorted(node)})")
    kids = node.get("children")
    _require(isinstance(kids, list) and kids, where, "op2d needs 'children'")
    for i, kid in enumerate(kids):
        _validate_2d(kid, f"{where}.children[{i}]", scope, profiles)


def _validate_node(node: dict, where: str, names: set[str],
                   scope: dict | None = None, modules: dict | None = None,
                   strict: bool = True, profiles: set | None = None) -> None:
    scope = scope or {}
    modules = modules or {}
    profiles = profiles or set()
    if isinstance(node, dict) and "transform" in node:
        t = node["transform"]
        _require(isinstance(t, dict) and t, where, "'transform' must be a "
                 "non-empty object (translate/rotate_deg/mirror)")
        for key in t:
            _require(key in ("translate", "rotate_deg", "mirror"), where,
                     f"unknown transform key {key!r}")
            _require(_is_vec_e(t[key]), where, f"transform {key} must be [x,y,z]")
            _resolve_vec(t[key], scope, where, key)
        _validate_node(node.get("child"), f"{where}.child", names, scope,
                       modules, strict, profiles)
        return
    _require(isinstance(node, dict), where, "node must be an object")
    if "call" in node:
        mname = node["call"]
        _require(mname in modules, where, f"unknown module {mname!r}")
        _require(bool(node.get("name")), where, "module call needs a 'name'")
        _require(node["name"] not in names, where,
                 f"duplicate call name {node['name']!r}")
        names.add(node["name"])
        formal = modules[mname].get("args", [])
        got = node.get("args", {})
        _require(set(got) == set(formal), where,
                 f"call args {sorted(got)} != module args {sorted(formal)}")
        for k, v in got.items():
            _resolve(v, scope, where, f"arg {k!r}")
        return
    if "op" in node:
        _require(node["op"] in OPS, where, f"unknown op {node['op']!r} (want {OPS})")
        kids = node.get("children")
        _require(isinstance(kids, list) and len(kids) >= 1, where,
                 "op node needs a non-empty 'children' list")
        if node["op"] == "difference":
            _require(len(kids) >= 2, where, "difference needs >= 2 children")
        for i, kid in enumerate(kids):
            _validate_node(kid, f"{where}.children[{i}]", names, scope, modules,
                           strict, profiles)
        return

    prim = node.get("prim")
    _require(prim in PRIMS, where, f"unknown prim {prim!r} (want {PRIMS})")
    _require(bool(node.get("name")), where, "primitive needs a 'name'")
    _require(bool(node.get("source")), where,
             "primitive needs a 'source' provenance string (rule 2)")
    name = node["name"]
    _require(name not in names, where, f"duplicate primitive name {name!r}")
    names.add(name)

    # `strict=False` inside module bodies: expressions are resolved against
    # dummy arg bindings there, so only name-resolution is checked, not
    # magnitudes (those depend on the actual call arguments).
    def num(v, what):
        return _resolve(v, scope, where, what)

    if prim == "box":
        _require(_is_vec_e(node.get("size")), where, "box needs 'size' [dx,dy,dz]")
        sz = _resolve_vec(node["size"], scope, where, "size")
        _require(not strict or all(s > 0 for s in sz), where, "box size must be > 0")
        has_min, has_center = "min" in node, "center" in node
        _require(has_min != has_center, where, "box needs exactly one of 'min'/'center'")
        _require(_is_vec_e(node["min" if has_min else "center"]), where,
                 "box 'min'/'center' must be [x,y,z]")
        _resolve_vec(node["min" if has_min else "center"], scope, where, "position")
        if "rotate_deg" in node:
            _require(has_center, where, "rotated box must be center-based")
            _require(_is_vec_e(node["rotate_deg"]), where, "'rotate_deg' must be [rx,ry,rz]")
            _resolve_vec(node["rotate_deg"], scope, where, "rotate_deg")
    elif prim == "cylinder":
        _require(_is_vec_e(node.get("p0")) and _is_vec_e(node.get("p1")), where,
                 "cylinder needs 'p0' and 'p1' [x,y,z]")
        p0 = _resolve_vec(node["p0"], scope, where, "p0")
        p1 = _resolve_vec(node["p1"], scope, where, "p1")
        _require(not strict or p0 != p1, where, "cylinder p0 == p1 (zero length)")
        _require(_is_num_or_expr(node.get("r")), where, "cylinder needs 'r'")
        _require(not strict or num(node["r"], "r") > 0, where, "cylinder 'r' must be > 0")
        if "r2" in node:
            _require(_is_num_or_expr(node["r2"]) and num(node["r2"], "r2") >= 0,
                     where, "'r2' must be >= 0")
    elif prim == "sphere":
        _require(_is_vec_e(node.get("center")), where, "sphere needs 'center' [x,y,z]")
        _resolve_vec(node["center"], scope, where, "center")
        _require(_is_num_or_expr(node.get("r")), where, "sphere needs 'r'")
        _require(not strict or num(node["r"], "r") > 0, where, "sphere 'r' must be > 0")
    elif prim == "sweep":
        # rectangular-footprint slab sweep whose TOP follows a height law
        # h(s): arc h = zc + sqrt(R² − (s−sc)²) or linear h = m·s + b,
        # clamped to h_max, slabs skipped where h <= z0. Compose with
        # intersections/unions for stadium footprints etc.
        _require(node.get("axis") in ("x", "y"), where, "sweep 'axis': 'x'|'y'")
        for f in ("u0", "u1", "s0", "s1", "z0", "h_max"):
            _require(_is_num_or_expr(node.get(f)), where, f"sweep needs '{f}'")
            num(node[f], f)
        _require(not strict or num(node["s1"], "s1") > num(node["s0"], "s0"),
                 where, "sweep needs s1 > s0")
        _require(isinstance(node.get("steps"), int) and node["steps"] > 0,
                 where, "sweep needs integer 'steps' > 0")
        law = node.get("law")
        _require(isinstance(law, dict) and law.get("kind") in SWEEP_LAWS,
                 where, f"sweep 'law.kind' must be one of {SWEEP_LAWS}")
        need = ("sc", "zc", "R") if law["kind"] == "arc" else ("m", "b")
        for f in need:
            _require(_is_num_or_expr(law.get(f)), where, f"law needs '{f}'")
            num(law[f], f"law.{f}")
    elif prim == "offset_sweep":
        # edge-treatment sweep: stacked slabs of a 2D shape offset by a law
        # delta(z) — "linear" {d0, d1} = chamfer/ramp; "round" {r} = quarter
        # roundover ("edge": "bottom" | "top"). Laws are fitted to measured
        # band insets; cite the residual in `source`.
        _require("profile2d" in node, where, "offset_sweep needs 'profile2d'")
        _validate_2d(node["profile2d"], f"{where}.profile2d", scope, profiles)
        for f in ("z0", "z1"):
            _require(_is_num_or_expr(node.get(f)), where, f"offset_sweep needs '{f}'")
            num(node[f], f)
        _require(not strict or num(node["z1"], "z1") > num(node["z0"], "z0"),
                 where, "offset_sweep needs z1 > z0")
        _require(isinstance(node.get("steps"), int) and node["steps"] > 0,
                 where, "offset_sweep needs integer 'steps' > 0")
        law = node.get("law")
        _require(isinstance(law, dict) and law.get("kind") in ("linear", "round"),
                 where, "offset_sweep 'law.kind' must be 'linear' or 'round'")
        if law["kind"] == "linear":
            for f in ("d0", "d1"):
                _require(_is_num_or_expr(law.get(f)), where, f"law needs '{f}'")
                num(law[f], f"law.{f}")
        else:
            _require(_is_num_or_expr(law.get("r")), where, "round law needs 'r'")
            _require(not strict or num(law["r"], "r") > 0, where, "'r' must be > 0")
            _require(law.get("edge", "bottom") in ("bottom", "top"), where,
                     "round law 'edge' must be 'bottom' or 'top'")
    elif prim == "extrude":
        if "profile2d" in node:
            _require("profile" not in node, where,
                     "extrude takes 'profile' OR 'profile2d', not both")
            _validate_2d(node["profile2d"], f"{where}.profile2d", scope, profiles)
        else:
            prof = node.get("profile")
            _require(isinstance(prof, list) and len(prof) >= 3
                     and all(_is_vec(p, 2) for p in prof), where,
                     "extrude needs 'profile' = [[x,y], ...] with >= 3 numeric points")
        _require(_is_num_or_expr(node.get("z0")) and _is_num_or_expr(node.get("z1")),
                 where, "extrude needs z0/z1")
        _require(not strict or num(node["z1"], "z1") > num(node["z0"], "z0"),
                 where, "extrude needs z1 > z0")
        _require(node.get("axis", "z") in ("x", "y", "z"), where,
                 "extrude 'axis' must be 'x', 'y' or 'z'")


def _validate_params(b: dict, where: str) -> dict[str, float]:
    scope: dict[str, float] = {}
    for j, p in enumerate(b.get("params", [])):
        w = f"{where}.params[{j}]"
        _require(isinstance(p, dict) and bool(p.get("name")), w, "param needs 'name'")
        _require(p["name"] not in scope, w, f"duplicate param {p['name']!r}")
        _require(bool(p.get("source")), w,
                 "param needs a 'source' provenance string (rule 2)")
        if "expr" in p:
            _require("value" not in p, w, "param takes 'value' OR 'expr'")
            scope[p["name"]] = _resolve(p["expr"], scope, w, "expr")
        else:
            _require(isinstance(p.get("value"), (int, float)), w,
                     "param 'value' must be numeric (measured)")
            scope[p["name"]] = float(p["value"])
    return scope


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
            scope = _validate_params(b, where)
            profiles = set()
            for pname, pts in b.get("profiles", {}).items():
                w = f"{where}.profiles[{pname}]"
                _require(isinstance(pts, list) and len(pts) >= 3
                         and all(_is_vec(q, 2) for q in pts), w,
                         "profile needs >= 3 numeric [x,y] points")
                profiles.add(pname)
            modules = b.get("modules", {})
            for mname, mdef in modules.items():
                w = f"{where}.modules[{mname}]"
                args = mdef.get("args", [])
                _require(isinstance(args, list)
                         and all(isinstance(a, str) for a in args), w,
                         "module needs an 'args' list of names")
                _require("tree" in mdef, w, "module needs a 'tree' node")
                mscope = dict(scope, **{a: 1.0 for a in args})  # dummy bindings
                _validate_node(mdef["tree"], f"{w}.tree", set(), mscope,
                               modules, strict=False, profiles=profiles)
            _validate_node(b["csg"], f"{where}.csg", set(), scope, modules,
                           profiles=profiles)
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
