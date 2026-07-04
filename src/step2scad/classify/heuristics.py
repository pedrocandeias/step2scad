"""Stage 2: CLASSIFY — pick a reconstruction strategy per body.

First-pass heuristics over the ingested (exact) face data:

    rotate_extrude — the rotational faces (cylinder/cone/torus) overwhelmingly
                     share one axis, and the planar faces are caps normal to it
    linear_extrude — two parallel planar caps dominate and every side face is
                     a plane parallel to — or a cylinder with axis along — the
                     cap normal (constant cross-section)
    csg            — analytic surfaces (planes/cylinders/…) but no single
                     dominant axis: reconstruct as a CSG primitive assembly
    freeform       — a significant share of the surface is B-spline/Bezier:
                     loft/polyhedron fallback for those regions

Each decision is recorded with a human-readable `reasoning` string so the
choice can be audited against features.json.
"""

from __future__ import annotations

import numpy as np

# A face's axis is "the same" as another if directions are parallel within
# this angular tolerance and the axis lines are closer than the radial tol.
_PARALLEL_TOL = 1e-4
_COAXIAL_DIST_TOL = 1e-3  # mm

_ROTATIONAL_TYPES = {"cylinder", "cone", "torus"}
_FREEFORM_TYPES = {"bspline", "bezier", "revolution", "extrusion", "offset", "other"}


def _axis_of(face: dict):
    p = face.get("params", {})
    if "axis_dir" in p:
        return np.asarray(p["axis_origin"], float), np.asarray(p["axis_dir"], float)
    return None


def _same_axis(o1, d1, o2, d2) -> bool:
    if abs(abs(float(np.dot(d1, d2))) - 1.0) > _PARALLEL_TOL:
        return False
    # distance from o2 to the line (o1, d1)
    w = o2 - o1
    return float(np.linalg.norm(w - np.dot(w, d1) * d1)) < _COAXIAL_DIST_TOL


def _cluster_axes(faces: list[dict]) -> list[dict]:
    """Group rotational faces by shared axis; return clusters sorted by area."""
    clusters: list[dict] = []
    for f in faces:
        if f["type"] not in _ROTATIONAL_TYPES:
            continue
        ax = _axis_of(f)
        if ax is None:
            continue
        o, d = ax
        d = d / np.linalg.norm(d)
        for c in clusters:
            if _same_axis(c["origin"], c["dir"], o, d):
                c["faces"].append(f["index"])
                c["area"] += f["area"]
                break
        else:
            clusters.append({"origin": o, "dir": d, "faces": [f["index"]], "area": f["area"]})
    clusters.sort(key=lambda c: -c["area"])
    return clusters


def classify_body(body: dict) -> dict:
    faces = body["faces"]
    total_area = sum(f["area"] for f in faces) or 1.0
    area_by_type = body.get("surface_area_by_type", {})

    freeform_area = sum(area_by_type.get(t, 0.0) for t in _FREEFORM_TYPES)
    freeform_frac = freeform_area / total_area

    clusters = _cluster_axes(faces)
    dominant = clusters[0] if clusters else None

    result: dict = {"body_id": body["id"], "strategy": "csg", "reasoning": ""}

    # 1. Free-form dominated -> loft/polyhedron territory
    if freeform_frac > 0.25:
        result["strategy"] = "freeform"
        result["reasoning"] = (
            f"{freeform_frac:.0%} of surface area is free-form "
            f"(bspline/bezier/…) — loft or polyhedron fallback for those regions."
        )
        return result

    # 2. Rotationally symmetric about one axis -> rotate_extrude
    if dominant is not None:
        axis_dir = dominant["dir"]
        coaxial_frac = dominant["area"] / total_area
        # planar caps must be normal to the axis (their normal parallel to it)
        plane_ok_area = plane_area = 0.0
        for f in faces:
            if f["type"] != "plane":
                continue
            plane_area += f["area"]
            n = np.asarray(f["params"]["normal"], float)
            if abs(abs(float(np.dot(n, axis_dir))) - 1.0) < 1e-3:
                plane_ok_area += f["area"]
        sphere_area = area_by_type.get("sphere", 0.0)  # spheres are axis-agnostic
        conforming = (dominant["area"] + plane_ok_area + sphere_area) / total_area
        if coaxial_frac > 0.45 and conforming > 0.95:
            result["strategy"] = "rotate_extrude"
            result["reasoning"] = (
                f"{coaxial_frac:.0%} of area is rotational faces sharing one axis "
                f"(dir {np.round(axis_dir, 6).tolist()}, {len(dominant['faces'])} faces); "
                f"{conforming:.0%} of all area conforms to that axis "
                f"(incl. planar caps normal to it) -> RZ profile rotate_extrude."
            )
            result["axis"] = {
                "origin": dominant["origin"].tolist(),
                "dir": axis_dir.tolist(),
            }
            return result

    # 3. Prismatic: parallel planar caps + side faces along the cap normal
    planes = [f for f in faces if f["type"] == "plane"]
    for cap in sorted(planes, key=lambda f: -f["area"]):
        n = np.asarray(cap["params"]["normal"], float)
        cap_area = sum(
            f["area"]
            for f in planes
            if abs(abs(float(np.dot(np.asarray(f["params"]["normal"], float), n))) - 1.0) < 1e-3
        )
        side_ok = 0.0
        for f in faces:
            if f["type"] == "plane":
                fn = np.asarray(f["params"]["normal"], float)
                if abs(float(np.dot(fn, n))) < 1e-3:  # wall parallel to extrude dir
                    side_ok += f["area"]
            elif f["type"] in _ROTATIONAL_TYPES:
                ax = _axis_of(f)
                if ax is not None and abs(abs(float(np.dot(ax[1], n))) - 1.0) < 1e-3:
                    side_ok += f["area"]
        if (cap_area + side_ok) / total_area > 0.98 and cap_area / total_area > 0.2:
            result["strategy"] = "linear_extrude"
            result["reasoning"] = (
                f"planar caps normal to {np.round(n, 6).tolist()} cover "
                f"{cap_area / total_area:.0%} of area and all side faces run along "
                f"that direction ({(cap_area + side_ok) / total_area:.0%} conforming) "
                f"-> constant section linear_extrude."
            )
            result["axis"] = {"dir": n.tolist()}
            return result

    # 4. Fallback: analytic primitive assembly
    result["strategy"] = "csg"
    dom_txt = (
        f"largest coaxial cluster covers only {dominant['area'] / total_area:.0%}"
        if dominant is not None
        else "no rotational faces"
    )
    result["reasoning"] = (
        f"analytic surfaces ({', '.join(sorted(body['surface_type_counts']))}) with no "
        f"single dominant axis ({dom_txt}) and no prismatic direction -> CSG assembly "
        f"of primitives with chamfers (cones) / fillets (tori)."
    )
    return result


def classify_bodies(features: dict) -> dict:
    return {
        "source": features.get("source", ""),
        "bodies": [classify_body(b) for b in features["bodies"]],
    }
