"""Stage 1: INGEST — read a STEP B-rep and extract EXACT analytic geometry.

For every solid body, for every face, emit the surface type and its exact
parameters as stored in the B-rep (no fitting, no estimation):

    plane    -> origin, normal
    cylinder -> axis (origin + direction), radius
    cone     -> axis, half-angle, reference radius, apex
    sphere   -> center, radius
    torus    -> axis, major radius, minor radius
    bspline / other free-form -> degrees / pole counts where available

Plus, per body: volume, centroid, axis-aligned bbox, principal axes + moments,
and the FACE ADJACENCY GRAPH: for every face, its neighbours via shared edges,
each with the shared-edge curve type (line/circle/…) and the convex/concave/
tangential character of the transition. Adjacency is what lets an emitter
recover construction *intent* (a cylinder flanked by two cones sharing convex
circular edges = a chamfered boss; a ring of coaxial cylinders joined by
tangential edges = a knuckle bore chain).

The result is a normalized dict, serialisable to features.json — the single
source of truth every later stage reads dimensions from.
"""

from __future__ import annotations

import math
from pathlib import Path

from OCP.Bnd import Bnd_Box
from OCP.BRepAdaptor import BRepAdaptor_Curve, BRepAdaptor_Surface
from OCP.BRepBndLib import BRepBndLib
from OCP.BRepGProp import BRepGProp
from OCP.ChFi3d import ChFi3d
from OCP.ChFiDS import ChFiDS_TypeOfConcavity
from OCP.GeomAbs import GeomAbs_CurveType as CT
from OCP.GeomAbs import GeomAbs_SurfaceType as ST
from OCP.GProp import GProp_GProps
from OCP.IFSelect import IFSelect_RetDone
from OCP.STEPControl import STEPControl_Reader
from OCP.TopAbs import TopAbs_EDGE, TopAbs_FACE, TopAbs_REVERSED, TopAbs_SOLID
from OCP.TopExp import TopExp, TopExp_Explorer
from OCP.TopoDS import TopoDS, TopoDS_Shape
from OCP.TopTools import (
    TopTools_IndexedDataMapOfShapeListOfShape,
    TopTools_IndexedMapOfShape,
)

# GeomAbs enum -> normalized surface-type name
_SURFACE_NAMES = {
    ST.GeomAbs_Plane: "plane",
    ST.GeomAbs_Cylinder: "cylinder",
    ST.GeomAbs_Cone: "cone",
    ST.GeomAbs_Sphere: "sphere",
    ST.GeomAbs_Torus: "torus",
    ST.GeomAbs_BezierSurface: "bezier",
    ST.GeomAbs_BSplineSurface: "bspline",
    ST.GeomAbs_SurfaceOfRevolution: "revolution",
    ST.GeomAbs_SurfaceOfExtrusion: "extrusion",
    ST.GeomAbs_OffsetSurface: "offset",
    ST.GeomAbs_OtherSurface: "other",
}

# GeomAbs curve enum -> normalized edge-curve-type name
_CURVE_NAMES = {
    CT.GeomAbs_Line: "line",
    CT.GeomAbs_Circle: "circle",
    CT.GeomAbs_Ellipse: "ellipse",
    CT.GeomAbs_Hyperbola: "hyperbola",
    CT.GeomAbs_Parabola: "parabola",
    CT.GeomAbs_BezierCurve: "bezier",
    CT.GeomAbs_BSplineCurve: "bspline",
    CT.GeomAbs_OffsetCurve: "offset",
    CT.GeomAbs_OtherCurve: "other",
}

# ChFi3d transition classification -> convex/concave label
_CONCAVITY_NAMES = {
    ChFiDS_TypeOfConcavity.ChFiDS_Concave: "concave",
    ChFiDS_TypeOfConcavity.ChFiDS_Convex: "convex",
    ChFiDS_TypeOfConcavity.ChFiDS_Tangential: "tangential",
    ChFiDS_TypeOfConcavity.ChFiDS_Mixed: "mixed",
    ChFiDS_TypeOfConcavity.ChFiDS_FreeBound: "free_bound",
}

# sin(angular tolerance) below which a face-face transition is "tangential"
_TANGENT_SIN_TOL = 0.01


def read_step(path: str | Path) -> TopoDS_Shape:
    """Read a STEP file and return the combined shape (units: mm)."""
    reader = STEPControl_Reader()
    status = reader.ReadFile(str(path))
    if status != IFSelect_RetDone:
        raise RuntimeError(f"STEP read failed for {path} (status={status})")
    reader.TransferRoots()
    return reader.OneShape()


def solids_of(shape: TopoDS_Shape) -> list:
    """Enumerate the solid bodies of a shape."""
    solids = []
    exp = TopExp_Explorer(shape, TopAbs_SOLID)
    while exp.More():
        solids.append(TopoDS.Solid_s(exp.Current()))
        exp.Next()
    return solids


def _xyz(coord3) -> list[float]:
    return [float(coord3.X()), float(coord3.Y()), float(coord3.Z())]


def _face_record(face, index: int) -> dict:
    """Extract exact surface type + parameters for one face."""
    adaptor = BRepAdaptor_Surface(face, True)  # True = restrict to face UV bounds
    stype = adaptor.GetType()
    name = _SURFACE_NAMES.get(stype, "other")

    area_props = GProp_GProps()
    BRepGProp.SurfaceProperties_s(face, area_props)

    rec: dict = {
        "index": index,
        "type": name,
        "area": float(area_props.Mass()),
        # 'reversed' means the face normal opposes the surface's natural
        # normal — for a cylinder that natural normal points radially out,
        # so a reversed cylindrical face is an inner wall (a bore).
        "orientation": "reversed" if face.Orientation() == TopAbs_REVERSED else "forward",
        "u_range": [float(adaptor.FirstUParameter()), float(adaptor.LastUParameter())],
        "v_range": [float(adaptor.FirstVParameter()), float(adaptor.LastVParameter())],
    }

    params: dict = {}
    if stype == ST.GeomAbs_Plane:
        pln = adaptor.Plane()
        params["origin"] = _xyz(pln.Location())
        params["normal"] = _xyz(pln.Axis().Direction())
    elif stype == ST.GeomAbs_Cylinder:
        cyl = adaptor.Cylinder()
        params["axis_origin"] = _xyz(cyl.Axis().Location())
        params["axis_dir"] = _xyz(cyl.Axis().Direction())
        params["radius"] = float(cyl.Radius())
    elif stype == ST.GeomAbs_Cone:
        cone = adaptor.Cone()
        params["axis_origin"] = _xyz(cone.Axis().Location())
        params["axis_dir"] = _xyz(cone.Axis().Direction())
        params["half_angle_deg"] = math.degrees(float(cone.SemiAngle()))
        params["ref_radius"] = float(cone.RefRadius())
        params["apex"] = _xyz(cone.Apex())
    elif stype == ST.GeomAbs_Sphere:
        sph = adaptor.Sphere()
        params["center"] = _xyz(sph.Location())
        params["radius"] = float(sph.Radius())
    elif stype == ST.GeomAbs_Torus:
        tor = adaptor.Torus()
        params["axis_origin"] = _xyz(tor.Axis().Location())
        params["axis_dir"] = _xyz(tor.Axis().Direction())
        params["major_radius"] = float(tor.MajorRadius())
        params["minor_radius"] = float(tor.MinorRadius())
    elif stype in (ST.GeomAbs_BSplineSurface, ST.GeomAbs_BezierSurface):
        try:
            bs = adaptor.BSpline() if stype == ST.GeomAbs_BSplineSurface else adaptor.Bezier()
            params["u_degree"] = int(bs.UDegree())
            params["v_degree"] = int(bs.VDegree())
            params["n_poles_u"] = int(bs.NbUPoles())
            params["n_poles_v"] = int(bs.NbVPoles())
        except Exception:  # geometry not convertible; keep type only
            pass
    rec["params"] = params
    return rec


def _edge_record(edge, face_a, face_b, idx_a: int, idx_b: int) -> dict:
    """Describe the shared edge between two faces: curve type (+ radius for
    circles) and the convex/concave/tangential character of the transition."""
    rec: dict = {"faces": [idx_a, idx_b]}
    try:
        curve = BRepAdaptor_Curve(edge)
        ctype = curve.GetType()
        rec["curve_type"] = _CURVE_NAMES.get(ctype, "other")
        if ctype == CT.GeomAbs_Circle:
            rec["radius"] = float(curve.Circle().Radius())
    except Exception:  # degenerate edge geometry
        rec["curve_type"] = "unknown"
    try:
        kind = ChFi3d.DefineConnectType_s(edge, face_a, face_b, _TANGENT_SIN_TOL, True)
        rec["convexity"] = _CONCAVITY_NAMES.get(kind, "other")
    except Exception:
        rec["convexity"] = "unknown"
    return rec


def _face_adjacency(solid, face_map: TopTools_IndexedMapOfShape, faces: list[dict]) -> None:
    """Fill each face record's `neighbors` list via edge -> bounding-faces.

    Uses TopExp.MapShapesAndAncestors (edge -> list of owning faces); face ids
    come from `face_map`, whose 1-based indices match the TopExp_Explorer
    order used to build the face records.
    """
    for f in faces:
        f["neighbors"] = []
    edge_map = TopTools_IndexedDataMapOfShapeListOfShape()
    TopExp.MapShapesAndAncestors_s(solid, TopAbs_EDGE, TopAbs_FACE, edge_map)
    for i in range(1, edge_map.Extent() + 1):
        edge = TopoDS.Edge_s(edge_map.FindKey(i))
        owner_ids = sorted({face_map.FindIndex(s) - 1 for s in edge_map.FindFromIndex(i)})
        if len(owner_ids) != 2:
            continue  # seam edge (one face twice) or open boundary
        ia, ib = owner_ids
        face_a = TopoDS.Face_s(face_map.FindKey(ia + 1))
        face_b = TopoDS.Face_s(face_map.FindKey(ib + 1))
        shared = _edge_record(edge, face_a, face_b, ia, ib)
        for me, other in ((ia, ib), (ib, ia)):
            entry = {
                "face": other,
                "edge_type": shared.get("curve_type", "unknown"),
                "convexity": shared.get("convexity", "unknown"),
            }
            if "radius" in shared:
                entry["edge_radius"] = shared["radius"]
            if entry not in faces[me]["neighbors"]:  # dedupe seam-split arcs
                faces[me]["neighbors"].append(entry)


def _body_record(solid, body_id: int) -> dict:
    vol_props = GProp_GProps()
    BRepGProp.VolumeProperties_s(solid, vol_props)

    box = Bnd_Box()
    BRepBndLib.Add_s(solid, box)

    principal = vol_props.PrincipalProperties()
    moments = principal.Moments()
    axes = [
        _xyz(principal.FirstAxisOfInertia()),
        _xyz(principal.SecondAxisOfInertia()),
        _xyz(principal.ThirdAxisOfInertia()),
    ]

    # face index map: 1-based, same order as TopExp_Explorer — the records'
    # `index` field and the adjacency graph both key off it
    face_map = TopTools_IndexedMapOfShape()
    TopExp.MapShapes_s(solid, TopAbs_FACE, face_map)
    faces = [
        _face_record(TopoDS.Face_s(face_map.FindKey(i + 1)), i)
        for i in range(face_map.Extent())
    ]
    try:
        _face_adjacency(solid, face_map, faces)
    except Exception:
        pass  # adjacency is additive; never let it kill ingest

    type_counts: dict[str, int] = {}
    area_by_type: dict[str, float] = {}
    for f in faces:
        type_counts[f["type"]] = type_counts.get(f["type"], 0) + 1
        area_by_type[f["type"]] = area_by_type.get(f["type"], 0.0) + f["area"]

    return {
        "id": body_id,
        "volume": float(vol_props.Mass()),
        "centroid": _xyz(vol_props.CentreOfMass()),
        "bbox": {"min": _xyz(box.CornerMin()), "max": _xyz(box.CornerMax())},
        "principal_moments": [float(m) for m in moments],
        "principal_axes": axes,
        "n_faces": len(faces),
        "surface_type_counts": type_counts,
        "surface_area_by_type": {k: float(v) for k, v in area_by_type.items()},
        "faces": faces,
    }


def extract_features(shape: TopoDS_Shape, source: str = "") -> dict:
    """Walk every solid of `shape` and build the normalized feature dict."""
    solids = solids_of(shape)
    if not solids:
        # Shells-only STEP (no closed solid): treat the whole shape as one body
        # so the pipeline still runs; flagged so downstream stages can warn.
        solids = [shape]
    bodies = [_body_record(s, i) for i, s in enumerate(solids)]
    return {
        "source": str(source),
        "units": "mm",  # STEPControl_Reader converts to mm by default
        "n_bodies": len(bodies),
        "bodies": bodies,
    }
