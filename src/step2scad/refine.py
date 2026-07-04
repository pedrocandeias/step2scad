"""Stage 6: REFINE — residual-driven targeted fixes (CLAUDE.md rule 6).

When the emitted reconstruction's IoU is below target, this loop reads the
localized-error report (section-area sweeps + FP/FN voxel regions) and turns
each residual into a concrete, targeted intervention instead of declaring a
ceiling. For a rotational body the primary lever is the RZ PROFILE: a
section-area surplus/deficit of Δarea at height z means the profile radius is
wrong at that z, and the exact first-order correction is

    dr = Δarea / (2π · r)        (surplus -> shrink the outer envelope or
                                  grow the bore; deficit -> the opposite)

Each candidate fix is applied as a profile-knot override (see
emit/revolve.py), re-emitted, re-rendered and RE-MEASURED; it is kept only if
the boolean IoU actually improves. The loop stops when the target is reached
or the targeted attempts are genuinely exhausted — and in that case it does
NOT go quiet: the log carries the remaining residual regions and the next
candidate fixes, for the human to decide.
"""

from __future__ import annotations

import math
from pathlib import Path

import numpy as np
import trimesh

from step2scad import render
from step2scad.emit import emit_scad, revolve
from step2scad.eval import evaluate, localize_errors

_AXES = ("x", "y", "z")
_MIN_AREA_DIFF = 0.5  # mm²: section deviations below this are tessellation noise
_MIN_IOU_GAIN = 1e-4  # a fix must improve the IoU by at least this to be kept
_BAND_FRAC = 0.25  # band grows while |diff| stays above this fraction of the peak


def _envelope_r(pts: list[list], z: float) -> float | None:
    """Boundary-chain radius at profile height z (max over covering pieces)."""
    best = None
    for (r0, z0, _), (r1, z1, _) in zip(pts, pts[1:]):
        lo, hi = min(z0, z1), max(z0, z1)
        if lo - 1e-9 <= z <= hi + 1e-9:
            if abs(z1 - z0) < 1e-9:
                r = max(r0, r1)
            else:
                r = r0 + (z - z0) / (z1 - z0) * (r1 - r0)
            best = r if best is None else max(best, r)
    return best


def maybe_refine(
    out: Path,
    slug: str,
    features: dict,
    classification: dict,
    ref_mesh: trimesh.Trimesh,
    report: dict,
    aligned: trimesh.Trimesh,
    openscad: str,
    icp: bool = False,
    target: float = 0.95,
    max_attempts: int = 6,
    log_fn=print,
):
    """Run the rule-6 refinement loop if the IoU is below `target`.

    Returns (log, report, aligned, vertex_dist): report/aligned are updated
    to the best kept fix (unchanged if none kept); vertex_dist is the
    recomputed per-vertex distance array when a fix was kept, else None
    (caller keeps its existing one).
    """
    log: dict = {
        "triggered": False,
        "target": target,
        "initial_iou": round(report["iou"], 6),
        "attempts": [],
        "kept_overrides": [],
    }
    if report["iou"] >= target:
        log["reason"] = (
            f"IoU {report['iou']:.4f} >= target {target} — analytic profile "
            "sufficient, no refinement needed"
        )
        return log, report, aligned, None

    rot = [
        c for c in classification["bodies"]
        if c["strategy"] == "rotate_extrude" and "axis" in c
    ]
    if not rot:
        log["reason"] = (
            "no rotate_extrude body — profile refinement not applicable; "
            "see localized.error_summary for the residual regions"
        )
        return log, report, aligned, None
    cls = rot[0]
    body = next(b for b in features["bodies"] if b["id"] == cls["body_id"])
    _, d = revolve.axis_frame(cls)
    k = int(np.argmax(np.abs(d)))
    if abs(d[k]) < 0.999:
        log["reason"] = (
            "revolve axis is not world-axis-aligned — the per-axis section "
            "sweeps cannot be mapped onto profile z"
        )
        return log, report, aligned, None
    try:
        prof = revolve.build_profile(body, cls)
    except ValueError as exc:
        log["reason"] = f"cannot rebuild the analytic profile ({exc})"
        return log, report, aligned, None

    log["triggered"] = True
    axname = _AXES[k]
    t_min = prof["t_min"]  # world coord (along +axis k) of profile z = 0

    best_report, best_aligned = report, aligned
    vertex_dist = None
    kept: list[dict] = []
    tried: set[tuple] = set()
    cand_scad = out / "refine_candidate.scad"
    cand_stl = out / "refine_candidate.stl"

    while best_report["iou"] < target and len(log["attempts"]) < max_attempts:
        sw = best_report["localized"]["section_sweeps"][axname]
        coords = np.asarray(sw["coords"], float)
        diff = np.nan_to_num(np.asarray(sw["diff"], float), nan=0.0)
        z = coords - t_min
        half = (coords[1] - coords[0]) / 2.0 if len(coords) > 1 else 0.1
        made_progress = False

        for i in np.argsort(-np.abs(diff)):
            if abs(diff[i]) < _MIN_AREA_DIFF:
                break  # everything left is noise-level
            sgn = np.sign(diff[i])
            lo = hi = int(i)
            while (lo > 0 and np.sign(diff[lo - 1]) == sgn
                   and abs(diff[lo - 1]) >= _BAND_FRAC * abs(diff[i])):
                lo -= 1
            while (hi < len(diff) - 1 and np.sign(diff[hi + 1]) == sgn
                   and abs(diff[hi + 1]) >= _BAND_FRAC * abs(diff[i])):
                hi += 1
            z0, z1 = float(z[lo] - half), float(z[hi] + half)
            band_mean = float(np.mean(diff[lo:hi + 1]))
            r_out = _envelope_r(prof["outer"], float(z[i]))
            r_in = _envelope_r(prof["inner"], float(z[i]))

            # surplus (diff > 0): shrink the outer envelope, or grow the bore;
            # deficit: the opposite. dr = Δarea / (2π r), exact to first order.
            candidates: list[tuple[str, float]] = []
            if r_out:
                candidates.append(("outer", -band_mean / (2.0 * math.pi * r_out)))
            if r_in:
                candidates.append(("inner", band_mean / (2.0 * math.pi * r_in)))

            for boundary, dr in candidates:
                key = (round(z0, 3), round(z1, 3), boundary)
                if key in tried:
                    continue
                tried.add(key)
                trial = kept + [
                    {"boundary": boundary, "z0": z0, "z1": z1, "dr": float(dr)}
                ]
                attempt = {
                    "boundary": boundary,
                    "z_band": [round(z0, 4), round(z1, 4)],
                    "dr": round(float(dr), 5),
                    "section_area_diff": round(band_mean, 3),
                }
                try:
                    scad_text = emit_scad(
                        features, classification, slug,
                        overrides={body["id"]: trial},
                    )
                    cand_scad.write_text(scad_text)
                    render.render_stl(cand_scad, cand_stl, openscad)
                    cand_mesh = trimesh.load(cand_stl, force="mesh")
                    rep2, aligned2 = evaluate(
                        cand_mesh, ref_mesh, icp_refine=icp, return_aligned=True
                    )
                except Exception as exc:
                    attempt["error"] = str(exc)
                    log["attempts"].append(attempt)
                    continue
                attempt["iou"] = round(rep2["iou"], 6)
                attempt["kept"] = rep2["iou"] > best_report["iou"] + _MIN_IOU_GAIN
                log["attempts"].append(attempt)
                log_fn(
                    f"refine: {boundary} z=[{z0:.2f},{z1:.2f}] dr={dr:+.4f} "
                    f"-> IoU {rep2['iou']:.4f} "
                    f"({'KEPT' if attempt['kept'] else 'reverted'})"
                )
                if attempt["kept"]:
                    kept = trial
                    localized2, vertex_dist = localize_errors(aligned2, ref_mesh)
                    rep2["localized"] = localized2
                    best_report, best_aligned = rep2, aligned2
                    # promote the candidate to the official outputs
                    (out / f"{slug}.scad").write_text(scad_text)
                    (out / f"{slug}_recon.stl").write_bytes(cand_stl.read_bytes())
                    made_progress = True
                    break
            if made_progress:
                break
        if not made_progress:
            break  # targeted candidates exhausted at this residual level

    for p in (cand_scad, cand_stl):
        p.unlink(missing_ok=True)

    log["kept_overrides"] = kept
    log["final_iou"] = round(best_report["iou"], 6)
    if best_report["iou"] < target:
        # Rule 6: do NOT declare a ceiling — surface the remaining residual
        # and the concrete fixes a human (or the next loop) should try.
        log["remaining_residual"] = best_report["localized"]["error_summary"][:5]
        log["next_candidate_fixes"] = [
            (
                f"{reg['kind']} {reg['volume']:.2f} mm³ at centroid "
                f"{reg['centroid']}"
                + (
                    f" — profile radius at {reg['section']['axis']}="
                    f"{reg['section']['coord']} (Δarea "
                    f"{reg['section']['area_diff']:+.1f} mm²)"
                    if reg.get("section")
                    else " — no section co-location; needs a primitive add/subtract"
                )
            )
            for reg in best_report["localized"]["error_summary"][:5]
        ]
    return log, best_report, best_aligned, vertex_dist
