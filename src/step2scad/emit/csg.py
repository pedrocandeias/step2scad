"""Stage 3 emitter: CSG — executes an explicit, measured plan (see plan.py).

This emitter has NO geometric judgment. It takes the plan node tree the agent
authored (every dimension a B-rep measurement, every primitive carrying its
provenance string) and translates it 1:1 into readable OpenSCAD:

  - one named-variable block per primitive (name_min/name_size/name_r/…),
    each line commented with the plan's `source` provenance,
  - a module per body whose CSG tree mirrors the plan tree exactly.

Derived-only values (a cylinder's axis rotation, its length) are computed
from the named endpoint variables — in OpenSCAD where possible (`norm(p1 -
p0)`) so editing a variable still edits the geometry.
"""

from __future__ import annotations

import math

import numpy as np

from step2scad.emit.placeholder import _fmt, _orient_snippet

_FN = 96  # curve resolution for plan cylinders/spheres

_IND = "    "

# extrude along a world axis: local +Z -> that axis with the local XY frame
# mapping onto the two in-plane world axes in right-handed cyclic order
# (see plan.py: axis x -> profile (y,z); axis y -> (z,x); axis z -> (x,y))
_EXTRUDE_ROT = {
    "x": "rotate([90, 0, 90]) ",   # local X->world Y, local Y->world Z, local Z->world X
    "y": "rotate([0, -90, -90]) ",  # local X->world Z, local Y->world X, local Z->world Y
    "z": "",
}


def _vec(v) -> str:
    return f"[{', '.join(_fmt(float(x)) for x in v)}]"


def _emit_vars(node: dict, prefix: str, lines: list[str]) -> None:
    """Depth-first: one commented variable block per primitive."""
    if "op" in node:
        for kid in node["children"]:
            _emit_vars(kid, prefix, lines)
        return
    n = prefix + node["name"]
    src = node["source"]
    prim = node["prim"]
    if prim == "box":
        anchor = "min" if "min" in node else "center"
        lines.append(f"{n}_{anchor} = {_vec(node[anchor])};  // {src}")
        lines.append(f"{n}_size = {_vec(node['size'])};")
        if "rotate_deg" in node:
            lines.append(f"{n}_rot  = {_vec(node['rotate_deg'])};  // rotation about the box center")
    elif prim == "cylinder":
        lines.append(f"{n}_p0 = {_vec(node['p0'])};  // {src}")
        lines.append(f"{n}_p1 = {_vec(node['p1'])};")
        lines.append(f"{n}_r  = {_fmt(float(node['r']))};")
        if "r2" in node:
            lines.append(f"{n}_r2 = {_fmt(float(node['r2']))};  // frustum: r at p1")
    elif prim == "sphere":
        lines.append(f"{n}_c = {_vec(node['center'])};  // {src}")
        lines.append(f"{n}_r = {_fmt(float(node['r']))};")
    elif prim == "extrude":
        axis = node.get("axis", "z")
        uv = {"x": "(y, z)", "y": "(z, x)", "z": "(x, y)"}[axis]
        pts = ", ".join(_vec(p) for p in node["profile"])
        lines.append(f"{n}_profile = [{pts}];  // {uv} points — {src}")
        lines.append(f"{n}_z0 = {_fmt(float(node['z0']))};  // extent along {axis}")
        lines.append(f"{n}_z1 = {_fmt(float(node['z1']))};")


def _emit_node(node: dict, prefix: str, lines: list[str], depth: int, fn_var: str) -> None:
    ind = _IND * depth
    if "op" in node:
        op = node["op"]
        lines.append(f"{ind}{op}() {{")
        for kid in node["children"]:
            _emit_node(kid, prefix, lines, depth + 1, fn_var)
        lines.append(f"{ind}}}")
        return

    n = prefix + node["name"]
    prim = node["prim"]
    lines.append(f"{ind}// {node['name']}: {node['source']}")
    if prim == "box":
        if "min" in node:
            lines.append(f"{ind}translate({n}_min) cube({n}_size);")
        elif "rotate_deg" in node:
            lines.append(
                f"{ind}translate({n}_center) rotate({n}_rot) cube({n}_size, center=true);"
            )
        else:
            lines.append(f"{ind}translate({n}_center) cube({n}_size, center=true);")
    elif prim == "cylinder":
        p0 = np.asarray(node["p0"], float)
        p1 = np.asarray(node["p1"], float)
        orient = _orient_snippet(p1 - p0)  # derived from the named endpoints
        r_args = (
            f"r1={n}_r, r2={n}_r2" if "r2" in node else f"r={n}_r"
        )
        lines.append(
            f"{ind}translate({n}_p0) {orient}"
            f"cylinder(h=norm({n}_p1 - {n}_p0), {r_args}, $fn={fn_var});"
        )
    elif prim == "sphere":
        lines.append(f"{ind}translate({n}_c) sphere(r={n}_r, $fn={fn_var});")
    elif prim == "extrude":
        orient = _EXTRUDE_ROT[node.get("axis", "z")]
        lines.append(
            f"{ind}{orient}translate([0, 0, {n}_z0]) "
            f"linear_extrude({n}_z1 - {n}_z0) polygon({n}_profile);"
        )


def emit_csg_body(body: dict, plan_entry: dict, lines: list[str], prefix: str = "") -> str:
    """Emit one body from its plan node tree. Returns the module name."""
    bid = body["id"]
    node = plan_entry["csg"]
    lines.append(f"// ---- body {bid} (strategy: csg — agent plan) ----")
    if plan_entry.get("notes"):
        lines.append(f"// plan: {plan_entry['notes']}")
    _emit_vars(node, prefix, lines)
    fn_var = f"{prefix}fn"
    lines.append(f"{fn_var} = {_FN};  // curve resolution")
    lines.append("")
    lines.append(f"module body_{bid}() {{")
    _emit_node(node, prefix, lines, 1, fn_var)
    lines.append("}")
    return f"body_{bid}"


def emit_instance_body(body: dict, plan_entry: dict, lines: list[str]) -> str:
    """Emit a body that is a translated instance of an earlier body's module."""
    bid = body["id"]
    of = plan_entry["of"]
    t = plan_entry["translate"]
    lines.append(f"// ---- body {bid} (strategy: instance_of body {of} — agent plan) ----")
    lines.append(
        f"b{bid}_offset = {_vec(t)};  // "
        + plan_entry.get(
            "source", f"measured centroid/bbox offset of body {bid} vs body {of}"
        )
    )
    lines.append("")
    lines.append(f"module body_{bid}() {{")
    lines.append(f"{_IND}translate(b{bid}_offset) body_{of}();")
    lines.append("}")
    return f"body_{bid}"
