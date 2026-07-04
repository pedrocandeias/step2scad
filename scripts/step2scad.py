#!/usr/bin/env python3
"""Entry point that works without installing the package:

    python3 scripts/step2scad.py models/F695-2Z.step [--out tmp/output]

Equivalent to:  PYTHONPATH=src python3 -m step2scad <step> …
"""

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent / "src"))

from step2scad.cli import main  # noqa: E402

if __name__ == "__main__":
    sys.exit(main())
