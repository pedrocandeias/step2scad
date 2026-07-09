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
    if "path" in node:
        parts = []
        for s in node["path"]:
            if "to" in s:
                parts.append(f"[{_svec(s['to'])}]")
            else:
                a = s["arc"]
                cx, cy = a["c"]
                span = f"(({_sv(a['a1'])}) - ({_sv(a['a0'])}))"
                # k starts at 1: the arc's first point IS the previous
                # segment's endpoint (contiguous path, no duplicate vertices)
                parts.append(
                    f"[for (k = [1 : {a['n']}]) [({_sv(cx)}) + ({_sv(a['r'])})"
                    f"*cos(({_sv(a['a0'])}) + k*{span}/{a['n']}), "
                    f"({_sv(cy)}) + ({_sv(a['r'])})"
                    f"*sin(({_sv(a['a0'])}) + k*{span}/{a['n']})]]")
        joined = ",\n            ".join(parts)
        return f"polygon(concat(\n            {joined}))"
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
    elif prim == "heightfield":
        mname = profiles.get(id(node), f"{node['name']}_hf")
        lines.append(f"{ind}{mname}();")
    elif prim == "skin":
        mname = profiles.get(id(node), f"{node['name']}_skin")
        lines.append(f"{ind}{mname}();")
    elif prim == "offset_sweep":
        # SMOOTH edge treatment (no slab stairs): minkowski of the base shape
        # (inset by min(d0,d1)) with a cone/roundover bit. Corner joins are
        # round (minkowski) — outline corners are arcs anyway.
        law = node["law"]
        z0, z1 = _sv(node["z0"]), _sv(node["z1"])
        h = _sdiff(node["z1"], node["z0"])
        shape = _render_2d(node["profile2d"], fn_var)
        if law["kind"] == "linear":
            d0, d1 = _sv(law["d0"]), _sv(law["d1"])
            dmin = f"min({d0}, {d1})"
            bit = (f"cylinder(h = {h}, r1 = ({d0}) - ({dmin}) + 0.0005, "
                   f"r2 = ({d1}) - ({dmin}) + 0.0005, $fn = {fn_var})")
        else:
            r = _sv(law["r"])
            dmin = f"-({r})"
            if law.get("edge", "bottom") == "bottom":
                arc = (f"[for (k = [0 : 24]) [({r})*sin(k*90/24), "
                       f"({r}) - ({r})*cos(k*90/24)]]")
            else:
                arc = (f"[for (k = [0 : 24]) [({r})*cos(k*90/24), "
                       f"({r})*sin(k*90/24)]]")
            bit = (f"rotate_extrude($fn = {fn_var}) "
                   f"polygon(concat([[0, 0]], {arc}))")
        lines.append(f"{ind}minkowski() {{")
        lines.append(f"{ind}    translate([0, 0, {z0}]) linear_extrude(0.001) "
                     f"offset(delta = {dmin}) {shape};")
        lines.append(f"{ind}    {bit};")
        lines.append(f"{ind}}}")
    elif prim == "sweep":
        # SMOOTH height-law sweep (no slab stairs): the law becomes an exact
        # clip solid — a linear law is a tilted half-space; an ARC law IS a
        # horizontal cylinder (axis along the cross direction) + under-fill.
        law = node["law"]
        s0, s1 = _sv(node["s0"]), _sv(node["s1"])
        u0 = _sv(node["u0"])
        du = _sdiff(node["u1"], node["u0"])
        ds = _sdiff(node["s1"], node["s0"])
        z0, hm = _sv(node["z0"]), _sv(node["h_max"])
        ax = node["axis"]
        prism = (f"translate([{u0}, {s0}, {z0}]) "
                 f"cube([{du}, {ds}, ({hm}) - ({z0})])"
                 if ax == "y" else
                 f"translate([{s0}, {u0}, {z0}]) "
                 f"cube([{ds}, {du}, ({hm}) - ({z0})])")
        lines.append(f"{ind}intersection() {{")
        lines.append(f"{ind}    {prism};")
        if law["kind"] == "linear":
            m, b = _sv(law["m"]), _sv(law["b"])
            tilt = (f"rotate([atan({m}), 0, 0])" if ax == "y"
                    else f"rotate([0, -atan({m}), 0])")
            lines.append(f"{ind}    translate([0, 0, {b}]) {tilt} "
                         f"translate([-500, -500, -1000]) cube([1000, 1000, 1000]);")
        else:
            sc, zc, R_ = _sv(law["sc"]), _sv(law["zc"]), _sv(law["R"])
            if ax == "y":
                cyl = (f"translate([({u0}) - 1, {sc}, {zc}]) rotate([0, 90, 0]) "
                       f"cylinder(h = ({du}) + 2, r = {R_}, $fn = 4*{fn_var})")
            else:
                cyl = (f"translate([{sc}, ({u0}) - 1, {zc}]) rotate([-90, 0, 0]) "
                       f"cylinder(h = ({du}) + 2, r = {R_}, $fn = 4*{fn_var})")
            lines.append(f"{ind}    union() {{")
            lines.append(f"{ind}        {cyl};")
            lines.append(f"{ind}        translate([-500, -500, ({zc}) - 1000]) "
                         f"cube([1000, 1000, 1000]);")
            lines.append(f"{ind}    }}")
        lines.append(f"{ind}}}")


def _emit_sem_node(node: dict, lines: list[str], depth: int, fn_var: str,
                   modules: dict, prefix: str, profiles: dict) -> None:
    ind = _IND * depth
    if isinstance(node, dict) and "color" in node:
        c = node["color"]
        cstr = f'"{c}"' if isinstance(c, str) else _svec(c)
        tag = f"  // {node['name']}" if node.get("name") else ""
        lines.append(f"{ind}color({cstr}) {{{tag}")
        inner = {k: v for k, v in node.items() if k != "color"}
        _emit_sem_node(inner, lines, depth + 1, fn_var, modules, prefix, profiles)
        lines.append(f"{ind}}}")
        return
    if "transform" in node:
        tf = node["transform"]
        chain = []
        for key, word in (("translate", "translate"), ("rotate_deg", "rotate"),
                          ("mirror", "mirror"), ("scale", "scale")):
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






# world-point mapping per skin/extrude axis: (u, v, s) -> [x, y, z] exprs
_SKIN_MAP = {
    "z": lambda u, v, s: f"[{u}, {v}, {s}]",
    "y": lambda u, v, s: f"[{v}, {s}, {u}]",
    "x": lambda u, v, s: f"[{s}, {u}, {v}]",
}


def _emit_skin_module(node: dict, mname: str, lines: list[str]) -> None:
    """Ruled loft through consecutive section outlines (no slab stairs).

    Sections are index-correspondent rings; side walls are quad strips
    between consecutive rings, end rings capped with planar polygons.
    """
    axis = node.get("axis", "z")
    secs = node["sections"]
    outs = ",\n    ".join(
        "[" + ", ".join(_vec(q) for q in s["outline"]) + "]" for s in secs)
    ats = ", ".join(_sv(s["at"]) for s in secs)
    lines.append(f"{mname}_rings = [\n    {outs}\n];  // section outlines — "
                 f"{node['source']}")
    lines.append(f"{mname}_ats = [{ats}];  // station positions along {axis}")
    pt = _SKIN_MAP[axis]("r[0]", "r[1]", f"{mname}_ats[k]")
    lines.append(f"""module {mname}() {{
    rings = {mname}_rings;
    ns = len(rings); N = len(rings[0]);
    pts = [for (k = [0:ns-1]) for (r = rings[k]) let(s = {mname}_ats[k]) {_SKIN_MAP[axis]('r[0]', 'r[1]', 's')}];
    side = [for (k = [0:ns-2]) for (i = [0:N-1]) each [
        [k*N + i, (k+1)*N + (i+1)%N, k*N + (i+1)%N],
        [k*N + i, (k+1)*N + i, (k+1)*N + (i+1)%N]]];
    cap0 = [[for (i = [0:N-1]) i]];
    cap1 = [[for (i = [N-1:-1:0]) (ns-1)*N + i]];
    polyhedron(points = pts, faces = concat(side, cap0, cap1), convexity = 10);
}}""")
    lines.append("")

def _emit_heightfield_module(node: dict, mname: str, lines: list[str]) -> None:
    """Control-height lattice -> smooth polyhedron module (no stairs).

    heights[i][j] = top z at (x0 + j*dx, y0 + i*dy); the top surface is the
    triangulated control grid itself (bilinear structure), walls drop to z0,
    optional 2D footprint clips the block. Heights are editable named values.
    """
    hs = node["heights"]
    rows = ",\n    ".join("[" + ", ".join(_sv(v) for v in row) + "]"
                          for row in hs)
    lines.append(f"{mname}_heights = [\n    {rows}\n];  // control heights "
                 f"— {node['source']}")
    x0, y0 = _sv(node["x0"]), _sv(node["y0"])
    dx, dy = _sv(node["dx"]), _sv(node["dy"])
    z0 = _sv(node["z0"])
    lines.append(f"module {mname}() {{")
    body = f"""    hs = {mname}_heights;
    ny = len(hs); nx = len(hs[0]); N = nx * ny;
    pts = concat(
        [for (i = [0:ny-1]) for (j = [0:nx-1])
            [({x0}) + j*({dx}), ({y0}) + i*({dy}), hs[i][j]]],
        [for (i = [0:ny-1]) for (j = [0:nx-1])
            [({x0}) + j*({dx}), ({y0}) + i*({dy}), {z0}]]);
    fcs = concat(
        [for (i = [0:ny-2]) for (j = [0:nx-2]) each [
            [i*nx+j, (i+1)*nx+j, (i+1)*nx+j+1],
            [i*nx+j, (i+1)*nx+j+1, i*nx+j+1]]],
        [for (i = [0:ny-2]) for (j = [0:nx-2]) each [
            [N+i*nx+j, N+(i+1)*nx+j+1, N+(i+1)*nx+j],
            [N+i*nx+j, N+i*nx+j+1, N+(i+1)*nx+j+1]]],
        [for (j = [0:nx-2]) each [[j, j+1, N+j+1], [j, N+j+1, N+j]]],
        [for (j = [0:nx-2]) each [
            [(ny-1)*nx+j, N+(ny-1)*nx+j+1, (ny-1)*nx+j+1],
            [(ny-1)*nx+j, N+(ny-1)*nx+j, N+(ny-1)*nx+j+1]]],
        [for (i = [0:ny-2]) each [
            [i*nx, N+i*nx, N+(i+1)*nx], [i*nx, N+(i+1)*nx, (i+1)*nx]]],
        [for (i = [0:ny-2]) each [
            [i*nx+nx-1, (i+1)*nx+nx-1, N+(i+1)*nx+nx-1],
            [i*nx+nx-1, N+(i+1)*nx+nx-1, N+i*nx+nx-1]]]);
"""
    lines.append(body.rstrip())
    if "footprint" in node:
        fp = _render_2d(node["footprint"], "$fn")
        lines.append("    intersection() {")
        lines.append("        polyhedron(points = pts, faces = fcs, convexity = 10);")
        lines.append(f"        translate([0, 0, ({z0}) - 1]) "
                     f"linear_extrude(1000) {fp};")
        lines.append("    }")
    else:
        lines.append("    polyhedron(points = pts, faces = fcs, convexity = 10);")
    lines.append("}")
    lines.append("")

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
    elif node.get("prim") == "heightfield" and id(node) not in profiles:
        mname = f"{prefix}{node['name']}_hf"
        profiles[id(node)] = mname
        _emit_heightfield_module(node, mname, lines)
    elif node.get("prim") == "skin" and id(node) not in profiles:
        mname = f"{prefix}{node['name']}_skin"
        profiles[id(node)] = mname
        _emit_skin_module(node, mname, lines)



def _prefix_entry(entry: dict, prefix: str) -> dict:
    """Bake the body prefix into every name-like token of a semantic plan
    entry (params, profile keys/refs, module keys/calls, node names, and all
    identifiers inside expressions) so multi-body plans emit collision-free.
    Module formal args shadow params and are NOT rewritten inside their tree.
    """
    import copy
    import re

    e = copy.deepcopy(entry)
    pnames = {q["name"] for q in e.get("params", [])}
    profs = set(e.get("profiles", {}))
    mods = set(e.get("modules", {}))

    def rw_expr(expr, exclude):
        names = (pnames - exclude)
        if not names or not isinstance(expr, str):
            return expr
        pat = re.compile(r"\b(" + "|".join(sorted(names, key=len, reverse=True))
                         + r")\b")
        return pat.sub(lambda m: prefix + m.group(1), expr)

    def walk(n, exclude):
        if isinstance(n, dict):
            out = {}
            for k, v in n.items():
                if k == "ref" and isinstance(v, str):
                    out[k] = prefix + v if v in profs else v
                elif k == "call" and isinstance(v, str):
                    out[k] = prefix + v if v in mods else v
                elif k == "name" and isinstance(v, str):
                    out[k] = prefix + v
                elif k in ("source", "doc", "notes", "kind", "axis", "edge"):
                    out[k] = v
                else:
                    out[k] = walk(v, exclude)
            return out
        if isinstance(n, list):
            return [walk(v, exclude) for v in n]
        if isinstance(n, str):
            return rw_expr(n, exclude)
        return n

    for q in e.get("params", []):
        if "expr" in q:
            q["expr"] = rw_expr(q["expr"], frozenset())
    e["profiles"] = {prefix + k: walk(v, frozenset())
                     for k, v in e.get("profiles", {}).items()}
    new_mods = {}
    for mname, mdef in e.get("modules", {}).items():
        args = frozenset(mdef.get("args", []))
        new_mods[prefix + mname] = {**mdef, "tree": walk(mdef["tree"], args)}
    e["modules"] = new_mods
    e["csg"] = walk(e["csg"], frozenset())
    for q in e.get("params", []):
        q["name"] = prefix + q["name"]
    return e

def _emit_semantic_body(body: dict, entry: dict, lines: list[str],
                        prefix: str = "") -> str:
    bid = body["id"]
    fn_var = f"{prefix}fn"
    if prefix:
        # bake the body prefix into every name/expression, then emit bare —
        # this is what makes multi-body semantic plans (params, shared
        # profiles, modules) collision-free
        entry = _prefix_entry(entry, prefix)
        prefix = ""
    modules = entry.get("modules", {})

    import textwrap
    lines.append("// " + "-" * 68)
    lines.append(f"// BODY {bid} — semantic parametric plan")
    if entry.get("notes"):
        for ln in textwrap.wrap(entry["notes"], 66):
            lines.append(f"//   {ln}")
    if modules:
        lines.append("// Anatomy (modules):")
        for mname, mdef in modules.items():
            doc = (mdef.get("doc") or "").split(";")[0].split(". ")[0]
            if len(doc) > 72:
                doc = doc[:69].rsplit(" ", 1)[0] + "..."
            lines.append(f"//   {mname}() — {doc}" if doc else f"//   {mname}()")
    lines.append("// " + "-" * 68)
    lines.append("")
    lines.append("// ======== PARAMETERS (every value measured; sources cited) ========")
    params = entry.get("params", [])
    width = max((len(prefix + p["name"]) for p in params), default=0) + 1
    group_of = lambda nm: nm.split("_", 1)[0]
    # stable group sort (groups in first-appearance order), then repair any
    # forward expression references — OpenSCAD evaluates assignments in order
    import re as _re
    seen_groups = []
    for p in params:
        g = group_of(p["name"])
        if g not in seen_groups:
            seen_groups.append(g)
    ordered = [p for g in seen_groups for p in params if group_of(p["name"]) == g]
    names = {p["name"] for p in params}
    for _ in range(len(ordered)):
        pos = {p["name"]: i for i, p in enumerate(ordered)}
        moved = False
        for p in list(ordered):
            if "expr" not in p:
                continue
            deps = [d for d in _re.findall(r"[A-Za-z_]\w*", str(p["expr"]))
                    if d in names]
            latest = max((pos[d] for d in deps), default=-1)
            if latest > pos[p["name"]]:
                ordered.remove(p)
                ordered.insert(latest, p)
                moved = True
                break
        if not moved:
            break
    last_group = None
    for p in ordered:
        g = group_of(p["name"])
        if g != last_group:
            lines.append(f"// --- {g} ---")
            last_group = g
        val = p["expr"] if "expr" in p else _fmt(float(p["value"]))
        lines.append(f"{(prefix + p['name']).ljust(width)}= {val};"
                     f"  // {p['source']}")
    lines.append(f"{(fn_var).ljust(width)}= {_FN};  // curve resolution")
    lines.append("")

    for pname, pts in entry.get("profiles", {}).items():
        if isinstance(pts, dict) and "path" in pts:
            body = _render_2d(pts, "fn")[len("polygon("):-1]
            src = pts.get("source", "vectorized shared outline (lines + fitted arcs)")
            lines.append(f"{prefix}{pname}_pts = {body};  // {src}")
        else:
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
    root = entry["csg"]
    if root.get("op") == "union" and len(root.get("children", [])) > 1:
        palette = ("SteelBlue", "MediumSeaGreen", "Orange", "Crimson",
                   "MediumPurple", "Goldenrod", "Teal", "RosyBrown")
        lines.append(f"{_IND}union() {{")
        for i, kid in enumerate(root["children"]):
            lines.append(f'{_IND * 2}tint("{palette[i % len(palette)]}") {{')
            _emit_sem_node(kid, lines, 3, fn_var, modules, prefix, profiles)
            lines.append(f"{_IND * 2}}}")
        lines.append(f"{_IND}}}")
    else:
        _emit_sem_node(root, lines, 1, fn_var, modules, prefix, profiles)
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
