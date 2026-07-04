"""Stage 5d: PROPERTY ASSERTIONS — structural checks a volume IoU can miss.

A reconstruction can score a decent IoU while being structurally wrong: not
watertight, missing a through-hole (wrong genus), broken symmetry, a shifted
bbox. Each check returns {name, passed, actual, expected, detail} so the
result is both machine-gateable and human-auditable in eval.json.

Checks (recon = ALIGNED candidate):
    watertight            recon and reference are watertight/manifold
    volume                recon volume within tolerance of reference volume
    bbox                  per-axis bounding-box match within tolerance
    topology              body count + Euler characteristic (=> genus / number
                          of through-holes) match
    symmetry              reference mirror-symmetry about each principal plane
                          (sampled self-containment) — recon must be symmetric
                          about exactly the same planes
    bore_count            expected number of distinct bores (reversed cylinder
                          faces in the reference B-rep, optionally filtered by
                          radius) vs the recon's through-hole count (genus)
"""

from __future__ import annotations

import numpy as np
import trimesh

_SYM_SAMPLES = 4000
_SYM_THRESHOLD = 0.95  # containment fraction above which a plane counts as symmetric


def _check(name: str, passed: bool, actual, expected, detail: str = "") -> dict:
    return {
        "name": name,
        "passed": bool(passed),
        "actual": actual,
        "expected": expected,
        "detail": detail,
    }


def _genus(mesh: trimesh.Trimesh) -> int:
    """Genus (number of through-holes/handles) from the Euler characteristic:
    chi = 2*(bodies - genus) for a closed orientable surface."""
    return int(round(mesh.body_count - mesh.euler_number / 2))


def _mirror_containment(mesh: trimesh.Trimesh, point: np.ndarray, normal: np.ndarray) -> float:
    """Fraction of volume samples whose mirror image (about the plane
    point/normal) is still inside the mesh — a fast mirror-self-IoU proxy."""
    try:
        pts = trimesh.sample.volume_mesh(mesh, _SYM_SAMPLES)
        if len(pts) == 0:
            return 0.0
        mirrored = pts - 2.0 * np.outer((pts - point) @ normal, normal)
        return float(mesh.contains(mirrored).mean())
    except Exception:
        return 0.0


def _principal_planes(mesh: trimesh.Trimesh) -> list[tuple[str, np.ndarray, np.ndarray]]:
    """The three principal planes (centroid + inertia axis normals)."""
    axes = np.array(mesh.principal_inertia_vectors, dtype=float)
    c = np.asarray(mesh.center_mass, dtype=float)
    return [(f"principal[{i}]", c, axes[i] / np.linalg.norm(axes[i])) for i in range(3)]


def _reference_bores(features: dict, radius: float | None, radius_tol: float) -> list[dict]:
    """Distinct bores in the reference B-rep: reversed (inward-facing)
    cylinder faces clustered by axis, optionally filtered by radius."""
    bores: list[dict] = []
    for body in features.get("bodies", []):
        for f in body.get("faces", []):
            if f.get("type") != "cylinder" or f.get("orientation") != "reversed":
                continue
            r = float(f["params"]["radius"])
            if radius is not None and abs(r - radius) > radius_tol:
                continue
            o = np.asarray(f["params"]["axis_origin"], float)
            d = np.asarray(f["params"]["axis_dir"], float)
            d = d / np.linalg.norm(d)
            for b in bores:  # coaxial faces = one bore
                if abs(abs(float(np.dot(b["dir"], d))) - 1.0) > 1e-4:
                    continue
                w = o - b["origin"]
                if float(np.linalg.norm(w - np.dot(w, b["dir"]) * b["dir"])) < 1e-3:
                    b["faces"].append(f["index"])
                    break
            else:
                bores.append(
                    {"origin": o, "dir": d, "radius": r, "faces": [f["index"]]}
                )
    return bores


def run_assertions(
    recon: trimesh.Trimesh,
    reference: trimesh.Trimesh,
    features: dict | None = None,
    volume_tol: float = 0.05,
    bbox_tol: float = 0.5,
    bore_radius: float | None = None,
    bore_radius_tol: float = 0.05,
) -> dict:
    """Run all property assertions; returns {passed, n_passed, n_total, checks}."""
    checks: list[dict] = []

    # -- watertight / manifold ------------------------------------------------
    checks.append(
        _check(
            "recon_watertight",
            recon.is_watertight,
            bool(recon.is_watertight),
            True,
            "trimesh is_watertight (closed, manifold surface)",
        )
    )
    checks.append(
        _check(
            "reference_watertight",
            reference.is_watertight,
            bool(reference.is_watertight),
            True,
            "ground-truth tessellation should itself be closed",
        )
    )

    # -- volume ---------------------------------------------------------------
    ref_vol, rec_vol = float(reference.volume), float(recon.volume)
    vol_err = abs(rec_vol - ref_vol) / ref_vol if ref_vol else float("inf")
    checks.append(
        _check(
            "volume",
            vol_err <= volume_tol,
            {"recon": round(rec_vol, 3), "reference": round(ref_vol, 3),
             "error_pct": round(vol_err * 100, 2)},
            f"within {volume_tol:.0%} of reference",
            f"signed error {100 * (rec_vol - ref_vol) / ref_vol:+.2f}%"
            if ref_vol
            else "reference volume is zero",
        )
    )

    # -- bounding box per axis ------------------------------------------------
    delta_min = np.abs(recon.bounds[0] - reference.bounds[0])
    delta_max = np.abs(recon.bounds[1] - reference.bounds[1])
    per_axis = np.maximum(delta_min, delta_max)
    checks.append(
        _check(
            "bbox",
            bool((per_axis <= bbox_tol).all()),
            {"max_corner_delta_mm": [round(float(v), 4) for v in per_axis]},
            f"every axis within {bbox_tol} mm",
            f"recon bounds {np.round(recon.bounds, 3).tolist()} vs "
            f"reference {np.round(reference.bounds, 3).tolist()}",
        )
    )

    # -- topology: bodies + Euler characteristic => genus ----------------------
    rec_topo = {"bodies": int(recon.body_count), "euler": int(recon.euler_number),
                "genus": _genus(recon)}
    ref_topo = {"bodies": int(reference.body_count), "euler": int(reference.euler_number),
                "genus": _genus(reference)}
    checks.append(
        _check(
            "topology",
            rec_topo == ref_topo,
            rec_topo,
            ref_topo,
            "genus = number of through-holes; a mismatch means a hole is "
            "missing, extra, or unmerged",
        )
    )

    # -- mirror symmetry about the reference's principal planes ----------------
    sym_ref, sym_rec, sym_ok = [], [], True
    for label, point, normal in _principal_planes(reference):
        ref_score = _mirror_containment(reference, point, normal)
        rec_score = _mirror_containment(recon, point, normal)
        ref_sym = ref_score >= _SYM_THRESHOLD
        rec_sym = rec_score >= _SYM_THRESHOLD
        sym_ref.append({"plane": label, "normal": [round(float(v), 4) for v in normal],
                        "score": round(ref_score, 4), "symmetric": ref_sym})
        sym_rec.append({"plane": label, "score": round(rec_score, 4),
                        "symmetric": rec_sym})
        if ref_sym and not rec_sym:
            sym_ok = False  # recon broke a symmetry the reference has
    checks.append(
        _check(
            "symmetry",
            sym_ok,
            {"recon": sym_rec},
            {"reference": sym_ref},
            "mirror-containment score per reference principal plane; recon must "
            "preserve every reference symmetry (threshold "
            f"{_SYM_THRESHOLD})",
        )
    )

    # -- bore count (needs the B-rep features) ----------------------------------
    if features is not None:
        bores = _reference_bores(features, bore_radius, bore_radius_tol)
        expected = len(bores)
        actual = _genus(recon)
        checks.append(
            _check(
                "bore_count",
                actual == expected,
                actual,
                expected,
                "reference bores = distinct reversed-cylinder axes in the B-rep"
                + (f" at radius {bore_radius}±{bore_radius_tol}" if bore_radius else "")
                + f" (radii: {[round(b['radius'], 3) for b in bores]}); "
                "recon count = mesh genus (through-holes)",
            )
        )

    n_passed = sum(c["passed"] for c in checks)
    return {
        "passed": n_passed == len(checks),
        "n_passed": n_passed,
        "n_total": len(checks),
        "checks": checks,
    }
