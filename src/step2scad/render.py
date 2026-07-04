"""Stage 4: EXPORT — render .scad to STL / PNG via the OpenSCAD binary."""

from __future__ import annotations

import os
import shutil
import subprocess
from pathlib import Path

_DEFAULT_CANDIDATES = ("/home/pec/bin/openscad", "openscad")


def find_openscad(explicit: str | None = None) -> str:
    if explicit:
        return explicit
    env = os.environ.get("STEP2SCAD_OPENSCAD")
    if env:
        return env
    for cand in _DEFAULT_CANDIDATES:
        found = shutil.which(cand) or (cand if Path(cand).is_file() else None)
        if found:
            return found
    raise FileNotFoundError("openscad binary not found (set STEP2SCAD_OPENSCAD)")


def _run(cmd: list[str], timeout: int) -> None:
    proc = subprocess.run(cmd, capture_output=True, text=True, timeout=timeout)
    if proc.returncode != 0:
        raise RuntimeError(
            f"openscad failed ({proc.returncode}): {' '.join(cmd)}\n{proc.stderr[-2000:]}"
        )


def render_stl(scad: Path, stl: Path, openscad: str, timeout: int = 600) -> Path:
    stl.parent.mkdir(parents=True, exist_ok=True)
    _run([openscad, "-o", str(stl), str(scad)], timeout)
    return stl


def render_png(
    scad: Path,
    png: Path,
    openscad: str,
    imgsize: str = "800,800",
    camera: str | None = None,
    timeout: int = 300,
) -> Path:
    png.parent.mkdir(parents=True, exist_ok=True)
    cmd = [openscad, "-o", str(png), f"--imgsize={imgsize}", "--autocenter", "--viewall"]
    if camera:
        cmd.append(f"--camera={camera}")
    cmd.append(str(scad))
    _run(cmd, timeout)
    return png
