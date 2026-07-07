"""BODY REPORT — deterministic plan-authoring digest of a features.json.

The raw features.json is exact but verbose (one record per face). This tool
aggregates it into the compact facts an agent needs to AUTHOR a plan (rule 7:
scripts produce the facts, the agent judges them):

  - planes grouped by normal direction, coplanar faces merged, sorted by
    offset along the normal  -> slab thicknesses / wall positions read off
  - cylinders clustered by axis (same clustering as classify) with exact
    radius, world extent along the axis, full/partial arc, bore-vs-boss
  - cones / tori / spheres listed with exact params
  - bspline faces with degrees/pole counts + their neighbor faces and edge
    convexity (usually enough to see what a ruled 'blend' face is bridging)
  - body summary: volume, centroid, bbox, per-type area shares

Usage:
    PYTHONPATH=src python3 -m step2scad.report output/<slug>/features.json [--body N]

Output: one JSON object on stdout (lengths mm, areas mm², volumes mm³).
"""

from __future__ import annotations

import argparse
import json
import math
import sys
from pathlib import Path

import numpy as np

_PARALLEL_TOL = 1e-4
_COAXIAL_DIST_TOL = 1e-3  # mm
_OFFSET_TOL = 1e-6  # mm: coplanar merge
_FULL_ARC_TOL = 1e-6  # rad


def _r6(x) -> float:
    return round(float(x), 6)


def _v6(v) -> list[float]:
    return [_r6(x) for x in v]


def _group_planes(faces: list[dict]) -> list[dict]:
    """Group plane faces by (signed) normal; merge coplanar faces."""
    groups: list[dict] = []
    for f in faces:
        if f["type"] != "plane":
            continue
        n = np.asarray(f["params"]["normal"], float)
        n = n / np.linalg.norm(n)
        offset = float(np.dot(n, np.asarray(f["params"]["origin"], float)))
        for g in groups:
            if float(np.dot(g["_n"], n)) > 1.0 - _PARALLEL_TOL:
                g["_entries"].append((offset, f))
                break
        else:
            groups.append({"_n": n, "_entries": [(offset, f)]})

    out = []
    for g in groups:
        planes: list[dict] = []
        for offset, f in sorted(g["_entries"], key=lambda e: e[0]):
            for p in planes:
                if abs(p["offset"] - offset) < _OFFSET_TOL:
                    p["faces"].append(f["index"])
                    p["area"] = _r6(p["area"] + f["area"])
                    break
            else:
                planes.append({
                    "offset": _r6(offset),
                    "area": _r6(f["area"]),
                    "faces": [f["index"]],
                })
        out.append({
            "normal": _v6(g["_n"]),
            "total_area": _r6(sum(p["area"] for p in planes)),
            "planes": planes,
        })
    out.sort(key=lambda g: -g["total_area"])
    return out


def _cluster_cylinders(faces: list[dict]) -> list[dict]:
    """Cylinder faces clustered by axis line; world extent from exact v-ranges."""
    clusters: list[dict] = []
    for f in faces:
        if f["type"] != "cylinder":
            continue
        p = f["params"]
        o = np.asarray(p["axis_origin"], float)
        d = np.asarray(p["axis_dir"], float)
        d = d / np.linalg.norm(d)
        for c in clusters:
            if (abs(abs(float(np.dot(c["_d"], d))) - 1.0) < _PARALLEL_TOL
                    and float(np.linalg.norm((o - c["_o"])
                              - np.dot(o - c["_o"], c["_d"]) * c["_d"])) < _COAXIAL_DIST_TOL):
                c["_faces"].append(f)
                break
        else:
            clusters.append({"_o": o, "_d": d, "_faces": [f]})

    out = []
    for c in clusters:
        d = c["_d"]
        # canonical sign: dominant component positive
        if d[int(np.argmax(np.abs(d)))] < 0:
            d = -d
        walls = []
        t_lo, t_hi = math.inf, -math.inf
        for f in c["_faces"]:
            p = f["params"]
            fo = np.asarray(p["axis_origin"], float)
            fd = np.asarray(p["axis_dir"], float)
            fd = fd / np.linalg.norm(fd)
            base = float(np.dot(fo, d))
            sign = float(np.sign(np.dot(fd, d))) or 1.0
            ts = sorted(base + sign * v for v in f["v_range"])
            t_lo, t_hi = min(t_lo, ts[0]), max(t_hi, ts[1])
            u0, u1 = f["u_range"]
            walls.append({
                "face": f["index"],
                "radius": _r6(p["radius"]),
                "kind": "bore" if f["orientation"] == "reversed" else "boss",
                "extent": [_r6(ts[0]), _r6(ts[1])],
                "arc_deg": _r6(math.degrees(abs(u1 - u0))),
                "full_circle": abs(abs(u1 - u0) - 2 * math.pi) < 1e-3,
                "area": _r6(f["area"]),
            })
        walls.sort(key=lambda w: (w["extent"][0], w["radius"]))
        # a point on the axis at the low end of the cluster extent
        o = c["_o"]
        p_lo = o + (t_lo - float(np.dot(o, d))) * d
        out.append({
            "axis_dir": _v6(d),
            "axis_point_at_extent_lo": _v6(p_lo),
            "extent_along_dir": [_r6(t_lo), _r6(t_hi)],
            "total_area": _r6(sum(w["area"] for w in walls)),
            "walls": walls,
        })
    out.sort(key=lambda c: -c["total_area"])
    return out


def _list_simple(faces: list[dict], ftype: str, fields: dict) -> list[dict]:
    out = []
    for f in faces:
        if f["type"] != ftype:
            continue
        rec = {"face": f["index"], "area": _r6(f["area"]),
               "orientation": f["orientation"]}
        for key, param in fields.items():
            val = f["params"].get(param)
            rec[key] = _v6(val) if isinstance(val, list) else (_r6(val) if val is not None else None)
        rec["v_range"] = _v6(f["v_range"])
        rec["u_range"] = _v6(f["u_range"])
        out.append(rec)
    return out


def _bsplines(faces: list[dict]) -> list[dict]:
    out = []
    for f in faces:
        if f["type"] not in ("bspline", "bezier"):
            continue
        out.append({
            "face": f["index"],
            "area": _r6(f["area"]),
            "params": f.get("params", {}),
            "neighbors": [
                {"face": nb["face"], "type_hint": nb.get("edge_type"),
                 "convexity": nb.get("convexity")}
                for nb in f.get("neighbors", [])
            ],
        })
    return out



def _round_regions(faces: list[dict], band_axis: str = "z") -> list[dict]:
    """Families of coaxial cylinder faces whose axis is PERPENDICULAR to the
    banding axis — regions a slab-stack strategy would slice into "slopes".

    Lesson from Palm_left (author-spotted): the knuckle posts and rear ears
    were exact x-axis r6.000/r8.000 cylinders, band-stacked into staircases
    because authoring fit the tessellation instead of reading this list.
    These regions must be cross-axis extrudes / law-solids, never bands.
    """
    import numpy as np
    bi = "xyz".index(band_axis)
    fams: dict[tuple, dict] = {}
    for f in faces:
        if f["type"] != "cylinder":
            continue
        ax = np.asarray(f["params"]["axis_dir"], float)
        if abs(ax[bi]) > 0.05:                    # not perpendicular to bands
            continue
        o = np.asarray(f["params"]["axis_origin"], float)
        # family key: axis direction + the axis line's position in the plane
        # perpendicular to it + radius
        axk = tuple(np.round(np.abs(ax), 3))
        perp = o - (o @ ax) * ax
        key = (axk, tuple(np.round(perp, 2)), round(f["params"]["radius"], 3))
        fam = fams.setdefault(key, {"axis_dir": _v6(ax), "radius":
                                    _r6(f["params"]["radius"]),
                                    "line_point": _v6(perp), "faces": [],
                                    "area": 0.0})
        fam["faces"].append(f["index"])
        fam["area"] += float(f.get("area", 0.0))
    out = [fam for fam in fams.values() if fam["area"] > 5.0]
    out.sort(key=lambda q: -q["area"])
    for fam in out:
        fam["area"] = _r6(fam["area"])
        fam["warning"] = ("cross-axis round feature: a band/slab stack along "
                          f"'{band_axis}' would staircase this — reconstruct "
                          "as a cross-axis extrude with the exact arc, or a "
                          "law-solid")
    return out


def unclaimed_faces(features_body: dict, plan_entry: dict,
                    min_area: float = 3.0) -> list[dict]:
    """Coverage audit: exact analytic faces NOT cited by any plan provenance.

    Plans cite the faces they exploit as '#N' in `source` strings; every
    analytic face (plane/cylinder/cone/sphere/torus) with meaningful area
    that no source cites is unexploited primitive potential — group and rank
    them. (Lesson: the author kept spotting exact geometry — palm posts,
    ears, fin sockets — that authoring left under band approximations.)
    """
    import re

    cited: set[int] = set()

    def walk(n):
        if isinstance(n, dict):
            for k, v in n.items():
                if k in ("source", "doc", "notes") and isinstance(v, str):
                    cited.update(int(m) for m in re.findall(r"#(\d+)", v))
                else:
                    walk(v)
        elif isinstance(n, list):
            for v in n:
                walk(v)

    walk(plan_entry)
    out = []
    for f in features_body["faces"]:
        if f["type"] == "bspline" or f["index"] in cited:
            continue
        if float(f.get("area", 0.0)) < min_area:
            continue
        p = f.get("params", {})
        out.append({"index": f["index"], "type": f["type"],
                    "area": _r6(f.get("area", 0.0)),
                    "radius": _r6(p["radius"]) if "radius" in p else None,
                    "origin": _v6(p.get("axis_origin", p.get("origin",
                                        [0, 0, 0]))),
                    "axis": _v6(p.get("axis_dir", p.get("normal",
                                      [0, 0, 0])))})
    out.sort(key=lambda q: -q["area"])
    return out

def body_report(body: dict) -> dict:
    faces = body["faces"]
    total_area = sum(f["area"] for f in faces) or 1.0
    return {
        "body_id": body["id"],
        "volume": _r6(body["volume"]),
        "centroid": _v6(body["centroid"]),
        "bbox": {"min": _v6(body["bbox"]["min"]), "max": _v6(body["bbox"]["max"]),
                 "size": _v6(np.asarray(body["bbox"]["max"])
                             - np.asarray(body["bbox"]["min"]))},
        "n_faces": body["n_faces"],
        "area_share_by_type": {
            k: _r6(v / total_area)
            for k, v in sorted(body["surface_area_by_type"].items(),
                               key=lambda kv: -kv[1])
        },
        "plane_groups": _group_planes(faces),
        "cylinder_clusters": _cluster_cylinders(faces),
        "round_regions_perp_z": _round_regions(faces, "z"),
        "cones": _list_simple(faces, "cone", {
            "axis_origin": "axis_origin", "axis_dir": "axis_dir",
            "half_angle_deg": "half_angle_deg", "ref_radius": "ref_radius",
            "apex": "apex"}),
        "tori": _list_simple(faces, "torus", {
            "axis_origin": "axis_origin", "axis_dir": "axis_dir",
            "major_radius": "major_radius", "minor_radius": "minor_radius"}),
        "spheres": _list_simple(faces, "sphere", {"center": "center", "radius": "radius"}),
        "bsplines": _bsplines(faces),
    }


def main(argv: list[str] | None = None) -> int:
    ap = argparse.ArgumentParser(
        prog="step2scad.report",
        description="Compact plan-authoring digest of a features.json.")
    ap.add_argument("features", help="path to features.json")
    ap.add_argument("--body", type=int, default=None, help="only this body id")
    args = ap.parse_args(argv)

    data = json.loads(Path(args.features).read_text())
    bodies = data["bodies"]
    if args.body is not None:
        bodies = [b for b in bodies if b["id"] == args.body]
        if not bodies:
            print(json.dumps({"error": f"no body with id {args.body}"}))
            return 1
    print(json.dumps({
        "source": data.get("source", ""),
        "n_bodies": data.get("n_bodies", len(data["bodies"])),
        "bodies": [body_report(b) for b in bodies],
    }, indent=1))
    return 0


if __name__ == "__main__":
    sys.exit(main())
