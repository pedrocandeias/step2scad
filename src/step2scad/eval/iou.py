"""Stage 5: EVAL — align candidate vs original and compute boolean-volume IoU.

    IoU = intersection_volume / union_volume

Reference = high-res tessellation of the original STEP solid.
Candidate = STL rendered from the emitted .scad.

Alignment: the emitters place geometry in the original STEP coordinates, so
identity should already fit — but we also try centroid translation and the
four proper (det=+1) principal-axes rotations, score each candidate transform
with a fast contained-point-fraction proxy, and keep the best before running
the exact boolean IoU (manifold engine, with a voxel fallback).
"""

from __future__ import annotations

import numpy as np
import trimesh

_PROXY_SAMPLES = 3000


def _principal_frame(mesh: trimesh.Trimesh) -> np.ndarray:
    """Rows = principal inertia axes (right-handed)."""
    vecs = np.array(mesh.principal_inertia_vectors, dtype=float)  # writable copy
    if np.linalg.det(vecs) < 0:
        vecs[2] = -vecs[2]
    return vecs


def _candidate_transforms(candidate: trimesh.Trimesh, reference: trimesh.Trimesh):
    """Yield (label, 4x4) transforms mapping candidate -> reference frame."""
    yield "identity", np.eye(4)

    t = np.eye(4)
    t[:3, 3] = reference.center_mass - candidate.center_mass
    yield "centroid", t

    fc, fr = _principal_frame(candidate), _principal_frame(reference)
    # 4 proper rotations: flip signs of two axes at a time
    for i, flips in enumerate([(1, 1, 1), (1, -1, -1), (-1, 1, -1), (-1, -1, 1)]):
        r = fr.T @ (np.diag(flips) @ fc)
        m = np.eye(4)
        m[:3, :3] = r
        m[:3, 3] = reference.center_mass - r @ candidate.center_mass
        yield f"principal_axes[{i}]", m


def _proxy_score(candidate: trimesh.Trimesh, reference: trimesh.Trimesh, matrix) -> float:
    """Fast alignment score: fraction of reference-volume samples inside the
    transformed candidate (proxy for intersection volume)."""
    try:
        pts = trimesh.sample.volume_mesh(reference, _PROXY_SAMPLES)
        if len(pts) == 0:
            return -1.0
        moved = candidate.copy()
        moved.apply_transform(matrix)
        return float(moved.contains(pts).mean())
    except Exception:
        return -1.0


def align_meshes(
    candidate: trimesh.Trimesh, reference: trimesh.Trimesh, icp_refine: bool = False
) -> tuple[trimesh.Trimesh, str]:
    """Pick the best of the candidate transforms; optional ICP refinement."""
    best_label, best_matrix, best_score = "identity", np.eye(4), -1.0
    for label, matrix in _candidate_transforms(candidate, reference):
        score = _proxy_score(candidate, reference, matrix)
        if score > best_score:
            best_label, best_matrix, best_score = label, matrix, score

    aligned = candidate.copy()
    aligned.apply_transform(best_matrix)

    if icp_refine:
        try:
            matrix, _, _ = trimesh.registration.icp(
                aligned.sample(2000), reference, max_iterations=50
            )
            refined = aligned.copy()
            refined.apply_transform(matrix)
            if _proxy_score(refined, reference, np.eye(4)) > best_score:
                aligned, best_label = refined, best_label + "+icp"
        except Exception:
            pass  # ICP is optional refinement only

    return aligned, best_label


def boolean_iou(a: trimesh.Trimesh, b: trimesh.Trimesh) -> dict:
    """Exact boolean IoU (manifold engine); voxel-grid fallback if booleans fail."""
    try:
        inter = trimesh.boolean.intersection([a, b], engine="manifold")
        union = trimesh.boolean.union([a, b], engine="manifold")
        iv, uv = float(inter.volume), float(union.volume)
        return {
            "method": "boolean(manifold)",
            "intersection_volume": iv,
            "union_volume": uv,
            "iou": iv / uv if uv > 0 else 0.0,
        }
    except BaseException as exc:  # manifold can raise non-Exception errors
        # Voxel fallback: sample both meshes on a common grid.
        pitch = float(np.linalg.norm(a.extents + b.extents)) / 200.0
        lo = np.minimum(a.bounds[0], b.bounds[0]) - pitch
        hi = np.maximum(a.bounds[1], b.bounds[1]) + pitch
        axes = [np.arange(lo[i], hi[i], pitch) for i in range(3)]
        grid = np.stack(np.meshgrid(*axes, indexing="ij"), axis=-1).reshape(-1, 3)
        in_a = a.contains(grid)
        in_b = b.contains(grid)
        inter_n = int(np.logical_and(in_a, in_b).sum())
        union_n = int(np.logical_or(in_a, in_b).sum())
        return {
            "method": f"voxel-fallback(pitch={pitch:.4f}, boolean error: {exc})",
            "intersection_volume": inter_n * pitch**3,
            "union_volume": union_n * pitch**3,
            "iou": inter_n / union_n if union_n else 0.0,
        }


def evaluate(
    candidate: trimesh.Trimesh,
    reference: trimesh.Trimesh,
    icp_refine: bool = False,
    return_aligned: bool = False,
):
    """Align candidate to reference and compute the IoU report dict.

    With return_aligned=True, returns (report, aligned_candidate) so callers
    (localized diagnostics, assertions, heatmap) reuse the same alignment.
    """
    aligned, alignment = align_meshes(candidate, reference, icp_refine=icp_refine)
    report = boolean_iou(aligned, reference)
    report.update(
        {
            "alignment": alignment,
            "reference_volume": float(reference.volume),
            "candidate_volume": float(candidate.volume),
            "reference_watertight": bool(reference.is_watertight),
            "candidate_watertight": bool(candidate.is_watertight),
        }
    )
    if return_aligned:
        return report, aligned
    return report
