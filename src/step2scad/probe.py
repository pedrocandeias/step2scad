"""GEOMETRY PROBE — on-demand exact-answer queries against a model.

The reconstruction agent is blind to 3D: it reads numbers and 2D PNGs. This
tool is its active perception: ask a precise geometric question, get a precise
JSON answer (plus an optional section PNG when a slice needs to be *seen*).

    PYTHONPATH=src python3 -m step2scad.probe <model> <query> [args...] [--json] [--png PATH]
    python3 scripts/probe.py <model> <query> [args...]            # no-install form

<model> is a `.step`/`.stp` (tessellated via ingest, CACHED in tmp/probe/cache
keyed by path+mtime+size so repeat probes are near-instant), a `.stl` (loaded
directly), or a `.scad` (rendered to STL via OpenSCAD, also cached).

Queries (all output one JSON object on stdout; lengths in mm, areas mm²,
volumes mm³):

    contains X Y Z
        Is there material at this exact point?
        -> {"point": [...], "inside": true}

    raycast OX OY OZ DX DY DZ
        Shoot a ray from (OX,OY,OZ) along (DX,DY,DZ); every surface hit in
        order, plus the material/void segments between consecutive hits
        (-> wall thickness, bore diameter, gap size read directly).
        -> {"n_hits": 4, "hits": [{"t": ..., "point": [...]}, ...],
            "segments": [{"t0":..,"t1":..,"length":..,"material":true}, ...]}

    distance X Y Z
        Nearest-surface distance from a point (+ signed convention: positive
        = inside the solid, negative = outside), and the nearest point.
        -> {"distance": .., "signed": .., "inside": bool, "nearest_point": [...]}

    section AXIS COORD [--png [PATH]]
        Cross-section on the plane AXIS=x|y|z at COORD.
        -> {"area": .., "perimeter": .., "n_loops": .., "n_regions": ..,
            "bounds": {"min": [...], "max": [...]}}
        --png saves a clean 2D outline plot of the slice.

    area AXIS COORD
        Fast path: just the cross-section area. -> {"area": ..}

    bbox      -> {"min": [...], "max": [...], "extents": [...], "center": [...]}
    volume    -> {"volume": .., "is_watertight": bool}
    massprops -> volume, surface area, centroid, principal axes + moments,
                 bbox, watertightness, body count

    slices AXIS N [--png [PATH]]
        N evenly spaced cross-sections along AXIS: the area curve.
        -> {"axis": "z", "coords": [...], "areas": [...], ...}
        --png tiles all N slice outlines into ONE montage image (shared
        in-plane axes so relative slice sizes are visually comparable).

    nearest-feature X Y Z
        Bridge to the EXACT B-rep: the analytic face nearest the point with
        its exact CAD parameters (type, radius, axis, normal...). Requires the
        model to be a STEP, or a features.json next to the model file.
        STEP path: OCC BRepExtrema against the real B-rep (exact, bounded
        faces; the parsed shape is cached as .brep in tmp/probe/cache).
        features.json path: unbounded analytic distance per face, top-3 shown.
        -> {"distance": .., "nearest_point": [...],
            "face": {"body": 0, "index": 7, "type": "cylinder",
                     "params": {"radius": 2.5, "axis_dir": [...], ...}}}

    compare MODEL_B
        Quick recon-vs-original check between <model> and MODEL_B (either may
        be .step/.stl/.scad): aligned boolean IoU (reuses eval) + surface-
        distance stats (Hausdorff / mean / p95).
        -> {"iou": .., "alignment": .., "surface_distance": {...}, ...}

Examples:
    python3 scripts/probe.py models/F695-2Z.step section z 0.5 --png
    python3 scripts/probe.py models/F695-2Z.step raycast -10 0 2 1 0 0
    python3 scripts/probe.py models/F695-2Z.step nearest-feature 2.5 0 2
    python3 scripts/probe.py output/F695-2Z/F695-2Z.scad compare models/F695-2Z.step
    python3 scripts/probe.py models/e_nable_phoenix_hand_v3.step slices z 12 --png

PNGs default to tmp/probe/; all cache artefacts live in tmp/probe/cache.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import math
import sys
from pathlib import Path

import numpy as np
import trimesh

_REPO_ROOT = Path(__file__).resolve().parents[2]
_PROBE_TMP = _REPO_ROOT / "tmp" / "probe"
_CACHE_DIR = _PROBE_TMP / "cache"

_AXES = {"x": 0, "y": 1, "z": 2}
_HIT_DEDUPE_TOL = 1e-6  # mm; merges duplicate ray hits on shared triangle edges


# --------------------------------------------------------------------------
# Model loading + tessellation cache
# --------------------------------------------------------------------------

def _cache_key(path: Path) -> str:
    st = path.stat()
    raw = f"{path.resolve()}|{st.st_mtime_ns}|{st.st_size}"
    return hashlib.sha1(raw.encode()).hexdigest()[:16]


def _cached_stl(path: Path) -> Path:
    return _CACHE_DIR / f"{path.stem}-{_cache_key(path)}.stl"


def load_mesh(model: str | Path) -> trimesh.Trimesh:
    """Load .step/.stp (tessellate, cached), .stl (direct), .scad (render, cached)."""
    path = Path(model)
    if not path.is_file():
        raise FileNotFoundError(f"model not found: {path}")
    suffix = path.suffix.lower()

    if suffix == ".stl":
        return trimesh.load(path, force="mesh")

    if suffix in (".step", ".stp"):
        cached = _cached_stl(path)
        if cached.is_file():
            return trimesh.load(cached, force="mesh")
        from step2scad.ingest import read_step, shape_to_trimesh

        mesh = shape_to_trimesh(read_step(path))
        _CACHE_DIR.mkdir(parents=True, exist_ok=True)
        mesh.export(cached)
        return mesh

    if suffix == ".scad":
        cached = _cached_stl(path)
        if not cached.is_file():
            from step2scad.render import find_openscad, render_stl

            _CACHE_DIR.mkdir(parents=True, exist_ok=True)
            render_stl(path, cached, find_openscad())
        return trimesh.load(cached, force="mesh")

    raise ValueError(f"unsupported model type: {suffix} (want .step/.stp/.stl/.scad)")


def _load_step_shape(path: Path):
    """Read the STEP B-rep, cached as .brep (much faster to re-read)."""
    from OCP.BRep import BRep_Builder
    from OCP.BRepTools import BRepTools
    from OCP.TopoDS import TopoDS_Shape

    cached = _CACHE_DIR / f"{path.stem}-{_cache_key(path)}.brep"
    if cached.is_file():
        shape = TopoDS_Shape()
        if BRepTools.Read_s(shape, str(cached), BRep_Builder()) and not shape.IsNull():
            return shape
    from step2scad.ingest import read_step

    shape = read_step(path)
    _CACHE_DIR.mkdir(parents=True, exist_ok=True)
    BRepTools.Write_s(shape, str(cached))
    return shape


# --------------------------------------------------------------------------
# Point / ray queries
# --------------------------------------------------------------------------

def q_contains(mesh: trimesh.Trimesh, x: float, y: float, z: float) -> dict:
    inside = bool(mesh.contains(np.array([[x, y, z]]))[0])
    return {"point": [x, y, z], "inside": inside}


def q_raycast(mesh: trimesh.Trimesh, ox, oy, oz, dx, dy, dz) -> dict:
    origin = np.array([ox, oy, oz], dtype=float)
    direction = np.array([dx, dy, dz], dtype=float)
    norm = np.linalg.norm(direction)
    if norm == 0:
        raise ValueError("ray direction is zero")
    direction /= norm

    locations, _, _ = mesh.ray.intersects_location(
        ray_origins=[origin], ray_directions=[direction], multiple_hits=True
    )
    out: dict = {"origin": origin.tolist(), "direction": direction.tolist()}
    if len(locations) == 0:
        out.update({"n_hits": 0, "hits": [], "segments": []})
        return out

    t = (locations - origin) @ direction
    order = np.argsort(t)
    t, locations = t[order], locations[order]
    keep = np.concatenate([[True], np.diff(t) > _HIT_DEDUPE_TOL])
    t, locations = t[keep], locations[keep]

    hits = [{"t": float(ti), "point": pi.tolist()} for ti, pi in zip(t, locations)]

    # material/void segments between consecutive hits, classified by occupancy
    # at each segment midpoint -> wall thicknesses and gaps read directly
    segments = []
    if len(t) >= 2:
        mids = origin + direction * ((t[:-1] + t[1:]) / 2.0)[:, None]
        mat = mesh.contains(mids)
        for i in range(len(t) - 1):
            segments.append(
                {
                    "t0": float(t[i]),
                    "t1": float(t[i + 1]),
                    "length": float(t[i + 1] - t[i]),
                    "material": bool(mat[i]),
                }
            )
    out.update({"n_hits": len(hits), "hits": hits, "segments": segments})
    return out


def q_distance(mesh: trimesh.Trimesh, x: float, y: float, z: float) -> dict:
    point = np.array([[x, y, z]], dtype=float)
    nearest, dist, _ = trimesh.proximity.closest_point(mesh, point)
    inside = bool(mesh.contains(point)[0])
    d = float(dist[0])
    return {
        "point": [x, y, z],
        "distance": d,
        "signed": d if inside else -d,  # + = inside the solid, - = outside
        "inside": inside,
        "nearest_point": nearest[0].tolist(),
    }


# --------------------------------------------------------------------------
# Sections
# --------------------------------------------------------------------------

def _plane(mesh: trimesh.Trimesh, axis: str, coord: float):
    ax = _AXES[axis]
    normal = np.zeros(3)
    normal[ax] = 1.0
    origin = mesh.bounds.mean(axis=0)
    origin[ax] = coord
    return ax, origin, normal


def _section_paths(mesh: trimesh.Trimesh, axis: str, coord: float):
    """Return (Path3D section, Path2D planar) or (None, None) if plane misses."""
    _, origin, normal = _plane(mesh, axis, coord)
    section = mesh.section(plane_origin=origin, plane_normal=normal)
    if section is None:
        return None, None
    planar, _ = section.to_2D()
    return section, planar


def q_area(mesh: trimesh.Trimesh, axis: str, coord: float) -> dict:
    _, planar = _section_paths(mesh, axis, coord)
    return {"axis": axis, "coord": coord, "area": float(planar.area) if planar else 0.0}


def q_section(
    mesh: trimesh.Trimesh, axis: str, coord: float, png: Path | None = None
) -> dict:
    section, planar = _section_paths(mesh, axis, coord)
    if section is None:
        return {"axis": axis, "coord": coord, "area": 0.0, "n_loops": 0,
                "note": "plane does not intersect the model"}
    bounds = section.bounds
    out = {
        "axis": axis,
        "coord": coord,
        "area": float(planar.area),
        "perimeter": float(planar.length),
        "n_loops": len(section.discrete),          # closed polylines in the slice
        "n_regions": len(planar.polygons_full),    # filled regions (outer loops)
        "bounds": {"min": bounds[0].tolist(), "max": bounds[1].tolist()},
    }
    if png is not None:
        _plot_section(section, axis, coord, float(planar.area), png)
        out["png"] = str(png)
    return out


def q_slices(
    mesh: trimesh.Trimesh, axis: str, n: int, png: Path | None = None
) -> dict:
    ax = _AXES[axis]
    lo, hi = mesh.bounds[0][ax], mesh.bounds[1][ax]
    step = (hi - lo) / n
    coords = lo + (np.arange(n) + 0.5) * step  # half-step inset: avoids
    sections, areas = [], []                   # degenerate tangent planes
    for c in coords:
        section, planar = _section_paths(mesh, axis, float(c))
        sections.append(section)
        areas.append(float(planar.area) if planar else 0.0)
    out = {
        "axis": axis,
        "n": n,
        "coords": [float(c) for c in coords],
        "areas": areas,
        "area_min": min(areas),
        "area_max": max(areas),
    }
    if png is not None:
        _plot_slices_montage(mesh, sections, coords, areas, axis, png)
        out["png"] = str(png)
    return out


# --------------------------------------------------------------------------
# Global properties
# --------------------------------------------------------------------------

def q_bbox(mesh: trimesh.Trimesh) -> dict:
    return {
        "min": mesh.bounds[0].tolist(),
        "max": mesh.bounds[1].tolist(),
        "extents": mesh.extents.tolist(),
        "center": mesh.bounds.mean(axis=0).tolist(),
    }


def q_volume(mesh: trimesh.Trimesh) -> dict:
    return {"volume": float(mesh.volume), "is_watertight": bool(mesh.is_watertight)}


def q_massprops(mesh: trimesh.Trimesh) -> dict:
    return {
        "volume": float(mesh.volume),
        "surface_area": float(mesh.area),
        "centroid": mesh.center_mass.tolist(),
        "bbox": q_bbox(mesh),
        "principal_axes": np.asarray(mesh.principal_inertia_vectors).tolist(),
        "principal_moments": np.asarray(mesh.principal_inertia_components).tolist(),
        "is_watertight": bool(mesh.is_watertight),
        "n_bodies": int(mesh.body_count),
        "n_vertices": len(mesh.vertices),
        "n_faces": len(mesh.faces),
    }


# --------------------------------------------------------------------------
# nearest-feature: mesh point -> exact B-rep face parameters
# --------------------------------------------------------------------------

def q_nearest_feature(model: Path, x: float, y: float, z: float) -> dict:
    if model.suffix.lower() in (".step", ".stp"):
        return _nearest_feature_brep(model, x, y, z)
    features_json = model.parent / "features.json"
    if features_json.is_file():
        return _nearest_feature_json(features_json, x, y, z)
    raise ValueError(
        "nearest-feature needs a .step model or a features.json next to the model"
    )


def _nearest_feature_brep(step_path: Path, x: float, y: float, z: float) -> dict:
    """Exact answer: BRepExtrema against the bounded B-rep faces."""
    from OCP.BRepBuilderAPI import BRepBuilderAPI_MakeVertex
    from OCP.BRepExtrema import BRepExtrema_DistShapeShape, BRepExtrema_SupportType
    from OCP.gp import gp_Pnt
    from OCP.TopAbs import TopAbs_FACE
    from OCP.TopExp import TopExp, TopExp_Explorer
    from OCP.TopoDS import TopoDS
    from OCP.TopTools import (
        TopTools_IndexedDataMapOfShapeListOfShape,
        TopTools_IndexedMapOfShape,
    )

    from step2scad.ingest import solids_of
    from step2scad.ingest.step_reader import _face_record

    shape = _load_step_shape(step_path)

    vertex = BRepBuilderAPI_MakeVertex(gp_Pnt(x, y, z)).Vertex()
    dss = BRepExtrema_DistShapeShape(vertex, shape)
    dss.Perform()
    if not dss.NbSolution():
        raise RuntimeError("BRepExtrema found no nearest point")

    nearest = dss.PointOnShape2(1)
    support = dss.SupportOnShape2(1)
    stype = dss.SupportTypeShape2(1)

    # Resolve the support to face(s): a face directly, or the faces adjacent
    # to the support edge/vertex (point nearest a shared edge belongs to both).
    faces = []
    if stype == BRepExtrema_SupportType.BRepExtrema_IsInFace:
        faces = [TopoDS.Face_s(support)]
        support_kind = "face"
    else:
        support_kind = (
            "edge" if stype == BRepExtrema_SupportType.BRepExtrema_IsOnEdge else "vertex"
        )
        anc = TopTools_IndexedDataMapOfShapeListOfShape()
        kind_enum = support.ShapeType()
        TopExp.MapShapesAndAncestors_s(shape, kind_enum, TopAbs_FACE, anc)
        idx = anc.FindIndex(support)
        if idx:
            faces = [TopoDS.Face_s(s) for s in anc.FindFromIndex(idx)]

    # Map each face back to its (body, index) as extract_features numbers them
    solids = solids_of(shape) or [shape]
    body_maps = []
    for solid in solids:
        fmap = TopTools_IndexedMapOfShape()
        TopExp.MapShapes_s(solid, TopAbs_FACE, fmap)
        body_maps.append(fmap)

    face_records = []
    for face in faces:
        body_id, face_idx = None, None
        for bi, fmap in enumerate(body_maps):
            fi = fmap.FindIndex(face)
            if fi:
                body_id, face_idx = bi, fi - 1
                break
        rec = _face_record(face, face_idx if face_idx is not None else -1)
        rec.pop("neighbors", None)
        rec["body"] = body_id
        face_records.append(rec)

    out = {
        "query_point": [x, y, z],
        "distance": float(dss.Value()),
        "nearest_point": [nearest.X(), nearest.Y(), nearest.Z()],
        "support": support_kind,
        "source": "brep",
    }
    if support_kind == "face":
        out["face"] = face_records[0] if face_records else None
    else:
        out["faces"] = face_records  # all faces meeting at the edge/vertex
    return out


def _analytic_distance(p: np.ndarray, rec: dict) -> float | None:
    """Point -> UNBOUNDED analytic surface distance (features.json fallback)."""
    prm = rec.get("params", {})
    t = rec.get("type")
    if t == "plane":
        n = np.array(prm["normal"])
        return abs(float((p - np.array(prm["origin"])) @ n)) / np.linalg.norm(n)
    if t == "cylinder":
        a = np.array(prm["axis_dir"])
        a = a / np.linalg.norm(a)
        v = p - np.array(prm["axis_origin"])
        rho = np.linalg.norm(v - (v @ a) * a)
        return abs(float(rho - prm["radius"]))
    if t == "sphere":
        return abs(float(np.linalg.norm(p - np.array(prm["center"])) - prm["radius"]))
    if t == "cone":
        a = np.array(prm["axis_dir"])
        a = a / np.linalg.norm(a)
        v = p - np.array(prm["apex"])
        zc = float(v @ a)
        rho = float(np.linalg.norm(v - zc * a))
        half = math.radians(prm["half_angle_deg"])
        return abs(rho * math.cos(half) - abs(zc) * math.sin(half))
    if t == "torus":
        a = np.array(prm["axis_dir"])
        a = a / np.linalg.norm(a)
        v = p - np.array(prm["axis_origin"])
        zc = float(v @ a)
        rho = float(np.linalg.norm(v - zc * a))
        return abs(math.hypot(rho - prm["major_radius"], zc) - prm["minor_radius"])
    return None  # bspline / other: no closed-form distance


def _nearest_feature_json(features_json: Path, x: float, y: float, z: float) -> dict:
    """Fallback: rank analytic faces from a features.json by UNBOUNDED surface
    distance (a face's infinite extension may rank spuriously close — top-3
    candidates are returned so the caller can disambiguate)."""
    data = json.loads(features_json.read_text())
    p = np.array([x, y, z], dtype=float)
    candidates = []
    for body in data.get("bodies", []):
        for rec in body.get("faces", []):
            d = _analytic_distance(p, rec)
            if d is None:
                continue
            slim = {k: rec[k] for k in ("index", "type", "area", "params") if k in rec}
            slim["body"] = body.get("id")
            candidates.append({"distance": float(d), "face": slim})
    if not candidates:
        raise ValueError(f"no analytic faces in {features_json}")
    candidates.sort(key=lambda c: c["distance"])
    return {
        "query_point": [x, y, z],
        "source": f"features.json ({features_json})",
        "note": "distances are to UNBOUNDED analytic surfaces (face trim ignored)",
        "distance": candidates[0]["distance"],
        "face": candidates[0]["face"],
        "runners_up": candidates[1:3],
    }


# --------------------------------------------------------------------------
# compare
# --------------------------------------------------------------------------

def q_compare(model_a: Path, model_b: Path) -> dict:
    from step2scad.eval import evaluate, surface_distance

    mesh_a = load_mesh(model_a)
    mesh_b = load_mesh(model_b)
    report, aligned = evaluate(mesh_a, mesh_b, return_aligned=True)
    dist_stats, _ = surface_distance(aligned, mesh_b)
    return {
        "model_a": str(model_a),
        "model_b": str(model_b),
        "iou": report["iou"],
        "method": report["method"],
        "alignment": report["alignment"],
        "volume_a": report["candidate_volume"],
        "volume_b": report["reference_volume"],
        "surface_distance": dist_stats,
    }


# --------------------------------------------------------------------------
# Plotting (matplotlib Agg, headless-safe — same convention as eval/heatmap)
# --------------------------------------------------------------------------

def _inplane_indices(axis: str) -> tuple[int, int, str, str]:
    """World-coordinate indices (and labels) spanning the section plane."""
    return {
        "x": (1, 2, "y", "z"),
        "y": (0, 2, "x", "z"),
        "z": (0, 1, "x", "y"),
    }[axis]


def _plot_loops(ax, section, axis: str) -> None:
    i, j, _, _ = _inplane_indices(axis)
    for loop in section.discrete:  # world-space closed polylines
        ax.plot(loop[:, i], loop[:, j], "-", lw=1.0, color="#1565c0")
    ax.set_aspect("equal")


def _plot_section(section, axis: str, coord: float, area: float, png: Path) -> None:
    import matplotlib

    matplotlib.use("Agg")
    import matplotlib.pyplot as plt

    _, _, li, lj = _inplane_indices(axis)
    fig, ax = plt.subplots(figsize=(6, 6))
    _plot_loops(ax, section, axis)
    ax.set_xlabel(f"{li} (mm)")
    ax.set_ylabel(f"{lj} (mm)")
    ax.set_title(f"section {axis}={coord:g}   area={area:.3f} mm²")
    ax.grid(True, alpha=0.3)
    png.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(png, dpi=120, bbox_inches="tight")
    plt.close(fig)


def _plot_slices_montage(mesh, sections, coords, areas, axis: str, png: Path) -> None:
    """All N slice outlines tiled into one image, SHARED in-plane limits so
    relative slice sizes are directly comparable by eye."""
    import matplotlib

    matplotlib.use("Agg")
    import matplotlib.pyplot as plt

    i, j, li, lj = _inplane_indices(axis)
    pad = 0.05 * max(mesh.extents[i], mesh.extents[j])
    xlim = (mesh.bounds[0][i] - pad, mesh.bounds[1][i] + pad)
    ylim = (mesh.bounds[0][j] - pad, mesh.bounds[1][j] + pad)

    n = len(sections)
    ncols = math.ceil(math.sqrt(n))
    nrows = math.ceil(n / ncols)
    fig, axes = plt.subplots(
        nrows, ncols, figsize=(3.2 * ncols, 3.2 * nrows), squeeze=False
    )
    for k in range(nrows * ncols):
        ax = axes[k // ncols][k % ncols]
        if k >= n:
            ax.axis("off")
            continue
        if sections[k] is not None:
            _plot_loops(ax, sections[k], axis)
        ax.set_xlim(*xlim)
        ax.set_ylim(*ylim)
        ax.set_aspect("equal")
        ax.set_title(f"{axis}={coords[k]:.3f}  A={areas[k]:.1f}", fontsize=9)
        ax.tick_params(labelsize=7)
        ax.grid(True, alpha=0.25)
    fig.suptitle(f"slices along {axis}  ({li}-{lj} plane outlines)", fontsize=12)
    fig.tight_layout()
    png.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(png, dpi=110)
    plt.close(fig)


# --------------------------------------------------------------------------
# CLI
# --------------------------------------------------------------------------

def _round_floats(obj, ndigits: int = 6):
    if isinstance(obj, float):
        return round(obj, ndigits)
    if isinstance(obj, dict):
        return {k: _round_floats(v, ndigits) for k, v in obj.items()}
    if isinstance(obj, (list, tuple)):
        return [_round_floats(v, ndigits) for v in obj]
    return obj


def _default_png(model: Path, query: str, *args) -> Path:
    tag = "_".join(str(a).replace(".", "p").replace("-", "m") for a in args)
    name = f"{model.stem}_{query}{('_' + tag) if tag else ''}.png"
    return _PROBE_TMP / name


def _build_parser() -> argparse.ArgumentParser:
    common = argparse.ArgumentParser(add_help=False)
    common.add_argument("--json", action="store_true",
                        help="explicit flag; output is always JSON")
    common.add_argument("--png", nargs="?", const="", default=None, metavar="PATH",
                        help="save a PNG (default path under tmp/probe/)")

    parser = argparse.ArgumentParser(
        prog="step2scad.probe",
        description="Geometry probe: exact JSON answers about a model "
                    "(.step/.stp/.stl/.scad).",
    )
    parser.add_argument("model", help="model file: .step/.stp/.stl/.scad")
    sub = parser.add_subparsers(dest="query", required=True)

    p = sub.add_parser("contains", parents=[common], help="material at point?")
    p.add_argument("x", type=float); p.add_argument("y", type=float)
    p.add_argument("z", type=float)

    p = sub.add_parser("raycast", parents=[common],
                       help="ordered surface hits + material/void segments")
    for name in ("ox", "oy", "oz", "dx", "dy", "dz"):
        p.add_argument(name, type=float)

    p = sub.add_parser("distance", parents=[common],
                       help="nearest-surface distance (signed) + nearest point")
    p.add_argument("x", type=float); p.add_argument("y", type=float)
    p.add_argument("z", type=float)

    p = sub.add_parser("section", parents=[common],
                       help="cross-section stats at plane AXIS=COORD")
    p.add_argument("axis", choices=list(_AXES))
    p.add_argument("coord", type=float)

    p = sub.add_parser("area", parents=[common],
                       help="fast: just the cross-section area")
    p.add_argument("axis", choices=list(_AXES))
    p.add_argument("coord", type=float)

    sub.add_parser("bbox", parents=[common], help="axis-aligned bounding box")
    sub.add_parser("volume", parents=[common], help="volume + watertightness")
    sub.add_parser("massprops", parents=[common],
                   help="volume, area, centroid, principal axes, bodies")

    p = sub.add_parser("slices", parents=[common],
                       help="N evenly spaced section areas (+ montage PNG)")
    p.add_argument("axis", choices=list(_AXES))
    p.add_argument("n", type=int)

    p = sub.add_parser("nearest-feature", parents=[common],
                       help="nearest EXACT B-rep face + its CAD parameters")
    p.add_argument("x", type=float); p.add_argument("y", type=float)
    p.add_argument("z", type=float)

    p = sub.add_parser("compare", parents=[common],
                       help="IoU + surface distance vs another model")
    p.add_argument("model_b", help="other model: .step/.stp/.stl/.scad")

    return parser


def main(argv: list[str] | None = None) -> int:
    args = _build_parser().parse_args(argv)
    model = Path(args.model)

    def png_path(*tag_args) -> Path | None:
        if args.png is None:
            return None
        return Path(args.png) if args.png else _default_png(model, args.query, *tag_args)

    try:
        if args.query == "nearest-feature":
            result = q_nearest_feature(model, args.x, args.y, args.z)
        elif args.query == "compare":
            result = q_compare(model, Path(args.model_b))
        else:
            mesh = load_mesh(model)
            if args.query == "contains":
                result = q_contains(mesh, args.x, args.y, args.z)
            elif args.query == "raycast":
                result = q_raycast(mesh, args.ox, args.oy, args.oz,
                                   args.dx, args.dy, args.dz)
            elif args.query == "distance":
                result = q_distance(mesh, args.x, args.y, args.z)
            elif args.query == "section":
                result = q_section(mesh, args.axis, args.coord,
                                   png=png_path(args.axis, args.coord))
            elif args.query == "area":
                result = q_area(mesh, args.axis, args.coord)
            elif args.query == "bbox":
                result = q_bbox(mesh)
            elif args.query == "volume":
                result = q_volume(mesh)
            elif args.query == "massprops":
                result = q_massprops(mesh)
            elif args.query == "slices":
                result = q_slices(mesh, args.axis, args.n,
                                  png=png_path(args.axis, args.n))
            else:  # pragma: no cover — argparse enforces choices
                raise ValueError(f"unknown query: {args.query}")
    except Exception as exc:
        print(json.dumps({"error": f"{type(exc).__name__}: {exc}"}))
        return 1

    print(json.dumps(_round_floats(result)))
    return 0


if __name__ == "__main__":
    sys.exit(main())
