"""CLI: python -m step2scad <file.step> [--out output] [--until STAGE] …"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

from step2scad.pipeline import STAGES, run_pipeline


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(
        prog="step2scad",
        description="STEP -> parametric OpenSCAD reconstruction pipeline "
        "(ingest -> classify -> emit -> export -> eval).",
    )
    parser.add_argument("step", help="input .step/.stp file")
    parser.add_argument(
        "--out", default="output", help="output root directory (default: output/, kept in the project)"
    )
    parser.add_argument("--name", default=None, help="output slug (default: STEP stem)")
    parser.add_argument(
        "--until",
        choices=STAGES,
        default="eval",
        help="run the pipeline only up to this stage (default: eval = full run)",
    )
    parser.add_argument("--openscad", default=None, help="path to the openscad binary")
    parser.add_argument(
        "--plan",
        default=None,
        help="agent-authored plan.json: per-body strategy + measured CSG plan "
        "(overrides the heuristic classification; see step2scad/plan.py)",
    )
    parser.add_argument(
        "--icp", action="store_true", help="enable ICP refinement after coarse alignment"
    )
    args = parser.parse_args(argv)

    if not Path(args.step).is_file():
        parser.error(f"no such file: {args.step}")

    summary = run_pipeline(
        args.step,
        out_dir=args.out,
        name=args.name,
        until=args.until,
        openscad=args.openscad,
        icp=args.icp,
        plan=args.plan,
    )

    print("\n=== step2scad summary ===")
    print(json.dumps({k: v for k, v in summary.items() if k != "stages"}, indent=2))
    if "iou" in summary:
        iou = summary["iou"]
        verdict = "PASS (>= 0.95)" if iou >= 0.95 else "BELOW TARGET (< 0.95)"
        print(f"IoU = {iou:.4f}  ->  {verdict}")
        if iou < 0.95:
            print(
                "(see eval.json 'refine' log + localized.error_summary for the "
                "remaining residual regions and next candidate fixes)"
            )
    return 0


if __name__ == "__main__":
    sys.exit(main())
