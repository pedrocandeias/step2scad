"""Stage 3 emitter: rotate_extrude — EXACT RZ profile from the coaxial B-rep faces.

For a body the classifier tagged `rotate_extrude`, build the exact
radius–height profile polygon from the body's coaxial analytic faces and emit

    rotate_extrude($fn = …) polygon(points = [ … ]);

Construction (all values are exact B-rep parameters from features.json —
nothing is measured off a mesh):

    cylinder  radius R over axial extent [z0, z1]  -> vertical profile segment
    cone      -> sloped segment between its exact (r, z) endpoints — this is
                 how chamfers / tapers / countersinks appear in the profile
    torus /   -> exact circular arc in the RZ plane, discretised into short
    sphere       linear pieces (endpoints evaluated from the analytic surface)
    plane ⟂ axis at height z -> horizontal segment (caps, flange steps)

The union of all face axial breakpoints forms the profile z-knots; the OUTER
envelope (forward faces) and INNER/bore envelope (reversed faces) are
evaluated exactly at each knot and assembled into one closed boundary loop:
up the bore, across the top, down the outside, across the bottom. A through-
bore makes the profile a ring cross-section, so rotate_extrude produces the
hole automatically.

Self-check: the profile's solid of revolution volume (Pappus: V = 2π·r̄·A)
must match the exact B-rep body volume — a mismatch means the profile is
wrong and the emitter raises instead of writing bad geometry (the dispatcher
then falls back to the placeholder).

The emitted code is READABLE: a named-variable block (bore_r, od_r, flange_r,
flange_h, total_h, chamfer sizes, fn), each an exact B-rep value with a
provenance comment naming the face(s) it came from; the polygon references
those variables, not magic numbers.

`overrides` (used by step2scad.refine, CLAUDE.md rule 6) applies targeted
radial corrections to profile vertices inside a z band; corrected vertices
are emitted as literals tagged `REFINED` so the provenance stays honest.
"""

from __future__ import annotations

import math

import numpy as np

from step2scad.emit.placeholder import _fmt, _orient_snippet

_FN = 128  # rotate_extrude curve resolution

_PARALLEL_TOL = 1e-4
_COAXIAL_DIST_TOL = 1e-3  # mm
_KNOT_TOL = 1e-6  # mm: merge profile z-knots closer than this
_VAL_TOL = 1e-6  # mm: numeric == when matching vertices to named variables
_ARC_STEP = math.radians(15.0)  # torus/sphere arc discretisation step
_PAPPUS_TOL = 0.02  # profile volume must match B-rep volume within 2%
_SKIP_AREA_FRAC = 0.05  # max non-conforming face area before we refuse


# --------------------------------------------------------------------------
# axis frame + face -> RZ segments
# --------------------------------------------------------------------------

def axis_frame(cls: dict) -> tuple[np.ndarray, np.ndarray]:
    """Canonical revolution axis (origin, unit dir): dir's dominant component
    is made positive so profile z increases 'up' the part."""
    o = np.asarray(cls["axis"]["origin"], float)
    d = np.asarray(cls["axis"]["dir"], float)
    d = d / np.linalg.norm(d)
    if d[int(np.argmax(np.abs(d)))] < 0:
        d = -d
    return o, d


def _coaxial(face_origin, face_dir, o: np.ndarray, d: np.ndarray) -> bool:
    fd = np.asarray(face_dir, float)
    if abs(abs(float(np.dot(fd, d))) - 1.0) > _PARALLEL_TOL:
        return False
    w = np.asarray(face_origin, float) - o
    return float(np.linalg.norm(w - np.dot(w, d) * d)) < _COAXIAL_DIST_TOL


def _seg(kind: str, side: str, face: dict, p0, p1, meta: dict | None = None) -> dict | None:
    """One linear RZ piece (r0,t0)-(r1,t1), t-sorted; None if axially degenerate."""
    (r0, t0), (r1, t1) = (p0, p1) if p0[1] <= p1[1] else (p1, p0)
    if abs(t1 - t0) < _KNOT_TOL and abs(r1 - r0) < _VAL_TOL:
        return None
    return {
        "kind": kind,
        "side": side,
        "faces": [face["index"]],
        "r0": float(r0),
        "t0": float(t0),
        "r1": float(r1),
        "t1": float(t1),
        "meta": meta or {},
    }


def _face_segments(face: dict, o: np.ndarray, d: np.ndarray) -> list[dict] | None:
    """Exact RZ profile piece(s) for one face; None if the face is not a
    coaxial rotational surface (caller counts its area as non-conforming)."""
    p = face["params"]
    side = "inner" if face["orientation"] == "reversed" else "outer"
    ftype = face["type"]

    if ftype == "cylinder":
        if not _coaxial(p["axis_origin"], p["axis_dir"], o, d):
            return None
        sign = 1.0 if float(np.dot(np.asarray(p["axis_dir"], float), d)) > 0 else -1.0
        base = float(np.dot(np.asarray(p["axis_origin"], float), d))
        r = float(p["radius"])
        v0, v1 = face["v_range"]
        s = _seg("cyl", side, face, (r, base + sign * v0), (r, base + sign * v1))
        return [s] if s else []

    if ftype == "cone":
        if not _coaxial(p["axis_origin"], p["axis_dir"], o, d):
            return None
        sign = 1.0 if float(np.dot(np.asarray(p["axis_dir"], float), d)) > 0 else -1.0
        base = float(np.dot(np.asarray(p["axis_origin"], float), d))
        semi = math.radians(float(p["half_angle_deg"]))
        pts = [
            (float(p["ref_radius"]) + v * math.sin(semi), base + sign * v * math.cos(semi))
            for v in face["v_range"]
        ]
        s = _seg("cone", side, face, pts[0], pts[1],
                 meta={"half_angle_deg": float(p["half_angle_deg"])})
        return [s] if s else []

    if ftype == "torus":
        if not _coaxial(p["axis_origin"], p["axis_dir"], o, d):
            return None
        sign = 1.0 if float(np.dot(np.asarray(p["axis_dir"], float), d)) > 0 else -1.0
        base = float(np.dot(np.asarray(p["axis_origin"], float), d))
        R, r = float(p["major_radius"]), float(p["minor_radius"])
        v0, v1 = face["v_range"]  # v = angle around the tube (exact arc param)
        n = max(2, int(math.ceil(abs(v1 - v0) / _ARC_STEP)))
        pts = [
            (R + r * math.cos(v), base + sign * r * math.sin(v))
            for v in np.linspace(v0, v1, n + 1)
        ]
        segs = [_seg("arc", side, face, pts[i], pts[i + 1]) for i in range(n)]
        return [s for s in segs if s]

    if ftype == "sphere":
        c = np.asarray(p["center"], float)
        if float(np.linalg.norm((c - o) - np.dot(c - o, d) * d)) > _COAXIAL_DIST_TOL:
            return None
        base = float(np.dot(c, d))
        R = float(p["radius"])
        v0, v1 = face["v_range"]  # v = latitude (exact arc param)
        n = max(2, int(math.ceil(abs(v1 - v0) / _ARC_STEP)))
        pts = [
            (R * math.cos(v), base + R * math.sin(v)) for v in np.linspace(v0, v1, n + 1)
        ]
        segs = [_seg("arc", side, face, pts[i], pts[i + 1]) for i in range(n)]
        return [s for s in segs if s]

    return None


def _r_at(seg: dict, t: float) -> float:
    """Radius of a linear RZ piece at axial coordinate t (exact endpoints)."""
    if abs(seg["t1"] - seg["t0"]) < _KNOT_TOL:
        return max(seg["r0"], seg["r1"])
    f = (t - seg["t0"]) / (seg["t1"] - seg["t0"])
    f = min(1.0, max(0.0, f))
    return seg["r0"] + f * (seg["r1"] - seg["r0"])


# --------------------------------------------------------------------------
# profile assembly: knots -> envelopes -> boundary chains
# --------------------------------------------------------------------------

def _dedupe_segments(segs: list[dict]) -> list[dict]:
    """Merge seam-split duplicate faces (identical RZ pieces) — provenance
    keeps every contributing face index."""
    out: dict[tuple, dict] = {}
    for s in segs:
        key = (s["side"], s["kind"], round(s["r0"], 6), round(s["t0"], 6),
               round(s["r1"], 6), round(s["t1"], 6))
        if key in out:
            out[key]["faces"] = sorted(set(out[key]["faces"] + s["faces"]))
        else:
            out[key] = s
    return list(out.values())


def _merge_knots(values: list[float]) -> list[float]:
    knots: list[float] = []
    for v in sorted(values):
        if not knots or v - knots[-1] > _KNOT_TOL:
            knots.append(v)
    return knots


def _boundary_chain(intervals: list[tuple[float, float]],
                    chosen: list[dict | None]) -> list[list]:
    """Ordered boundary polyline [(r, t, seg)] bottom -> top. Steps at knots
    (r jump between consecutive segments, i.e. a plane face) come out as the
    two distinct points of a horizontal segment; collinear middles merge."""
    pts: list[list] = []
    for (a, b), seg in zip(intervals, chosen):
        for t in (a, b):
            r = _r_at(seg, t) if seg is not None else 0.0
            if pts and abs(pts[-1][0] - r) < _VAL_TOL and abs(pts[-1][1] - t) < _KNOT_TOL:
                continue
            pts.append([r, t, seg])
    out = pts[:1]
    for q in pts[1:]:
        if len(out) >= 2:
            (r1, t1, _), (r2, t2, _) = out[-2], out[-1]
            cross = (r2 - r1) * (q[1] - t1) - (t2 - t1) * (q[0] - r1)
            if abs(cross) < 1e-7:
                out[-1] = q  # drop the collinear middle vertex
                continue
        out.append(q)
    return out


def _polygon_area_centroid(loop: list[tuple[float, float]]) -> tuple[float, float]:
    """Signed shoelace area + r-coordinate of the centroid of the RZ loop."""
    a2 = cx6 = 0.0
    n = len(loop)
    for i in range(n):
        x0, y0 = loop[i]
        x1, y1 = loop[(i + 1) % n]
        cross = x0 * y1 - x1 * y0
        a2 += cross
        cx6 += (x0 + x1) * cross
    area = a2 / 2.0
    cx = cx6 / (6.0 * area) if abs(area) > 1e-12 else 0.0
    return area, cx


def build_profile(body: dict, cls: dict) -> dict:
    """Exact RZ profile of a rotational body from its coaxial B-rep faces.

    Returns axis frame, z span, plane knots, and the inner/outer boundary
    chains as [(r, z_rel, seg)] with z_rel measured from the axis low end.
    Raises ValueError if the body is not a clean solid of revolution or the
    Pappus volume check fails.
    """
    o, d = axis_frame(cls)
    total_area = sum(f["area"] for f in body["faces"]) or 1.0
    segs: list[dict] = []
    planes: list[dict] = []  # {"t": axial coord, "faces": [...]}
    skipped = 0.0
    for f in body["faces"]:
        if f["type"] == "plane":
            n = np.asarray(f["params"]["normal"], float)
            if abs(abs(float(np.dot(n, d))) - 1.0) < 1e-3:
                t = float(np.dot(np.asarray(f["params"]["origin"], float), d))
                for pk in planes:
                    if abs(pk["t"] - t) < _KNOT_TOL:
                        pk["faces"].append(f["index"])
                        break
                else:
                    planes.append({"t": t, "faces": [f["index"]]})
            else:
                skipped += f["area"]
            continue
        pieces = _face_segments(f, o, d)
        if pieces is None:
            skipped += f["area"]
        else:
            segs.extend(pieces)
    if skipped / total_area > _SKIP_AREA_FRAC:
        raise ValueError(
            f"{skipped / total_area:.0%} of face area is not coaxial/planar — "
            "not a clean solid of revolution"
        )
    segs = _dedupe_segments(segs)
    if not any(s["side"] == "outer" for s in segs):
        raise ValueError("no outer (forward) rotational faces — cannot build envelope")

    knots = _merge_knots(
        [s["t0"] for s in segs] + [s["t1"] for s in segs] + [p["t"] for p in planes]
    )
    t_min, t_max = knots[0], knots[-1]
    intervals = [
        (knots[i], knots[i + 1])
        for i in range(len(knots) - 1)
        if knots[i + 1] - knots[i] > _KNOT_TOL
    ]

    outer_iv: list[dict | None] = []
    inner_iv: list[dict | None] = []
    for a, b in intervals:
        mid = (a + b) / 2.0
        outs = [s for s in segs if s["side"] == "outer"
                and s["t0"] - _KNOT_TOL <= mid <= s["t1"] + _KNOT_TOL]
        if not outs:
            raise ValueError(
                f"outer envelope gap over z=[{a - t_min:.4f}, {b - t_min:.4f}] — "
                "profile would be open"
            )
        outer_iv.append(max(outs, key=lambda s: _r_at(s, mid)))
        ins = [s for s in segs if s["side"] == "inner"
               and s["t0"] - _KNOT_TOL <= mid <= s["t1"] + _KNOT_TOL]
        inner_iv.append(min(ins, key=lambda s: _r_at(s, mid)) if ins else None)

    outer_pts = _boundary_chain(intervals, outer_iv)
    inner_pts = _boundary_chain(intervals, inner_iv)

    # z_rel = t - t_min so the profile starts at 0 (world placement is a translate)
    for pt in outer_pts + inner_pts:
        pt[1] -= t_min

    # Pappus self-check: V = 2π · r̄ · A must equal the exact B-rep volume.
    loop = [(r, z) for r, z, _ in inner_pts] + [(r, z) for r, z, _ in reversed(outer_pts)]
    area, cx = _polygon_area_centroid(loop)
    volume = abs(2.0 * math.pi * cx * area)
    body_vol = float(body.get("volume", 0.0))
    vol_err = abs(volume - body_vol) / body_vol if body_vol else 0.0
    if body_vol and vol_err > _PAPPUS_TOL:
        raise ValueError(
            f"Pappus volume check failed: profile gives {volume:.2f} mm³ vs "
            f"exact B-rep {body_vol:.2f} mm³ ({vol_err:+.1%})"
        )

    p0 = o + (t_min - float(np.dot(o, d))) * d  # world point: axis low end
    return {
        "axis_origin": o,
        "axis_dir": d,
        "t_min": t_min,
        "height": t_max - t_min,
        "planes": [{"t": p["t"] - t_min, "faces": p["faces"]} for p in planes],
        "segments": segs,
        "outer_intervals": outer_iv,
        "inner_intervals": inner_iv,
        "inner": inner_pts,  # [(r, z_rel, seg)] ascending z
        "outer": outer_pts,
        "world_base": p0,
        "pappus_volume": volume,
        "body_volume": body_vol,
    }


# --------------------------------------------------------------------------
# variable naming: exact B-rep values -> readable named parameters
# --------------------------------------------------------------------------

def _seq_of(chosen: list[dict | None]) -> list[dict | None]:
    """Interval-ordered segment sequence with consecutive duplicates removed."""
    seq: list[dict | None] = []
    for s in chosen:
        if not seq or s is not seq[-1]:
            seq.append(s)
    return seq


def _faces_txt(faces: list[int]) -> str:
    return "/".join(f"#{i}" for i in faces)


def _name_variables(prof: dict) -> dict:
    """Assign readable names to the profile's exact B-rep dimensions.

    Returns {"vars": [(name, value, comment)], "r_vars", "z_vars", "chams",
    "seg_name": {id(seg): radius-var name}}.
    """
    H = prof["height"]
    t_min = prof["t_min"]
    vars_out: list[tuple[str, float, str]] = []
    r_vars: list[tuple[str, float]] = []
    z_vars: list[tuple[str, float]] = [("0", 0.0)]
    seg_name: dict[int, str] = {}

    # -- cylinder radii, grouped per side by exact radius --------------------
    def _cyl_groups(side: str) -> list[dict]:
        groups: dict[float, dict] = {}
        for s in prof["segments"]:
            if s["kind"] != "cyl" or s["side"] != side:
                continue
            key = round(s["r0"], 6)
            g = groups.setdefault(key, {"r": s["r0"], "segs": [], "faces": [],
                                        "lo": s["t0"], "hi": s["t1"], "extent": 0.0})
            g["segs"].append(s)
            g["faces"] = sorted(set(g["faces"] + s["faces"]))
            g["lo"], g["hi"] = min(g["lo"], s["t0"]), max(g["hi"], s["t1"])
            g["extent"] += s["t1"] - s["t0"]
        return list(groups.values())

    inner_groups = sorted(_cyl_groups("inner"), key=lambda g: g["r"])
    for i, g in enumerate(inner_groups):
        name = ("bore_r" if i == 0 else "cbore_r" if i == 1 and len(inner_groups) == 2
                else f"inner{i + 1}_r")
        vars_out.append((name, g["r"],
                         f"exact B-rep: cylinder face(s) {_faces_txt(g['faces'])} radius "
                         "(reversed -> bore)"))
        r_vars.append((name, g["r"]))
        for s in g["segs"]:
            seg_name[id(s)] = name

    outer_groups = _cyl_groups("outer")
    flange_group = None
    if not outer_groups:
        ordered = []  # outer envelope is all cones/arcs (taper/fillet-only wall)
    elif len(outer_groups) == 1:
        ordered = [("od_r", outer_groups[0])]
    elif len(outer_groups) == 2:
        outer_groups.sort(key=lambda g: g["r"])
        big = outer_groups[1]
        at_end = (abs(big["lo"] - t_min) < _KNOT_TOL
                  or abs(big["hi"] - (t_min + H)) < _KNOT_TOL)
        flange_group = big if at_end else None
        ordered = [("od_r", outer_groups[0]),
                   ("flange_r" if at_end else "step1_r", big)]
    else:
        outer_groups.sort(key=lambda g: -g["extent"])
        ordered = [("od_r", outer_groups[0])] + [
            (f"step{i}_r", g) for i, g in enumerate(outer_groups[1:], start=1)
        ]
    for name, g in ordered:
        vars_out.append((name, g["r"],
                         f"exact B-rep: cylinder face(s) {_faces_txt(g['faces'])} radius"))
        r_vars.append((name, g["r"]))
        for s in g["segs"]:
            seg_name[id(s)] = name

    # -- axial extents --------------------------------------------------------
    all_faces = sorted({i for s in prof["segments"] for i in s["faces"]})
    vars_out.append(("total_h", H,
                     "exact B-rep: axial extent of the coaxial faces "
                     f"{_faces_txt(all_faces)} (v-ranges)"))
    z_vars.append(("total_h", H))

    used_plane_z: set[float] = set()
    if flange_group is not None:
        at_bottom = abs(flange_group["lo"] - t_min) < _KNOT_TOL
        fh = (flange_group["hi"] - t_min) if at_bottom else (t_min + H - flange_group["lo"])
        fz = fh if at_bottom else H - fh
        plane_here = [p for p in prof["planes"] if abs(p["t"] - fz) < _KNOT_TOL]
        prov = (f" (plane face(s) {_faces_txt(plane_here[0]['faces'])} step)"
                if plane_here else "")
        vars_out.append(("flange_h", fh,
                         "exact B-rep: flange band height, cylinder face(s) "
                         f"{_faces_txt(flange_group['faces'])} axial extent{prov}"))
        z_vars.append(("flange_h" if at_bottom else "total_h - flange_h", fz))
        if not at_bottom:
            # store as derived anchor: name carries the expression directly
            z_vars[-1] = ("total_h - flange_h", fz)
        used_plane_z.add(round(fz, 6))

    step_i = 1
    for p in sorted(prof["planes"], key=lambda p: p["t"]):
        z = p["t"]
        if z < _KNOT_TOL or z > H - _KNOT_TOL or round(z, 6) in used_plane_z:
            continue
        name = f"z_step{step_i}"
        step_i += 1
        vars_out.append((name, z,
                         f"exact B-rep: plane face(s) {_faces_txt(p['faces'])} height "
                         "above the base"))
        z_vars.append((name, z))
        used_plane_z.add(round(z, 6))

    # -- chamfers / tapers from cone segments ---------------------------------
    chams: list[dict] = []
    used_names = {n for n, _, _ in vars_out}
    for side in ("outer", "inner"):
        chosen = prof["outer_intervals"] if side == "outer" else prof["inner_intervals"]
        seq = _seq_of(chosen)
        for i, s in enumerate(seq):
            if s is None or s["kind"] != "cone":
                continue
            below = next((seg_name.get(id(q)) for q in reversed(seq[:i])
                          if q is not None and id(q) in seg_name), None)
            above = next((seg_name.get(id(q)) for q in seq[i + 1:]
                          if q is not None and id(q) in seg_name), None)
            strip = lambda n: n[:-2] if n and n.endswith("_r") else n
            if below and above:
                name = f"{strip(below)}_{strip(above)}_cham"
            elif above:
                name = f"{strip(above)}_bot_cham"
            elif below:
                name = f"{strip(below)}_top_cham"
            else:
                name = f"cham{len(chams) + 1}"
            while name in used_names:
                name += "_b"
            used_names.add(name)
            w = abs(s["r1"] - s["r0"])
            h = s["t1"] - s["t0"]
            ang = s["meta"].get("half_angle_deg")
            vars_out.append((name, w,
                             f"exact B-rep: cone face(s) {_faces_txt(s['faces'])} "
                             f"({_fmt(ang)}° half-angle) radial width"
                             + (" = axial height (45°)" if abs(h - w) < _VAL_TOL else "")))
            rec = {"name": name, "w": w, "h": h, "hname": name, "side": side,
                   "faces": s["faces"], "z0": s["t0"] - prof["t_min"],
                   "z1": s["t1"] - prof["t_min"]}
            if abs(h - w) > _VAL_TOL:
                hname = f"{name}_h"
                vars_out.append((hname, h,
                                 f"exact B-rep: cone face(s) {_faces_txt(s['faces'])} "
                                 "axial height"))
                rec["hname"] = hname
            chams.append(rec)

    return {"vars": vars_out, "r_vars": r_vars, "z_vars": z_vars,
            "chams": chams, "seg_name": seg_name}


# --------------------------------------------------------------------------
# vertex expressions: reference the named variables, not magic numbers
# --------------------------------------------------------------------------

def _ordered_chams(chams: list[dict], seg: dict | None, z: float) -> list[dict]:
    """Chamfer vars ranked by relevance to this vertex: same face first, then
    the cone that spans this z, then same-side, then the rest."""
    def score(c: dict) -> tuple:
        same_face = bool(seg is not None and set(c["faces"]) & set(seg["faces"]))
        touches = c["z0"] - _KNOT_TOL <= z <= c["z1"] + _KNOT_TOL
        same_side = seg is not None and c["side"] == seg["side"]
        return (not same_face, not touches, not same_side)
    return sorted(chams, key=score)


def _r_expr(r: float, seg: dict | None, z: float, names: dict) -> str:
    for name, val in names["r_vars"]:
        if abs(r - val) < _VAL_TOL:
            return name
    for c in _ordered_chams(names["chams"], seg, z):
        for name, val in names["r_vars"]:
            if abs(r - (val + c["w"])) < _VAL_TOL:
                return f"{name} + {c['name']}"
            if abs(r - (val - c["w"])) < _VAL_TOL:
                return f"{name} - {c['name']}"
    return _fmt(r)


def _z_expr(z: float, seg: dict | None, names: dict) -> str:
    for name, val in names["z_vars"]:
        if abs(z - val) < _VAL_TOL:
            return name
    for c in _ordered_chams(names["chams"], seg, z):
        for name, val in names["z_vars"]:
            if abs(z - (val + c["h"])) < _VAL_TOL:
                return c["hname"] if name == "0" else f"{name} + {c['hname']}"
            if abs(z - (val - c["h"])) < _VAL_TOL and name != "0":
                return f"{name} - {c['hname']}"
    return _fmt(z)


# --------------------------------------------------------------------------
# emitter
# --------------------------------------------------------------------------

def _vertex_comment(seg: dict | None) -> str:
    if seg is None:
        return "on the revolution axis (no inner face here)"
    return f"{seg['kind']} face(s) {_faces_txt(seg['faces'])}"


def emit_revolve_body(
    body: dict,
    cls: dict,
    lines: list[str],
    prefix: str = "",
    overrides: list[dict] | None = None,
) -> str:
    """Emit one rotational body as rotate_extrude of its exact RZ profile.

    `overrides`: optional refine-loop corrections, each
    {"boundary": "outer"|"inner", "z0": .., "z1": .., "dr": ..} in profile-z
    (mm from the base). Matching vertices get r += dr and are emitted as
    literals tagged REFINED. Returns the emitted module name.
    """
    bid = body["id"]
    prof = build_profile(body, cls)
    names = _name_variables(prof)
    d = prof["axis_dir"]
    p0 = prof["world_base"]

    refined: dict[int, float] = {}  # id(point row) -> total dr applied
    for ov in overrides or []:
        pts = prof["inner"] if ov["boundary"] == "inner" else prof["outer"]
        for pt in pts:
            if ov["z0"] - _KNOT_TOL <= pt[1] <= ov["z1"] + _KNOT_TOL:
                pt[0] += ov["dr"]
                refined[id(pt)] = refined.get(id(pt), 0.0) + ov["dr"]

    lines.append(f"// ---- body {bid} (strategy: rotate_extrude — exact RZ profile) ----")
    lines.append(
        f"// revolution axis: through [{', '.join(_fmt(v) for v in p0)}] along "
        f"[{', '.join(_fmt(v) for v in d)}]; profile z measured from the axis low end"
    )
    lines.append(
        f"// Pappus check: profile revolves to {prof['pappus_volume']:.2f} mm³ vs "
        f"exact B-rep volume {prof['body_volume']:.2f} mm³"
    )
    width = max(len(prefix + n) for n, _, _ in names["vars"]) + 1
    for name, value, comment in names["vars"]:
        lines.append(f"{(prefix + name).ljust(width)}= {_fmt(value)};  // {comment}")
    lines.append(f"{(prefix + 'fn').ljust(width)}= {_FN};  // rotate_extrude curve resolution")
    lines.append("")

    def pref_expr(expr: str) -> str:
        """Token-wise prefixing of known variable names inside an expression."""
        if not prefix:
            return expr
        tokens = expr.split(" ")
        known = {n for n, _, _ in names["vars"]}
        return " ".join(prefix + t if t in known else t for t in tokens)

    lines.append(f"module body_{bid}() {{")
    place = ""
    if float(np.linalg.norm(p0)) > 1e-9:
        place += f"translate([{', '.join(_fmt(v) for v in p0)}]) "
    place += _orient_snippet(d)
    lines.append(f"    // closed RZ boundary loop: up the bore, across the top,")
    lines.append(f"    // down the outside, across the bottom (ring -> through-bore)")
    lines.append(f"    {place}rotate_extrude($fn = {prefix}fn)")
    lines.append("        polygon(points = [")
    rows: list[tuple[str, str]] = []
    for pt in prof["inner"] + list(reversed(prof["outer"])):
        r, z, seg = pt
        if id(pt) in refined:
            expr = f"[{_fmt(r)}, {_fmt(z)}]"
            comment = (f"REFINED dr={_fmt(refined[id(pt)])} (residual-driven fix); "
                       f"was {_vertex_comment(seg)}")
        else:
            expr = f"[{pref_expr(_r_expr(r, seg, z, names))}, {pref_expr(_z_expr(z, seg, names))}]"
            comment = _vertex_comment(seg)
        rows.append((expr, comment))
    w = max(len(e) for e, _ in rows) + 1
    for i, (expr, comment) in enumerate(rows):
        sep = "," if i < len(rows) - 1 else " "
        lines.append(f"            {(expr + sep).ljust(w + 1)}  // {comment}")
    lines.append("        ]);")
    lines.append("}")
    return f"body_{bid}"
