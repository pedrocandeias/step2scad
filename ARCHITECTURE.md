# step2scad — Architecture

## Goal

`STEP file  ──▶  parametric .scad reconstruction  @ ≥95% IoU`, fully automated.

## Why STEP is easier than STL

| | STL | STEP |
|---|---|---|
| Data | triangle soup (approximation) | exact B-rep: analytic surfaces + topology |
| A hole is… | ~hundreds of triangles to fit | one cylindrical face with an *exact* radius + axis |
| A fillet is… | inferred from curvature | a torus/blend face with *exact* major/minor radii |
| A flat is… | many coplanar tris | one plane face with an *exact* normal + origin |
| Dimensions | measured/estimated | **read directly** |
| Parametric out | needs fitting/optimisation | falls out of the B-rep |

STL reconstruction (the sibling `openscad-parametric-reconstructor` workspace) has to
recover geometry by ray-cast occupancy maps, section sweeps and high-density vertex
morphing, and 95% IoU is *hard-won*. With STEP the exact numbers are in the file, so
95% is a **floor**. The engine's job is: read the exact surfaces, decide the cleanest
parametric expression, emit readable `.scad`, and verify.

## Pipeline

```
                ┌─────────────┐
  models/*.step │  1. INGEST  │  B-rep reader (OpenCASCADE / FreeCAD headless)
                └──────┬──────┘  → per-solid: faces (type+exact params), edges, bbox
                       │
                ┌──────▼──────┐
                │ 2. CLASSIFY │  per body, pick a strategy (see below)
                └──────┬──────┘
                       │
                ┌──────▼──────┐
                │  3. BUILD   │  emit parametric .scad from measured values
                └──────┬──────┘
                       │
                ┌──────▼──────┐
                │ 4. EXPORT   │  render STL from the .scad
                └──────┬──────┘
                       │
                ┌──────▼──────┐
                │ 5. MEASURE  │  align + IoU = ∩vol / ∪vol vs original tessellation
                │  + RENDER   │  multi-angle PNG + ghost overlay + cross-section
                └──────┬──────┘
                       │  IoU ≥ 0.95 ?
                 no ◀──┴──▶ yes
                 │              │
       ┌─────────▼───────┐   promote to templates/
       │ 6. DIAGNOSE+FIX │   (after human render-review)
       │ (by measurement)│
       └─────────┬───────┘
                 └──▶ back to BUILD
```

## Stage detail

### 1. Ingest (B-rep reader)
Parse the STEP and, per solid body, emit a normalised feature list:
- **Plane**: normal, origin, outer loop (→ flats, extrude sections)
- **Cylinder**: axis, radius, extent, inner/outer (→ bores, pins, round walls)
- **Cone**: axis, half-angle, ref radius (→ chamfers, tapers, countersinks)
- **Sphere**: center, radius (→ domes, ball ends)
- **Torus**: axis, major/minor radius (→ fillets, rounds, bead edges)
- **B-spline / free-form**: sampled surface (→ loft/polyhedron fallback)
- Topology: edges, loops, adjacency; per-body bbox + centroid + principal axes.

Multi-body STEP → split; reconstruct + score each body independently, then union.

### 2. Classify (strategy selection)
Per body, choose the cleanest parametric form:
- **Rotationally symmetric** (dominant coaxial cylinders/cones/tori/sphere) →
  `rotate_extrude()` of an RZ profile.
- **Prismatic / extruded** (two parallel plane caps + constant section) →
  `linear_extrude()` of the 2D section.
- **Primitive assembly** → CSG `union`/`difference`/`intersection` of cylinders,
  boxes, spheres; chamfers/fillets from cone/torus faces.
- **Free-form** → `hull()`/`skin()` loft or `polyhedron`, scoped to that region only.

### 3. Build (.scad emitter)
Emit a parametric file: a top-of-file named-variable block (radii, thicknesses,
spacings, counts) feeding modules per feature. Holes from cylinder faces, chamfers
from cones, rounds from tori, flats from planes. Readable primitives > point dumps.

### 4–5. Export, align, measure, render
Render STL; align to the original (centroid + principal axes, ICP refine);
`IoU = intersection_volume / union_volume`. Always also produce multi-angle renders,
a ghost overlay against the original, and a thin cross-section — and *look* at them.

### 6. Diagnose + fix (measurement-driven)
When IoU < 0.95, localise the error by measurement (section-area diffs along each
axis, occupancy-map deltas), attribute it to a specific feature, fix that feature's
parameter or representation, and re-run. Never "close enough".

## Components (target)

```
src/
  ingest/      B-rep reader → normalised feature JSON
  classify/    per-body strategy selection
  emit/        feature → .scad module emitters
  eval/        alignment + IoU + section/occupancy diagnostics
  agent/       the autonomous loop wiring (drives prompts/reconstruct.md)
```

## Open questions / risks
- B-rep backend: pythonocc-core vs FreeCAD headless (pick one, wrap behind `ingest/`).
- Assembly placement: STEP assemblies carry per-instance transforms — preserve them.
- Free-form surfaces (organic prosthetic shells) are the only place 95% is at risk;
  keep those regions small and measured, not guessed.
