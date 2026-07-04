"""Pipeline orchestrator: ingest -> classify -> emit -> export -> eval -> refine.

All artifacts land under <out>/<slug>/ (default output/<slug>/, kept in the project):

    features.json        exact B-rep feature extraction + face adjacency (stage 1)
    classification.json  per-body strategy + reasoning     (stage 2)
    <slug>.scad          emitted parametric model          (stage 3)
    <slug>_recon.stl     openscad render of the .scad      (stage 4)
    <slug>_ref.stl       high-res tessellation of the STEP (ground truth)
    eval.json            IoU + localized errors + assertions + refine log (stages 5-6)
    preview_*.png        renders of recon + ghost overlay
    heatmap.png/.ply     recon surface coloured by distance-to-reference
    sections.png         per-axis section-area sweep curves (recon vs ref)
"""

from __future__ import annotations

import json
import time
from pathlib import Path

import trimesh

from step2scad import render
from step2scad.classify import classify_bodies
from step2scad.emit import emit_scad
from step2scad.eval import (
    evaluate,
    localize_errors,
    plot_section_sweeps,
    render_heatmap,
    run_assertions,
)
from step2scad.ingest import extract_features, read_step, shape_to_trimesh
from step2scad.refine import maybe_refine

STAGES = ("ingest", "classify", "emit", "export", "eval")


def _write_json(path: Path, data: dict) -> None:
    path.write_text(json.dumps(data, indent=2))


def run_pipeline(
    step_path: str | Path,
    out_dir: str | Path = "output",
    name: str | None = None,
    until: str = "eval",
    openscad: str | None = None,
    icp: bool = False,
) -> dict:
    """Run the pipeline on one STEP file up to stage `until`. Returns summary."""
    step_path = Path(step_path)
    slug = name or step_path.stem.replace(" ", "_")
    out = Path(out_dir) / slug
    out.mkdir(parents=True, exist_ok=True)
    stop = STAGES.index(until)
    summary: dict = {"source": str(step_path), "out_dir": str(out), "stages": {}}

    def _log(msg: str) -> None:
        print(f"[step2scad] {msg}")

    # ---- 1. INGEST (exact B-rep feature extraction) ----
    t0 = time.perf_counter()
    shape = read_step(step_path)
    features = extract_features(shape, source=str(step_path))
    _write_json(out / "features.json", features)
    dt = time.perf_counter() - t0
    n_faces = sum(b["n_faces"] for b in features["bodies"])
    _log(f"ingest: {features['n_bodies']} bodies, {n_faces} faces in {dt:.2f}s "
         f"-> {out / 'features.json'}")
    summary["stages"]["ingest"] = {
        "seconds": round(dt, 3),
        "n_bodies": features["n_bodies"],
        "n_faces": n_faces,
    }
    if stop < STAGES.index("classify"):
        return summary

    # ---- 2. CLASSIFY (strategy heuristics) ----
    t0 = time.perf_counter()
    classification = classify_bodies(features)
    _write_json(out / "classification.json", classification)
    for c in classification["bodies"]:
        _log(f"classify: body {c['body_id']} -> {c['strategy']}  ({c['reasoning']})")
    summary["stages"]["classify"] = {
        "seconds": round(time.perf_counter() - t0, 3),
        "strategies": {str(c["body_id"]): c["strategy"] for c in classification["bodies"]},
    }
    if stop < STAGES.index("emit"):
        return summary

    # ---- 3. EMIT (.scad — placeholder emitters for now) ----
    t0 = time.perf_counter()
    scad_text = emit_scad(features, classification, slug)
    scad_path = out / f"{slug}.scad"
    scad_path.write_text(scad_text)
    _log(f"emit: wrote {scad_path} (dispatch: rotate_extrude -> exact RZ profile; "
         "other strategies -> placeholder stubs)")
    summary["stages"]["emit"] = {
        "seconds": round(time.perf_counter() - t0, 3),
        "scad": str(scad_path),
    }
    if stop < STAGES.index("export"):
        return summary

    # ---- 4. EXPORT (openscad .scad -> STL, plus PNG previews) ----
    t0 = time.perf_counter()
    osc = render.find_openscad(openscad)
    recon_stl = render.render_stl(scad_path, out / f"{slug}_recon.stl", osc)
    render.render_png(scad_path, out / "preview_iso.png", osc)
    render.render_png(scad_path, out / "preview_top.png", osc, camera="0,0,0,0,0,0,100")
    _log(f"export: {recon_stl} + previews via {osc}")
    summary["stages"]["export"] = {
        "seconds": round(time.perf_counter() - t0, 3),
        "stl": str(recon_stl),
    }
    if stop < STAGES.index("eval"):
        return summary

    # ---- 5. EVAL (tessellate original, align, boolean IoU) ----
    t0 = time.perf_counter()
    ref_mesh = shape_to_trimesh(shape)
    ref_stl = out / f"{slug}_ref.stl"
    ref_mesh.export(ref_stl)
    cand_mesh = trimesh.load(recon_stl, force="mesh")
    report, aligned = evaluate(cand_mesh, ref_mesh, icp_refine=icp, return_aligned=True)
    _log(
        f"eval: IoU = {report['iou']:.4f}  "
        f"(∩ {report['intersection_volume']:.2f} / ∪ {report['union_volume']:.2f} mm³, "
        f"align={report['alignment']}, method={report['method']})"
    )

    # ---- 5b. LOCALIZED DIAGNOSTICS (where is the error, and which way) ----
    localized, vertex_dist = localize_errors(aligned, ref_mesh)
    report["localized"] = localized
    dist = localized["surface_distance"]
    _log(
        f"eval: voxel IoU = {localized['voxel_regions']['voxel_iou']:.4f}  "
        f"FP vol = {localized['voxel_regions']['false_positive']['volume']:.2f} mm³  "
        f"FN vol = {localized['voxel_regions']['false_negative']['volume']:.2f} mm³  "
        f"surface dist: hausdorff {dist['hausdorff']:.3f} / mean {dist['mean']:.3f} mm"
    )

    # ---- 6. REFINE (rule 6: residual-driven targeted profile fixes) ----
    refine_log, report, aligned, refined_vd = maybe_refine(
        out, slug, features, classification, ref_mesh, report, aligned, osc,
        icp=icp, log_fn=_log,
    )
    report["refine"] = refine_log
    if refine_log["kept_overrides"]:
        vertex_dist = refined_vd
        localized = report["localized"]
        dist = localized["surface_distance"]
        # the .scad/_recon.stl changed on disk -> refresh the previews too
        render.render_png(scad_path, out / "preview_iso.png", osc)
        render.render_png(
            scad_path, out / "preview_top.png", osc, camera="0,0,0,0,0,0,100"
        )
        _log(
            f"refine: kept {len(refine_log['kept_overrides'])} profile fix(es) "
            f"-> IoU {refine_log['initial_iou']:.4f} -> {refine_log['final_iou']:.4f}"
        )
    else:
        _log(f"refine: {refine_log.get('reason', 'no fix improved the IoU')}")

    # ---- 5c. PROPERTY ASSERTIONS (structure the IoU can't see) ----
    assertions = run_assertions(aligned, ref_mesh, features=features)
    report["assertions"] = assertions
    report["seconds"] = round(time.perf_counter() - t0, 3)
    _write_json(out / "eval.json", report)

    # ---- 5d. DIAGNOSTIC IMAGES (heatmap + section sweeps + ghost overlay) ----
    hm = render_heatmap(
        aligned,
        vertex_dist,
        out / f"{slug}_heatmap.png",
        out_ply=out / f"{slug}_heatmap.ply",
        title=f"{slug}: recon -> reference surface distance",
    )
    plot_section_sweeps(localized["section_sweeps"], out / f"{slug}_sections.png")
    _log(f"eval: heatmap -> {hm['png']} (max {hm['max']} mm), "
         f"sweeps -> {out / f'{slug}_sections.png'}")

    # Ghost overlay preview: original as transparent ghost + reconstruction.
    overlay = out / "preview_overlay.scad"
    overlay.write_text(
        f'%import("{ref_stl.name}");\nimport("{recon_stl.name}");\n'
    )
    render.render_png(overlay, out / "preview_overlay.png", osc)

    # ---- printed diagnosis: the ranked "where & how much" + assertions ----
    print("\n--- localized diagnosis (top error regions) ---")
    for i, reg in enumerate(localized["error_summary"][:5]):
        sect = reg.get("section")
        sect_txt = (
            f", section {sect['axis']}={sect['coord']} (Δarea {sect['area_diff']:+.1f} mm²)"
            if sect
            else ""
        )
        print(
            f"  {i + 1}. {reg['kind']}  {reg['volume']:.2f} mm³  "
            f"centroid {reg['centroid']}{sect_txt}"
        )
    print(f"--- assertions: {assertions['n_passed']}/{assertions['n_total']} passed ---")
    for c in assertions["checks"]:
        mark = "PASS" if c["passed"] else "FAIL"
        print(f"  [{mark}] {c['name']}: actual={c['actual']}  expected={c['expected']}")

    summary["stages"]["eval"] = report
    summary["iou"] = report["iou"]
    return summary
