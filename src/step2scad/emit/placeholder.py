"""Stage 3: EMIT — parametric .scad emission (dispatch + placeholder emitters).

`emit_scad` is the stage-3 entry point. It routes each body by strategy:

    rotate_extrude -> emit/revolve.py (REAL emitter: exact RZ-profile
                      rotate_extrude built from the coaxial B-rep faces);
                      this module's trivial coaxial-cylinder emitter remains
                      only as the fallback if the profile build fails
    everything else -> PLACEHOLDER: the body's bounding box (documented stub)

Placeholder emitters exist so the ingest→classify→emit→export→eval loop is
runnable end-to-end for every strategy. Every number written into the .scad
is an EXACT B-rep value from features.json (never estimated), and each is
commented with the face it came from — the same discipline the real emitters
follow. Remaining real emitters (section linear_extrude, CSG w/ chamfers +
fillets, freeform loft) are the next milestone and replace the stubs here.
"""

from __future__ import annotations

import math

import numpy as np

_FN = 128  # curve resolution for placeholder cylinders


def _fmt(x: float) -> str:
    """Compact but lossless-enough number formatting for .scad."""
    s = f"{x:.6f}".rstrip("0").rstrip(".")
    return s if s not in ("", "-0") else "0"


def _orient_snippet(axis_dir: np.ndarray) -> str:
    """OpenSCAD transform that maps +Z onto axis_dir (rotate(a, v) form)."""
    z = np.array([0.0, 0.0, 1.0])
    d = axis_dir / np.linalg.norm(axis_dir)
    c = float(np.clip(np.dot(z, d), -1.0, 1.0))
    if c > 1 - 1e-12:
        return ""  # already +Z aligned
    if c < -1 + 1e-12:
        return "rotate([180, 0, 0]) "
    v = np.cross(z, d)
    ang = math.degrees(math.acos(c))
    return (
        f"rotate(a={_fmt(ang)}, v=[{_fmt(v[0])}, {_fmt(v[1])}, {_fmt(v[2])}]) "
    )


def _coaxial_cylinders(body: dict, axis: dict) -> list[dict]:
    """Cylinder faces of `body` lying on the classified rotation axis."""
    o = np.asarray(axis["origin"], float)
    d = np.asarray(axis["dir"], float)
    out = []
    for f in body["faces"]:
        if f["type"] != "cylinder":
            continue
        fo = np.asarray(f["params"]["axis_origin"], float)
        fd = np.asarray(f["params"]["axis_dir"], float)
        if abs(abs(float(np.dot(fd, d))) - 1.0) > 1e-4:
            continue
        w = fo - o
        if float(np.linalg.norm(w - np.dot(w, d) * d)) > 1e-3:
            continue
        out.append(f)
    return out


def _axial_extent(faces: list[dict], axis: dict) -> tuple[float, float]:
    """World-space extent along the axis from the faces' exact B-rep v-ranges.

    For an OCC cylinder surface, the v parameter IS the signed distance along
    the face's own axis from its axis origin — an exact value, not a sample.
    """
    d = np.asarray(axis["dir"], float)
    lo, hi = math.inf, -math.inf
    for f in faces:
        fo = np.asarray(f["params"]["axis_origin"], float)
        fd = np.asarray(f["params"]["axis_dir"], float)
        base = float(np.dot(fo, d))
        sign = float(np.sign(np.dot(fd, d))) or 1.0
        for v in f["v_range"]:
            t = base + sign * v
            lo, hi = min(lo, t), max(hi, t)
    return lo, hi


def _emit_rotational_body(body: dict, cls: dict, lines: list[str]) -> str:
    bid = body["id"]
    axis = cls["axis"]
    d = np.asarray(axis["dir"], float)
    d = d / np.linalg.norm(d)
    cyls = _coaxial_cylinders(body, axis)

    outer = max(cyls, key=lambda f: f["params"]["radius"])
    bores = [f for f in cyls if f["orientation"] == "reversed"]
    bore = min(bores, key=lambda f: f["params"]["radius"]) if bores else None
    if bore is not None and bore["params"]["radius"] >= outer["params"]["radius"]:
        bore = None

    z0, z1 = _axial_extent(cyls, axis)
    o = np.asarray(axis["origin"], float)
    p0 = o + (z0 - float(np.dot(o, d))) * d  # world point where the body starts

    v = f"b{bid}"
    lines.append(f"// ---- body {bid} (strategy: rotate_extrude — placeholder) ----")
    lines.append(
        f"{v}_outer_r = {_fmt(outer['params']['radius'])};"
        f"  // exact B-rep: cylinder face #{outer['index']} radius"
    )
    if bore is not None:
        lines.append(
            f"{v}_bore_r  = {_fmt(bore['params']['radius'])};"
            f"  // exact B-rep: cylinder face #{bore['index']} radius (reversed -> bore)"
        )
    lines.append(
        f"{v}_h       = {_fmt(z1 - z0)};"
        f"  // axial extent of the {len(cyls)} coaxial cylinder faces (exact v-ranges)"
    )
    lines.append("")
    lines.append(f"module body_{bid}() {{")
    place = (
        f"    translate([{_fmt(p0[0])}, {_fmt(p0[1])}, {_fmt(p0[2])}]) "
        + _orient_snippet(d)
    )
    if bore is not None:
        lines.append(place + "difference() {")
        lines.append(f"        cylinder(r={v}_outer_r, h={v}_h, $fn={_FN});")
        lines.append(
            f"        translate([0, 0, -1]) cylinder(r={v}_bore_r, h={v}_h + 2, $fn={_FN});"
        )
        lines.append("    }")
    else:
        lines.append(place + f"cylinder(r={v}_outer_r, h={v}_h, $fn={_FN});")
    lines.append("}")
    return f"body_{bid}"


def _emit_bbox_body(body: dict, cls: dict, lines: list[str]) -> str:
    bid = body["id"]
    bmin = body["bbox"]["min"]
    bmax = body["bbox"]["max"]
    size = [bmax[i] - bmin[i] for i in range(3)]
    v = f"b{bid}"
    lines.append(
        f"// ---- body {bid} (strategy: {cls['strategy']} — placeholder bbox) ----"
    )
    lines.append(
        f"{v}_min  = [{', '.join(_fmt(x) for x in bmin)}];  // exact B-rep bbox corner"
    )
    lines.append(f"{v}_size = [{', '.join(_fmt(x) for x in size)}];")
    lines.append("")
    lines.append(f"module body_{bid}() {{")
    lines.append(f"    translate({v}_min) cube({v}_size);")
    lines.append("}")
    return f"body_{bid}"


def emit_scad(
    features: dict,
    classification: dict,
    name: str,
    overrides: dict[int, list[dict]] | None = None,
    plan: dict | None = None,
) -> str:
    """Emit the parametric .scad for all bodies. Returns scad text.

    Dispatch: bodies with an agent-plan entry (see step2scad.plan) route by
    the PLAN's strategy — csg -> emit/csg.py (plan-driven, zero judgment),
    instance_of -> translated module reuse. rotate_extrude bodies go to the
    real RZ-profile emitter (emit/revolve.py); remaining strategies keep
    their placeholder stubs. `overrides` maps body_id -> refine-loop radial
    corrections (see revolve.emit_revolve_body) applied by step2scad.refine
    (rule 6).
    """
    # Lazy import: revolve imports this module's helpers (_fmt, _orient_snippet).
    from step2scad.emit import csg as csg_emit
    from step2scad.emit import revolve
    from step2scad.plan import plan_bodies

    cls_by_id = {c["body_id"]: c for c in classification["bodies"]}
    plan_by_id = plan_bodies(plan)
    lines = [
        "// " + "=" * 68,
        f"// {name} — step2scad parametric reconstruction",
        f"// source: {features.get('source', '?')}",
        "// Every dimension is measured from the STEP B-rep (exact faces) or a",
        "// fitted law with its residual cited — see the source comment on each",
        "// parameter. Edit named parameters; geometry follows.",
        "// " + "=" * 68,
        "",
    ]
    any_semantic = any(
        e.get("params") or e.get("modules")
        for e in plan_by_id.values() if isinstance(e, dict))
    if any_semantic:
        lines += [
            "// --- Display options ---",
            "show_colors   = true;    // tint top-level features (preview aid)",
            "show_original = false;   // ghost the original tessellation overlay",
            f'original_stl  = "{name}_ref.stl";',
            "module tint(c) { if (show_colors) color(c) children(); "
            "else children(); }",
            "",
        ]
    modules = []
    for body in features["bodies"]:
        cls = cls_by_id[body["id"]]
        entry = plan_by_id.get(body["id"])
        prefix = f"b{body['id']}_" if len(features["bodies"]) > 1 else ""
        body_lines: list[str] = []
        try:
            if entry is not None and entry["strategy"] == "csg":
                modules.append(
                    csg_emit.emit_csg_body(body, entry, body_lines, prefix=prefix)
                )
            elif entry is not None and entry["strategy"] == "instance_of":
                modules.append(csg_emit.emit_instance_body(body, entry, body_lines))
            elif cls["strategy"] == "rotate_extrude" and "axis" in cls:
                try:
                    modules.append(
                        revolve.emit_revolve_body(
                            body,
                            cls,
                            body_lines,
                            prefix=prefix,
                            overrides=(overrides or {}).get(body["id"]),
                        )
                    )
                except Exception as exc:
                    body_lines = [
                        f"// body {body['id']}: RZ-profile emitter failed ({exc});",
                        "// falling back to the placeholder coaxial-cylinder stub.",
                    ]
                    modules.append(_emit_rotational_body(body, cls, body_lines))
            else:
                modules.append(_emit_bbox_body(body, cls, body_lines))
        except Exception:
            if entry is not None:
                # An agent plan must execute exactly or fail loudly — a silent
                # bbox stand-in would fake a reconstruction that isn't the plan.
                raise
            # Heuristic paths: never let one body kill the loop.
            body_lines = []
            modules.append(_emit_bbox_body(body, cls, body_lines))
        lines.extend(body_lines)
        lines.append("")
    lines.append("// full part = union of all bodies")
    for m in modules:
        lines.append(f"{m}();")
    if any_semantic:
        lines.append("if (show_original) %import(original_stl);")
    lines.append("")
    return "\n".join(lines)
