#!/usr/bin/env python3
"""Split a STEP assembly into per-component STEP files (one per named leaf part).

Reads the assembly's product structure (via XCAF / STEPCAFControl) so components
come out with their real names -- Arm_Guard.step, Palm_left.step, Distals.step, ...
By default each component is re-centered to its own origin (XY centered, bottom face
on Z=0), matching the workspace "models at origin" convention; pass --no-recenter to
keep the original assembly placement.

A `manifest.json` is written alongside the components recording each part's original
placement + the translation needed to put a reconstructed part BACK into the assembly.
`scripts/reassemble.py` consumes it to rebuild the whole model after reconstruction.

Usage:
    python3 scripts/split_step.py <assembly.step> <out_dir> [--no-recenter]

Example:
    python3 scripts/split_step.py models/e_nable_phoenix_hand_v3.step models/phoenix_components
"""
from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path

from OCP.Bnd import Bnd_Box
from OCP.BRepBndLib import BRepBndLib
from OCP.BRepBuilderAPI import BRepBuilderAPI_Transform
from OCP.gp import gp_Trsf, gp_Vec
from OCP.STEPCAFControl import STEPCAFControl_Reader
from OCP.STEPControl import STEPControl_AsIs, STEPControl_Writer
from OCP.TCollection import TCollection_AsciiString, TCollection_ExtendedString
from OCP.TDataStd import TDataStd_Name
from OCP.TDF import TDF_Label, TDF_LabelSequence
from OCP.TDocStd import TDocStd_Document
from OCP.TopAbs import TopAbs_SOLID
from OCP.TopExp import TopExp_Explorer
from OCP.XCAFDoc import XCAFDoc_DocumentTool, XCAFDoc_ShapeTool


def _name_of(label: TDF_Label) -> str:
    n = TDataStd_Name()
    if label.FindAttribute(TDataStd_Name.GetID_s(), n):
        return TCollection_AsciiString(n.Get()).ToCString()
    return "unnamed"


def _slugify(s: str) -> str:
    return re.sub(r"[^A-Za-z0-9]+", "_", s).strip("_") or "part"


def _n_solids(shape) -> int:
    n = 0
    ex = TopExp_Explorer(shape, TopAbs_SOLID)
    while ex.More():
        n += 1
        ex.Next()
    return n


def _bbox(shape):
    box = Bnd_Box()
    BRepBndLib.Add_s(shape, box, True)
    xmin, ymin, zmin, xmax, ymax, zmax = box.Get()
    return [xmin, ymin, zmin], [xmax, ymax, zmax]


def _translate(shape, vec):
    trsf = gp_Trsf()
    trsf.SetTranslation(gp_Vec(*vec))
    return BRepBuilderAPI_Transform(shape, trsf, True).Shape()


def split_assembly(src: str | Path, out_dir: str | Path, recenter: bool = True) -> dict:
    src, out_dir = str(src), Path(out_dir)
    out_dir.mkdir(parents=True, exist_ok=True)

    doc = TDocStd_Document(TCollection_ExtendedString("doc"))
    reader = STEPCAFControl_Reader()
    reader.SetNameMode(True)
    reader.ReadFile(src)
    reader.Transfer(doc)
    tool = XCAFDoc_DocumentTool.ShapeTool_s(doc.Main())

    def resolve(label: TDF_Label) -> TDF_Label:
        if tool.IsReference_s(label):
            ref = TDF_Label()
            XCAFDoc_ShapeTool.GetReferredShape_s(label, ref)
            return ref
        return label

    leaves: list[tuple[str, object]] = []

    def walk(label: TDF_Label) -> None:
        real = resolve(label)
        if tool.IsAssembly_s(real):
            comps = TDF_LabelSequence()
            tool.GetComponents_s(real, comps)
            for i in range(1, comps.Length() + 1):
                walk(comps.Value(i))
        else:
            leaves.append((_name_of(real), tool.GetShape_s(real)))

    free = TDF_LabelSequence()
    tool.GetFreeShapes(free)
    for i in range(1, free.Length() + 1):
        walk(free.Value(i))

    components = []
    seen: dict[str, int] = {}
    for name, shape in leaves:
        mn, mx = _bbox(shape)
        # recenter: XY-centered, bottom (min Z) on Z=0. Pure translation, so the
        # inverse (restore) that reassembly applies is just the negated offset.
        if recenter:
            offset = [-(mn[0] + mx[0]) / 2.0, -(mn[1] + mx[1]) / 2.0, -mn[2]]
            shape = _translate(shape, offset)
        else:
            offset = [0.0, 0.0, 0.0]
        restore = [-offset[0], -offset[1], -offset[2]]

        base = _slugify(name)
        seen[base] = seen.get(base, 0) + 1
        stem = base if seen[base] == 1 else f"{base}_{seen[base]}"
        path = out_dir / f"{stem}.step"
        writer = STEPControl_Writer()
        writer.Transfer(shape, STEPControl_AsIs)
        writer.Write(str(path))
        components.append({
            "name": name,
            "file": path.name,
            "n_solids": _n_solids(shape),
            "original_bbox": {"min": mn, "max": mx},
            "recenter_offset": offset,     # applied to the original to move it to origin
            "restore_translation": restore,  # apply to a reconstructed part to put it back
        })
        print(f"{path.name:26s} solids={components[-1]['n_solids']:<3d} "
              f"{path.stat().st_size // 1024}KB  restore={[round(v, 2) for v in restore]}")

    manifest = {
        "source": src,
        "recentered": recenter,
        "n_components": len(components),
        "components": components,
    }
    (out_dir / "manifest.json").write_text(json.dumps(manifest, indent=2))
    return manifest


def main(argv: list[str] | None = None) -> int:
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("assembly", help="input assembly .step/.stp")
    ap.add_argument("out_dir", help="directory to write component .step files into")
    ap.add_argument(
        "--no-recenter",
        action="store_true",
        help="keep original assembly placement instead of moving each part to origin",
    )
    args = ap.parse_args(argv)
    if not Path(args.assembly).is_file():
        ap.error(f"no such file: {args.assembly}")
    m = split_assembly(args.assembly, args.out_dir, recenter=not args.no_recenter)
    where = "origin-centered" if m["recentered"] else "as-placed"
    print(f"\n{m['n_components']} components ({where}) + manifest.json -> {args.out_dir}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
