"""Tessellate an OCC shape into a trimesh.Trimesh (used by eval as ground truth).

We mesh the B-rep with BRepMesh_IncrementalMesh and read the per-face
Poly_Triangulation directly into numpy — no STL round-trip needed.
"""

from __future__ import annotations

import numpy as np
import trimesh
from OCP.Bnd import Bnd_Box
from OCP.BRep import BRep_Tool
from OCP.BRepBndLib import BRepBndLib
from OCP.BRepMesh import BRepMesh_IncrementalMesh
from OCP.TopAbs import TopAbs_FACE, TopAbs_REVERSED
from OCP.TopExp import TopExp_Explorer
from OCP.TopLoc import TopLoc_Location
from OCP.TopoDS import TopoDS, TopoDS_Shape


def _bbox_diagonal(shape: TopoDS_Shape) -> float:
    box = Bnd_Box()
    BRepBndLib.Add_s(shape, box)
    cmin, cmax = box.CornerMin(), box.CornerMax()
    d = np.array([cmax.X() - cmin.X(), cmax.Y() - cmin.Y(), cmax.Z() - cmin.Z()])
    return float(np.linalg.norm(d))


def shape_to_trimesh(
    shape: TopoDS_Shape,
    linear_deflection: float | None = None,
    angular_deflection: float = 0.25,
) -> trimesh.Trimesh:
    """Mesh `shape` and return a merged, processed trimesh.

    linear_deflection defaults to 0.1% of the bbox diagonal (high-res ground
    truth for IoU without exploding triangle counts).
    """
    if linear_deflection is None:
        linear_deflection = max(_bbox_diagonal(shape) * 1e-3, 1e-4)

    BRepMesh_IncrementalMesh(shape, linear_deflection, False, angular_deflection, True)

    all_verts: list[np.ndarray] = []
    all_faces: list[np.ndarray] = []
    offset = 0

    exp = TopExp_Explorer(shape, TopAbs_FACE)
    while exp.More():
        face = TopoDS.Face_s(exp.Current())
        loc = TopLoc_Location()
        tri = BRep_Tool.Triangulation_s(face, loc)
        exp.Next()
        if tri is None:
            continue

        trsf = loc.Transformation()
        n_nodes = tri.NbNodes()
        verts = np.empty((n_nodes, 3), dtype=np.float64)
        for i in range(1, n_nodes + 1):
            p = tri.Node(i).Transformed(trsf)
            verts[i - 1] = (p.X(), p.Y(), p.Z())

        n_tris = tri.NbTriangles()
        faces = np.empty((n_tris, 3), dtype=np.int64)
        for i in range(1, n_tris + 1):
            a, b, c = tri.Triangle(i).Get()
            faces[i - 1] = (a - 1, b - 1, c - 1)

        if face.Orientation() == TopAbs_REVERSED:
            faces = faces[:, ::-1]  # flip winding so normals point outward

        all_verts.append(verts)
        all_faces.append(faces + offset)
        offset += n_nodes

    if not all_verts:
        raise RuntimeError("tessellation produced no triangles")

    mesh = trimesh.Trimesh(
        vertices=np.vstack(all_verts),
        faces=np.vstack(all_faces),
        process=True,  # merges duplicate vertices along shared B-rep edges
    )
    mesh.merge_vertices(merge_tex=True, merge_norm=True)

    # Deterministic repair: tiny sliver B-rep faces tessellate into degenerate
    # fragments and pinholes that break watertightness (and with it the exact
    # boolean IoU + contains()-based localization). Drop degenerate triangles
    # and 1-2-triangle junk shards, merge near-coincident seam vertices, and
    # close the remaining pinholes.
    mesh.update_faces(mesh.nondegenerate_faces(height=1e-7))
    mesh.remove_unreferenced_vertices()
    parts = mesh.split(only_watertight=False)
    keep = [p for p in parts if len(p.faces) > 4]
    if keep:
        mesh = trimesh.util.concatenate(keep)
    if not mesh.is_watertight:
        # OCC refuses to triangulate the odd degenerate sliver face (seen: a
        # 0.4 mm² torus blend, a 0.05 mm² plane), leaving an open boundary
        # ring per affected body. Cap the boundary loops body-by-body with
        # stitch triangles (winding fixed per body so volumes stay positive).
        # The capped area is sub-mm² — far below IoU/localization resolution.
        try:
            fixed = []
            for part in mesh.split(only_watertight=False):
                if not part.is_watertight:
                    new_faces = trimesh.repair.stitch(part)
                    if len(new_faces):
                        part = trimesh.Trimesh(
                            vertices=part.vertices,
                            faces=np.vstack([part.faces, new_faces]),
                            process=True,
                        )
                    trimesh.repair.fix_normals(part)
                    if part.is_watertight and part.volume < 0:
                        part.invert()
                fixed.append(part)
            mesh = trimesh.util.concatenate(fixed)
            # stitching can leave zero-volume bubble shards — drop them
            parts = [p for p in mesh.split(only_watertight=False)
                     if abs(p.volume) > 1e-3]
            mesh = trimesh.util.concatenate(parts)
        except Exception:
            pass  # non-watertight ref degrades eval to voxel mode, not fatal
    return mesh
