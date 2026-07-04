"""Stage 5b: LOCALIZED ERROR EVAL — spatial diagnostics beyond the global IoU.

The global IoU says *how wrong* a reconstruction is; this module says *where*
and *in which direction*, so the emit/fix loop can be driven by measurement:

    section_area_sweeps  cross-section area of recon vs reference on N planes
                         per axis -> signed difference curve + worst plane
    voxel_region_iou     both meshes voxelised on ONE common grid -> global
                         voxel IoU (cross-check of the boolean IoU), a coarse
                         NxNxN per-block IoU grid, the worst blocks, and the
                         voxel-XOR split: false-POSITIVE volume (recon has
                         material the reference doesn't) vs false-NEGATIVE
                         volume (reference material the recon is missing),
                         each localised via connected components
    surface_distance     bidirectional nearest-surface distances -> Hausdorff,
                         mean, p95 (+ per-vertex recon distances for heatmap)
    error_summary        the ranked "where & how much" list the emitter reads

Everything here operates on the ALIGNED candidate vs the reference mesh, both
already produced by the pipeline. All outputs are JSON-serialisable except the
per-vertex distance array (returned separately for eval/heatmap.py).
"""

from __future__ import annotations

import numpy as np
import trimesh
from scipy import ndimage

_AXES = ("x", "y", "z")
_CONTAINS_CHUNK = 100_000  # points per mesh.contains() call (memory bound)


# --------------------------------------------------------------------------
# Section-area sweeps
# --------------------------------------------------------------------------

def _section_area(mesh: trimesh.Trimesh, origin, normal) -> float:
    """Cross-section area of `mesh` on one plane (0.0 if the plane misses)."""
    try:
        section = mesh.section(plane_origin=origin, plane_normal=normal)
        if section is None:
            return 0.0
        planar, _ = section.to_2D()
        return float(planar.area)
    except Exception:
        return float("nan")  # degenerate section (tangent plane etc.)


def section_area_sweeps(
    recon: trimesh.Trimesh, reference: trimesh.Trimesh, n_planes: int = 64
) -> dict:
    """Per axis: recon + reference cross-section area on n_planes planes across
    the combined bbox, their signed difference, and the worst plane."""
    lo = np.minimum(recon.bounds[0], reference.bounds[0])
    hi = np.maximum(recon.bounds[1], reference.bounds[1])
    out: dict = {}
    for ax, name in enumerate(_AXES):
        normal = np.zeros(3)
        normal[ax] = 1.0
        # inset half a step from the bbox faces (planes tangent to a flat cap
        # produce degenerate sections)
        step = (hi[ax] - lo[ax]) / n_planes
        coords = lo[ax] + (np.arange(n_planes) + 0.5) * step
        recon_a, ref_a = [], []
        for c in coords:
            origin = lo.copy()
            origin[ax] = c
            recon_a.append(_section_area(recon, origin, normal))
            ref_a.append(_section_area(reference, origin, normal))
        recon_a, ref_a = np.array(recon_a), np.array(ref_a)
        diff = recon_a - ref_a  # + = recon has too much, - = recon missing
        finite = np.nan_to_num(diff, nan=0.0)
        i_worst = int(np.argmax(np.abs(finite)))
        out[name] = {
            "coords": [round(float(c), 4) for c in coords],
            "recon_area": [round(float(a), 4) for a in recon_a],
            "reference_area": [round(float(a), 4) for a in ref_a],
            "diff": [round(float(d), 4) for d in diff],
            "max_abs_diff": {
                "coord": round(float(coords[i_worst]), 4),
                "diff": round(float(finite[i_worst]), 4),
                "kind": "false_positive" if finite[i_worst] > 0 else "false_negative",
            },
        }
    return out


# --------------------------------------------------------------------------
# Common-grid voxel occupancy: per-block IoU + FP/FN XOR split
# --------------------------------------------------------------------------

def _occupancy(mesh: trimesh.Trimesh, points: np.ndarray) -> np.ndarray:
    """mesh.contains over `points`, chunked to bound memory."""
    out = np.empty(len(points), dtype=bool)
    for i in range(0, len(points), _CONTAINS_CHUNK):
        out[i : i + _CONTAINS_CHUNK] = mesh.contains(points[i : i + _CONTAINS_CHUNK])
    return out


def _mask_regions(
    mask: np.ndarray, lo: np.ndarray, pitch: float, kind: str, top_n: int = 3
) -> list[dict]:
    """Connected components of a boolean voxel mask -> localised regions
    (world-space bbox + centroid + volume), largest first."""
    labels, n = ndimage.label(mask)
    if n == 0:
        return []
    counts = np.bincount(labels.ravel())[1:]  # skip background 0
    order = np.argsort(counts)[::-1][:top_n]
    regions = []
    for k in order:
        lbl = int(k) + 1
        idx = np.argwhere(labels == lbl)
        cmin = lo + (idx.min(axis=0)) * pitch
        cmax = lo + (idx.max(axis=0) + 1) * pitch
        centroid = lo + (idx.mean(axis=0) + 0.5) * pitch
        regions.append(
            {
                "kind": kind,
                "volume": round(float(counts[k]) * pitch**3, 4),
                "bbox": {
                    "min": [round(float(v), 4) for v in cmin],
                    "max": [round(float(v), 4) for v in cmax],
                },
                "centroid": [round(float(v), 4) for v in centroid],
            }
        )
    return regions


def voxel_region_iou(
    recon: trimesh.Trimesh,
    reference: trimesh.Trimesh,
    max_voxels: int = 400_000,
    block_grid: int = 6,
    worst_k: int = 5,
) -> dict:
    """Voxelise BOTH meshes on one common grid and localise the disagreement.

    Returns global voxel IoU, an NxNxN per-block IoU grid, the worst K blocks,
    and the voxel-XOR split into false-positive / false-negative volumes with
    their localising bboxes + centroids (via connected components).
    """
    pad = 1e-3
    lo = np.minimum(recon.bounds[0], reference.bounds[0]) - pad
    hi = np.maximum(recon.bounds[1], reference.bounds[1]) + pad
    extents = hi - lo
    pitch = float((np.prod(extents) / max_voxels) ** (1.0 / 3.0))
    axes = [lo[i] + (np.arange(int(np.ceil(extents[i] / pitch))) + 0.5) * pitch
            for i in range(3)]
    shape = tuple(len(a) for a in axes)
    grid = np.stack(np.meshgrid(*axes, indexing="ij"), axis=-1).reshape(-1, 3)

    in_recon = _occupancy(recon, grid).reshape(shape)
    in_ref = _occupancy(reference, grid).reshape(shape)

    inter = in_recon & in_ref
    union = in_recon | in_ref
    fp = in_recon & ~in_ref  # recon material the reference doesn't have
    fn = in_ref & ~in_recon  # reference material the recon is missing
    vox = pitch**3

    # coarse per-block IoU grid: split each axis' indices into block_grid runs
    splits = [np.array_split(np.arange(shape[i]), block_grid) for i in range(3)]
    block_iou: list = []
    worst: list[dict] = []
    for ix, sx in enumerate(splits[0]):
        plane = []
        for iy, sy in enumerate(splits[1]):
            row = []
            for iz, sz in enumerate(splits[2]):
                blk_i = inter[np.ix_(sx, sy, sz)].sum()
                blk_u = union[np.ix_(sx, sy, sz)].sum()
                if blk_u == 0:
                    row.append(None)  # empty block: no material in either mesh
                    continue
                iou = float(blk_i) / float(blk_u)
                row.append(round(iou, 4))
                center = [
                    float(lo[0] + (sx.mean() + 0.5) * pitch),
                    float(lo[1] + (sy.mean() + 0.5) * pitch),
                    float(lo[2] + (sz.mean() + 0.5) * pitch),
                ]
                worst.append(
                    {
                        "block": [ix, iy, iz],
                        "iou": round(iou, 4),
                        "center": [round(c, 4) for c in center],
                        "union_volume": round(float(blk_u) * vox, 4),
                        # mismatch volume = |recon XOR reference| in this block —
                        # ranking by it keeps tiny corner slivers (IoU 0 over a
                        # negligible union) from crowding out the real errors
                        "mismatch_volume": round(float(blk_u - blk_i) * vox, 4),
                    }
                )
            plane.append(row)
        block_iou.append(plane)
    worst.sort(key=lambda b: -b["mismatch_volume"])

    def _split_report(mask: np.ndarray, kind: str) -> dict:
        n = int(mask.sum())
        rep: dict = {"volume": round(n * vox, 4)}
        if n:
            idx = np.argwhere(mask)
            rep["bbox"] = {
                "min": [round(float(v), 4) for v in (lo + idx.min(axis=0) * pitch)],
                "max": [round(float(v), 4) for v in (lo + (idx.max(axis=0) + 1) * pitch)],
            }
            rep["centroid"] = [
                round(float(v), 4) for v in (lo + (idx.mean(axis=0) + 0.5) * pitch)
            ]
            rep["regions"] = _mask_regions(mask, lo, pitch, kind)
        return rep

    return {
        "pitch": round(pitch, 5),
        "grid_shape": list(shape),
        "voxel_iou": round(float(inter.sum()) / float(union.sum()), 4)
        if union.any()
        else 0.0,
        "block_grid": block_grid,
        "block_iou": block_iou,  # [ix][iy][iz], None = empty block
        "worst_blocks": worst[:worst_k],
        "false_positive": _split_report(fp, "false_positive"),
        "false_negative": _split_report(fn, "false_negative"),
    }


# --------------------------------------------------------------------------
# Surface distance
# --------------------------------------------------------------------------

def surface_distance(
    recon: trimesh.Trimesh, reference: trimesh.Trimesh, max_points: int = 200_000
) -> tuple[dict, np.ndarray]:
    """Bidirectional nearest-surface distances.

    Returns (stats dict, per-vertex recon->reference distances) — the second
    is consumed by eval/heatmap.py to paint the error onto the recon mesh.
    """

    def _dists(src: trimesh.Trimesh, dst: trimesh.Trimesh) -> np.ndarray:
        pts = src.vertices
        if len(pts) > max_points:  # keep huge meshes tractable
            pts = pts[np.random.default_rng(0).choice(len(pts), max_points, False)]
        _, d, _ = trimesh.proximity.closest_point(dst, pts)
        return d

    d_recon = _dists(recon, reference)  # per recon vertex (full, for heatmap)
    d_ref = _dists(reference, recon)
    both = np.concatenate([d_recon, d_ref])
    stats = {
        "hausdorff": round(float(both.max()), 4),
        "mean": round(float(both.mean()), 4),
        "p95": round(float(np.percentile(both, 95)), 4),
        "recon_to_reference": {
            "max": round(float(d_recon.max()), 4),
            "mean": round(float(d_recon.mean()), 4),
            "p95": round(float(np.percentile(d_recon, 95)), 4),
        },
        "reference_to_recon": {
            "max": round(float(d_ref.max()), 4),
            "mean": round(float(d_ref.mean()), 4),
            "p95": round(float(np.percentile(d_ref, 95)), 4),
        },
    }
    return stats, d_recon


# --------------------------------------------------------------------------
# Orchestrator + ranked summary
# --------------------------------------------------------------------------

def _error_summary(sweeps: dict, voxels: dict) -> list[dict]:
    """Ranked 'where & how much' list — the block the emitter loop reads.

    One entry per localised FP/FN region (largest volume first), each tagged
    with the section-sweep plane that best co-locates it.
    """
    regions: list[dict] = []
    for kind in ("false_positive", "false_negative"):
        for reg in voxels.get(kind, {}).get("regions", []):
            entry = dict(reg)
            # tag with the axis/plane of maximum same-signed section deviation
            # inside this region's extent (localises the error 1-dimensionally)
            best = None
            sign = 1.0 if kind == "false_positive" else -1.0
            for ax, name in enumerate(_AXES):
                sw = sweeps[name]
                coords = np.array(sw["coords"])
                diff = np.nan_to_num(np.array(sw["diff"]), nan=0.0)
                m = (coords >= reg["bbox"]["min"][ax]) & (coords <= reg["bbox"]["max"][ax])
                if not m.any():
                    continue
                signed = sign * diff * m  # only deviations of the region's kind
                i = int(np.argmax(signed))
                if signed[i] > 0 and (best is None or signed[i] > best["abs_diff"]):
                    best = {
                        "axis": name,
                        "coord": float(coords[i]),
                        "abs_diff": float(signed[i]),
                    }
            if best is not None:
                entry["section"] = {
                    "axis": best["axis"],
                    "coord": round(best["coord"], 4),
                    "area_diff": round(sign * best["abs_diff"], 4),
                }
            regions.append(entry)
    regions.sort(key=lambda r: -r["volume"])
    return regions


def localize_errors(
    recon: trimesh.Trimesh,
    reference: trimesh.Trimesh,
    n_planes: int = 64,
    max_voxels: int = 400_000,
    block_grid: int = 6,
) -> tuple[dict, np.ndarray]:
    """Full localized-error diagnostic. Returns (eval.json block, per-vertex
    recon->reference surface distances for the heatmap)."""
    sweeps = section_area_sweeps(recon, reference, n_planes=n_planes)
    voxels = voxel_region_iou(
        recon, reference, max_voxels=max_voxels, block_grid=block_grid
    )
    dist_stats, d_recon = surface_distance(recon, reference)
    localized = {
        "section_sweeps": sweeps,
        "voxel_regions": voxels,
        "surface_distance": dist_stats,
        "error_summary": _error_summary(sweeps, voxels),
    }
    return localized, d_recon
