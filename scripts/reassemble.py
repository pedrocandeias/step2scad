#!/usr/bin/env python3
"""Reassemble reconstructed components back into the full model, using the manifest
written by split_step.py to restore each part's original assembly placement.

For every component in the manifest it resolves a reconstructed artifact from
<recon_dir> (searching common layouts), stages it to an STL, and writes a master
`assembly.scad` that `translate()`s each part back to its assembly position.

Resolution order per component stem (e.g. "Distals"):
    <recon_dir>/<stem>/<stem>_recon.stl      (pipeline output layout)
    <recon_dir>/<stem>/<stem>.scad
    <recon_dir>/<stem>.stl | .scad | .step   (flat / round-trip stand-in)

Usage:
    python3 scripts/reassemble.py <manifest.json> [--recon-dir DIR] [--out FILE]
                                  [--validate ORIGINAL.step] [--openscad PATH]

If --recon-dir is omitted it defaults to the manifest's own directory, so pointing it
at the split components round-trips the ORIGINAL parts (a placement sanity check).
--validate tessellates the reassembled parts and reports bbox / volume / IoU vs the
original assembly.
"""
from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

import trimesh

sys.path.insert(0, str(Path(__file__).resolve().parent.parent / "src"))
from step2scad import render  # noqa: E402
from step2scad.ingest import read_step, shape_to_trimesh  # noqa: E402


def _resolve(recon_dir: Path, stem: str) -> Path | None:
    candidates = [
        recon_dir / stem / f"{stem}_recon.stl",
        recon_dir / stem / f"{stem}.scad",
        recon_dir / f"{stem}.stl",
        recon_dir / f"{stem}.scad",
        recon_dir / f"{stem}.step",
        recon_dir / f"{stem}.stp",
    ]
    return next((c for c in candidates if c.is_file()), None)


def _to_mesh(src: Path, osc: str | None) -> trimesh.Trimesh:
    ext = src.suffix.lower()
    if ext in (".step", ".stp"):
        return shape_to_trimesh(read_step(src))
    if ext == ".scad":
        stl = src.with_suffix(".stl")
        render.render_stl(src, stl, render.find_openscad(osc))
        return trimesh.load(stl, force="mesh")
    return trimesh.load(src, force="mesh")


def reassemble(manifest_path, recon_dir=None, out=None, validate=None, openscad=None):
    manifest_path = Path(manifest_path)
    manifest = json.loads(manifest_path.read_text())
    recon_dir = Path(recon_dir) if recon_dir else manifest_path.parent
    out = Path(out) if out else Path("output/assembly/assembly.scad")
    out.parent.mkdir(parents=True, exist_ok=True)
    parts_dir = out.parent / "_parts"
    parts_dir.mkdir(exist_ok=True)

    lines = ["// reassembled from " + str(recon_dir), "union() {"]
    placed, missing, meshes = [], [], []
    for c in manifest["components"]:
        stem = Path(c["file"]).stem
        src = _resolve(recon_dir, stem)
        if src is None:
            missing.append(stem)
            continue
        mesh = _to_mesh(src, openscad)
        stl = parts_dir / f"{stem}.stl"
        mesh.export(stl)
        tx, ty, tz = c["restore_translation"]
        lines.append(f'  translate([{tx:.6g}, {ty:.6g}, {tz:.6g}]) '
                     f'import("_parts/{stem}.stl");')
        placed.append(stem)
        if validate:
            m = mesh.copy()
            m.apply_translation(c["restore_translation"])
            meshes.append(m)
        print(f"placed {stem:22s} <- {src.relative_to(recon_dir) if src.is_relative_to(recon_dir) else src}")
    lines.append("}")
    out.write_text("\n".join(lines) + "\n")
    print(f"\n{len(placed)} parts -> {out}" + (f"   MISSING: {missing}" if missing else ""))

    if validate:
        combined = trimesh.util.concatenate(meshes)
        original = shape_to_trimesh(read_step(validate))
        cb, ob = combined.bounds, original.bounds
        bbox_delta = [round(float(abs(cb[i][j] - ob[i][j])), 4)
                      for i in range(2) for j in range(3)]
        print("\n=== validate vs original assembly ===")
        print(f"  reassembled bbox {combined.bounds.tolist()}")
        print(f"  original    bbox {original.bounds.tolist()}")
        print(f"  max bbox corner delta: {max(bbox_delta):.4f} mm")
        print(f"  volume: reassembled {combined.volume:.1f} vs original "
              f"{original.volume:.1f} mm3 ({100*(combined.volume/original.volume-1):+.2f}%)")
        try:
            from step2scad.eval import evaluate
            rep = evaluate(combined, original)
            print(f"  IoU = {rep['iou']:.4f}")
        except Exception as e:  # noqa: BLE001
            print(f"  (IoU skipped: {e})")
    return out


def main(argv=None) -> int:
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("manifest", help="manifest.json written by split_step.py")
    ap.add_argument("--recon-dir", default=None,
                    help="dir with reconstructed parts (default: manifest's dir)")
    ap.add_argument("--out", default=None, help="master assembly .scad (default: output/assembly/assembly.scad)")
    ap.add_argument("--validate", default=None, metavar="ORIGINAL.step",
                    help="compare the reassembled parts to the original assembly")
    ap.add_argument("--openscad", default=None, help="path to openscad binary")
    args = ap.parse_args(argv)
    if not Path(args.manifest).is_file():
        ap.error(f"no such manifest: {args.manifest}")
    reassemble(args.manifest, args.recon_dir, args.out, args.validate, args.openscad)
    return 0


if __name__ == "__main__":
    sys.exit(main())
