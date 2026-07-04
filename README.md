# step2scad

**Automated STEP → parametric OpenSCAD reconstructor.**

Give it a STEP (`.step` / `.stp`) file; it produces a fully **parametric** OpenSCAD
`.scad` model that reconstructs the part to **≥95% IoU** against the original solid —
with no manual modelling.

The engine is a Claude (Fable 5) agent that runs an autonomous
analyse → build → render → measure → iterate loop. The agent prompt lives in
[`prompts/reconstruct.md`](prompts/reconstruct.md); the design is in
[`ARCHITECTURE.md`](ARCHITECTURE.md); the working rules the agent must obey are in
[`CLAUDE.md`](CLAUDE.md).

## Why STEP (not STL)

STEP is a **B-rep** format: it stores the *exact* analytic surfaces (planes,
cylinders, cones, spheres, tori/fillets, B-splines), their exact radii/axes/origins,
and the face/edge topology. Reconstruction reads ground-truth geometry instead of
guessing from a triangle soup — so exact parametric dimensions come out directly, and
95% IoU is a floor, not a stretch. See ARCHITECTURE.md § "Why STEP is easier than STL".

## Layout

```
models/        input STEP files (source of truth)
src/           reconstruction engine (B-rep reader, classifiers, .scad emitters)
prompts/       the Fable 5 agent prompt(s)
scripts/       CLI entry points / pipeline automation
templates/     approved, human-reviewed .scad reconstructions
eval/          IoU harness + regression cases
docs/          notes
tmp/           ALL generated output (.scad/.stl/.png/.json) — gitignored
```

## Quickstart

_Engine is under construction — see ARCHITECTURE.md for the target pipeline._

```bash
# (target CLI)
python -m step2scad models/e_nable_phoenix_hand_v3.step --out tmp/output --iou 0.95
```

## Status

- [x] Project scaffold
- [x] Seed model: `models/e_nable_phoenix_hand_v3.step`
- [ ] B-rep reader (OpenCASCADE / pythonocc / FreeCAD headless)
- [ ] Feature classifier (revolve / extrude / primitive-CSG / free-form)
- [ ] `.scad` emitter
- [ ] IoU eval harness
- [ ] Autonomous agent loop
