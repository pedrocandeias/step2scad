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
    if plan_entry.get("params") or plan_entry.get("modules"):
        return _emit_semantic_body(body, plan_entry, lines, prefix)
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


# --------------------------------------------------------------------------
# SEMANTIC MODE — plans with named params / parametric modules emit in the
# human-editable style: a parameter block, OpenSCAD `module` definitions with
# formal arguments, and inline geometry carrying symbolic expressions.
# --------------------------------------------------------------------------

def _sv(v) -> str:
    """One field: number -> formatted literal; string -> verbatim expression."""
    return _fmt(float(v)) if isinstance(v, (int, float)) else str(v)


def _svec(v) -> str:
    return f"[{', '.join(_sv(x) for x in v)}]"


def _sdiff(hi, lo) -> str:
    if isinstance(hi, (int, float)) and isinstance(lo, (int, float)):
        return _fmt(float(hi) - float(lo))
    return f"({_sv(hi)}) - ({_sv(lo)})"


def _axis_of_pair(p0, p1, where: str) -> int:
    """Index of the single differing component of an axis-aligned p0->p1."""
    diff = [i for i in range(3)
            if (str(p0[i]) != str(p1[i])
                if isinstance(p0[i], str) or isinstance(p1[i], str)
                else abs(float(p0[i]) - float(p1[i])) > 1e-9)]
    if len(diff) != 1:
        raise ValueError(
            f"{where}: a cylinder with expression coordinates must be "
            f"axis-aligned (exactly one differing p0/p1 component)")
    return diff[0]


_CYL_ROT = {0: "rotate([0, 90, 0]) ", 1: "rotate([-90, 0, 0]) ", 2: ""}


def _render_2d(node, fn_var: str) -> str:
    """Inline OpenSCAD for a 2D profile expression tree."""
    if "ref" in node:
        return f"polygon({node['ref']}_pts)"
    if "poly" in node:
        pts = ", ".join(_svec(p) for p in node["poly"])
        return f"polygon([{pts}])"
    if "rect" in node:
        x0, y0, x1, y1 = node["rect"]
        return (f"translate([{_sv(x0)}, {_sv(y0)}]) "
                f"square([{_sdiff(x1, x0)}, {_sdiff(y1, y0)}])")
    if node.get("op2d") == "offset":
        return (f"offset(delta = {_sv(node['delta'])}) "
                + _render_2d(node["child"], fn_var))
    kids = " ".join(_render_2d(k, fn_var) + ";" for k in node["children"])
    return f"{node['op2d']}() {{ {kids} }}"


def _emit_sem_prim(node: dict, lines: list[str], depth: int, fn_var: str,
                   profiles: dict) -> None:
    ind = _IND * depth
    n, prim = node["name"], node["prim"]
    lines.append(f"{ind}// {n}: {node['source']}")
    if prim == "box":
        if "min" in node:
            lines.append(f"{ind}translate({_svec(node['min'])}) "
                         f"cube({_svec(node['size'])});")
        else:
            rot = (f"rotate({_svec(node['rotate_deg'])}) "
                   if "rotate_deg" in node else "")
            lines.append(f"{ind}translate({_svec(node['center'])}) {rot}"
                         f"cube({_svec(node['size'])}, center=true);")
    elif prim == "cylinder":
        p0, p1 = node["p0"], node["p1"]
        numeric = all(isinstance(v, (int, float)) for v in list(p0) + list(p1))
        r_args = (f"r1={_sv(node['r'])}, r2={_sv(node['r2'])}"
                  if "r2" in node else f"r={_sv(node['r'])}")
        if numeric:
            import numpy as _np
            orient = _orient_snippet(_np.asarray(p1, float) - _np.asarray(p0, float))
            h = _sdiff(  # length along the axis for readable output
                float(_np.linalg.norm(_np.asarray(p1, float) - _np.asarray(p0, float))), 0.0)
            lines.append(f"{ind}translate({_svec(p0)}) {orient}"
                         f"cylinder(h={h}, {r_args}, $fn={fn_var});")
        else:
            ax = _axis_of_pair(p0, p1, n)
            lines.append(f"{ind}translate({_svec(p0)}) {_CYL_ROT[ax]}"
                         f"cylinder(h={_sdiff(p1[ax], p0[ax])}, {r_args}, "
                         f"$fn={fn_var});")
    elif prim == "sphere":
        lines.append(f"{ind}translate({_svec(node['center'])}) "
                     f"sphere(r={_sv(node['r'])}, $fn={fn_var});")
    elif prim == "extrude":
        orient = _EXTRUDE_ROT[node.get("axis", "z")]
        if "profile2d" in node:
            shape = _render_2d(node["profile2d"], fn_var)
        else:
            shape = f"polygon({profiles[id(node)]})"
        lines.append(f"{ind}{orient}translate([0, 0, {_sv(node['z0'])}]) "
                     f"linear_extrude({_sdiff(node['z1'], node['z0'])}) "
                     f"{shape};")
    elif prim == "offset_sweep":
        # edge treatment: stacked slabs of a 2D shape offset by delta(z)
        law = node["law"]
        z0, z1 = _sv(node["z0"]), _sv(node["z1"])
        steps = node["steps"]
        shape = _render_2d(node["profile2d"], fn_var)
        if law["kind"] == "linear":
            d_expr = (f"({_sv(law['d0'])}) + (({_sv(law['d1'])}) - "
                      f"({_sv(law['d0'])})) * (zm - ({z0})) / (({z1}) - ({z0}))")
        elif law.get("edge", "bottom") == "bottom":
            r = _sv(law["r"])
            d_expr = f"-(({r}) - sqrt(max(0, ({r})*({r}) - (zm - ({z0}) - ({r}))*(zm - ({z0}) - ({r})))))"
        else:
            r = _sv(law["r"])
            d_expr = f"-(({r}) - sqrt(max(0, ({r})*({r}) - (zm - ({z0}))*(zm - ({z0})))))"
        lines.append(f"{ind}for (i = [0 : {steps} - 1]) {{")
        lines.append(f"{ind}    dz = (({z1}) - ({z0})) / {steps};")
        lines.append(f"{ind}    zi = ({z0}) + i * dz;")
        lines.append(f"{ind}    zm = zi + dz / 2;")
        lines.append(f"{ind}    translate([0, 0, zi]) linear_extrude(dz) "
                     f"offset(delta = {d_expr}) {shape};")
        lines.append(f"{ind}}}")
    elif prim == "sweep":
        # slab stack whose top follows h(s)
        law = node["law"]
        s0, s1 = _sv(node["s0"]), _sv(node["s1"])
        u0 = _sv(node["u0"])
        du = _sdiff(node["u1"], node["u0"])
        steps = node["steps"]
        if law["kind"] == "arc":
            h_expr = (f"min({_sv(law['zc'])} + sqrt(max(0, {_sv(law['R'])}*{_sv(law['R'])}"
                      f" - (sm - {_sv(law['sc'])})*(sm - {_sv(law['sc'])}))), "
                      f"{_sv(node['h_max'])})")
        else:
            h_expr = f"min({_sv(law['m'])}*sm + {_sv(law['b'])}, {_sv(node['h_max'])})"
        slab = (f"translate([{u0}, si, {_sv(node['z0'])}]) "
                f"cube([{du}, ds, h - ({_sv(node['z0'])})])"
                if node["axis"] == "y" else
                f"translate([si, {u0}, {_sv(node['z0'])}]) "
                f"cube([ds, {du}, h - ({_sv(node['z0'])})])")
        lines.append(f"{ind}for (i = [0 : {steps} - 1]) {{")
        lines.append(f"{ind}    ds = (({s1}) - ({s0})) / {steps};")
        lines.append(f"{ind}    si = ({s0}) + i * ds;")
        lines.append(f"{ind}    sm = si + ds / 2;")
        lines.append(f"{ind}    h  = {h_expr};")
        lines.append(f"{ind}    if (h > {_sv(node['z0'])}) {slab};")
        lines.append(f"{ind}}}")


def _emit_sem_node(node: dict, lines: list[str], depth: int, fn_var: str,
                   modules: dict, prefix: str, profiles: dict) -> None:
    ind = _IND * depth
    if "transform" in node:
        tf = node["transform"]
        chain = []
        for key, word in (("translate", "translate"), ("rotate_deg", "rotate"),
                          ("mirror", "mirror")):
            if key in tf:
                chain.append(f"{word}({_svec(tf[key])})")
        tag = f"  // {node['name']}" if node.get("name") else ""
        lines.append(f"{ind}{' '.join(chain)} {{{tag}")
        _emit_sem_node(node["child"], lines, depth + 1, fn_var, modules,
                       prefix, profiles)
        lines.append(f"{ind}}}")
        return
    if "call" in node:
        mdef = modules[node["call"]]
        args = ", ".join(_sv(node["args"][a]) for a in mdef.get("args", []))
        lines.append(f"{ind}{prefix}{node['call']}({args});  // {node['name']}")
        return
    if "op" in node:
        lines.append(f"{ind}{node['op']}() {{")
        for kid in node["children"]:
            _emit_sem_node(kid, lines, depth + 1, fn_var, modules, prefix, profiles)
        lines.append(f"{ind}}}")
        return
    _emit_sem_prim(node, lines, depth, fn_var, profiles)


def _collect_profiles(node: dict, modules: dict, prefix: str,
                      profiles: dict, lines: list[str]) -> None:
    """Long measured polygons become named file-level constants."""
    if "transform" in node:
        _collect_profiles(node["child"], modules, prefix, profiles, lines)
        return
    if "op" in node:
        for kid in node["children"]:
            _collect_profiles(kid, modules, prefix, profiles, lines)
    elif "call" in node or "profile2d" in node:
        pass
    elif node.get("prim") == "extrude" and id(node) not in profiles:
        pname = f"{prefix}{node['name']}_profile"
        profiles[id(node)] = pname
        pts = ", ".join(_vec(p) for p in node["profile"])
        uv = {"x": "(y, z)", "y": "(z, x)", "z": "(x, y)"}[node.get("axis", "z")]
        lines.append(f"{pname} = [{pts}];  // {uv} points — {node['source']}")


def _emit_semantic_body(body: dict, entry: dict, lines: list[str],
                        prefix: str = "") -> str:
    bid = body["id"]
    if prefix and entry.get("params"):
        # expressions reference bare param names; prefixed emission would need
        # token rewriting — not implemented until a multi-body semantic plan
        # actually exists.
        raise ValueError("semantic plans are single-body for now (prefix use)")
    modules = entry.get("modules", {})
    fn_var = f"{prefix}fn"

    lines.append(f"// ---- body {bid} (strategy: csg — semantic parametric plan) ----")
    if entry.get("notes"):
        lines.append(f"// plan: {entry['notes']}")
    lines.append("")
    lines.append("// ======== PARAMETERS (every value measured; see source comments) ========")
    params = entry.get("params", [])
    width = max((len(prefix + p["name"]) for p in params), default=0) + 1
    for p in params:
        val = p["expr"] if "expr" in p else _fmt(float(p["value"]))
        lines.append(f"{(prefix + p['name']).ljust(width)}= {val};"
                     f"  // {p['source']}")
    lines.append(f"{(fn_var).ljust(width)}= {_FN};  // curve resolution")
    lines.append("")

    for pname, pts in entry.get("profiles", {}).items():
        joined = ", ".join(_vec(q) for q in pts)
        lines.append(f"{prefix}{pname}_pts = [{joined}];  // measured shared outline")
    profiles: dict[int, str] = {}
    for mdef in modules.values():
        _collect_profiles(mdef["tree"], modules, prefix, profiles, lines)
    _collect_profiles(entry["csg"], modules, prefix, profiles, lines)
    if profiles or entry.get("profiles"):
        lines.append("")

    for mname, mdef in modules.items():
        args = ", ".join(mdef.get("args", []))
        if mdef.get("doc"):
            lines.append(f"// {mdef['doc']}")
        lines.append(f"module {prefix}{mname}({args}) {{")
        _emit_sem_node(mdef["tree"], lines, 1, fn_var, modules, prefix, profiles)
        lines.append("}")
        lines.append("")

    lines.append(f"module body_{bid}() {{")
    _emit_sem_node(entry["csg"], lines, 1, fn_var, modules, prefix, profiles)
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
