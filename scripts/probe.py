#!/usr/bin/env python3
"""Geometry-probe entry point that works without installing the package:

    python3 scripts/probe.py <model> <query> [args...] [--json] [--png PATH]

Equivalent to:  PYTHONPATH=src python3 -m step2scad.probe <model> <query> …
See the module docstring of src/step2scad/probe.py for the full query list.
"""

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent / "src"))

from step2scad.probe import main  # noqa: E402

if __name__ == "__main__":
    sys.exit(main())
