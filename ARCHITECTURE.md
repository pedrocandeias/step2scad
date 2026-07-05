# step2scad — Architecture

## Goal

`STEP file  ──▶  parametric .scad reconstruction  @ ≥95% IoU`, fully automated.

## Division of labor: deterministic scripts vs AI agent (core axiom)

**The AI agent is used ONLY for two things — STRATEGY and EVALUATION. Everything else
is a deterministic script. The agent controls the scripts; it never does geometry by
hand.**

- **Scripts (deterministic — the bulk of the system):** exact B-rep extraction, the
  geometry probe, emit (build SCAD *from a given plan*), export/render, eval (IoU +
  localized diagnostics + assertions), split/reassemble. Same input → same output; no
  judgment inside.
- **AI agent (judgment only):**
  - **STRATEGY** — decide the reconstruction plan: per body, which approach
    (revolve / extrude / CSG / loft) and which primitives + measured dims compose it;
    and, during refinement, which targeted intervention to try next. (Classification is
    therefore a *strategy* decision, not a brittle hardcoded heuristic — a heuristic
    mislabeled a boxy block as `freeform`.)
  - **EVALUATION** — interpret the script-produced numbers / diagnostics / probe
    answers (the agent is blind to 3D, so these are its senses), judge whether the
    result is right, and decide accept vs. try-alternative (rule 6).
- **Control flow:** agent picks a plan → calls the emit script with it → calls eval →
  reads diagnostics → decides the next move → loops. Thin brain, deterministic hands.

**Design consequence:** emit scripts are **plan-driven** — they take an explicit plan
(primitives, ops, dims, all measured from the B-rep) and execute it exactly. The agent
authors the plan; the script never guesses.

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

### Organic ≠ free-form (it's primitives all the way down)

A real STEP B-rep only exists because the part was **designed in parametric CAD**
(Fusion / SolidWorks / Onshape) from sketches → extrude / revolve / loft / fillet /
boolean. The "organic" look of a prosthetic shell **emerges from primitives + blends**,
not from arbitrary sculpting — so even the shell's B-rep is overwhelmingly analytic
faces (planes, cylinders, cones, tori). Reconstruction therefore stays primitive/CSG
the whole way through; the real task is **recovering the construction intent**.

The one genuine nuance: **loft** operations produce B-spline faces (a surface skinned
between sketch profiles). These are *not* free-form — they're **bounded,
profile-to-profile** lofts, reconstructed as a parametric `skin()`/`hull()`/BOSL2 sweep
between two recovered profiles. Still readable, still parametric, no point dump.

⚠️ A raw `polyhedron` vertex-dump in the output is a **smell**: it usually means the
input wasn't a true B-rep (someone exported a tessellated mesh as STEP). Treat it as a
last resort, not a strategy — 95% should be reachable with primitives + lofts.

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

**Strategy is an agent decision, not a heuristic's.** The heuristic classifier
remains only as an advisory *suggestion generator*; the agent authors the real
strategy as a **plan.json** (schema: `src/step2scad/plan.py`) and passes it with
`--plan`. The plan overrides the per-body strategy (the heuristic's suggestion is
kept in `classification.json` as `suggested_strategy` for audit) and carries the
explicit measured CSG tree the emitter executes. The agent reads its senses first:
`python3 -m step2scad.report <features.json>` (deterministic per-body digest:
plane groups by normal, cylinder axis clusters with extents/bore-vs-boss, cones/
tori/spheres, bspline adjacency) plus the probe for anything the digest can't
settle (e.g. raycast-sampling a bspline wall). Proven flow: Tensioner_Pins hit
IoU 0.9989 from a 3-octagon-intersection + slot + bore plan; the heuristic had
suggested nothing usable.

Per body, the cleanest parametric form:
- **Rotationally symmetric** (dominant coaxial cylinders/cones/tori/sphere) →
  `rotate_extrude()` of an RZ profile.
- **Prismatic / extruded** (two parallel plane caps + constant section) →
  `linear_extrude()` of the 2D section.
- **Primitive assembly** → CSG `union`/`difference`/`intersection` of cylinders,
  boxes, spheres; chamfers/fillets from cone/torus faces.
- **Lofted / "organic"** → parametric loft (`skin()` / `hull()` / BOSL2 sweep) between
  the two recovered profiles bounding each B-spline face. Raw `polyhedron` only as a
  last resort (and a signal the input may be a mesh, not a true B-rep).

### 3. Build (.scad emitter)
Emit a parametric file: a top-of-file named-variable block (radii, thicknesses,
spacings, counts) feeding modules per feature. Holes from cylinder faces, chamfers
from cones, rounds from tori, flats from planes. Readable primitives > point dumps.

#### Organic-body build recipe: MASS → HULL → SUBTRACT

The canonical parametric pattern for an "organic" functional part (e.g. the palm /
gauntlet shells — the bodies ingest flags as loft-heavy / high-bspline-area). It is
the exact way these parts were designed in CAD, run in reverse. Four steps
(cf. makerblock, "OpenSCAD intermediates: complex organic shapes"):

```
   MASS            →     HULL           →   SUBTRACT channels →  SUBTRACT bores
   place primitives      hull() them into    difference() the      difference() the
   at their anchors      one smooth shell    slots/tendon paths    pivot/pin holes
```

1. **MASS** — position the massing primitives that ingest already extracted: the palm
   body as a flattened ellipsoid/dome, the knuckle mounds as discs (cylinders), the
   front knuckle bar as a cylinder, the thumb mound as its own block/sphere. These are
   the exact analytic solids from the B-rep — nothing invented.
2. **HULL** — `hull()` the masses **in segments** (pairwise / centre-to-satellite, NOT
   one big hull — a single hull is only convex and shrink-wraps everything into a blob).
   Segmented hulls give the smooth, branching, concave organic skin. Varying primitive
   radii along a chain gives natural tapering.
3. **SUBTRACT channels** — `difference()` the functional negatives: tendon/finger
   channels across the front lip, cable routes, cavities. Sourced from the planar-slot
   and pocket faces in the B-rep.
4. **SUBTRACT bores** — `difference()` the round through-holes: finger-hinge axle bores
   (which segment the front bar into individual knuckles), pin holes, pivot holes.
   Sourced directly from the cylinder faces (exact axis + radius).

Everything stays parametric and human-editable — no `polyhedron` dump anywhere.

**Proven organic-shell recipes (Distals / Palms, 2026-07-05):**
- *Hull-loft* (convex sections — Distals fingertips): pairwise `hull()` of thin
  measured-section slabs along the sweep axis. Never clip sections at an
  arbitrary coordinate and hull two pieces separately — clipped hulls PINCH at
  the seam and convex hulls bridge concave saddles.
- *Outline-slab stack* (non-convex sections — the palms, IoU 0.965): per band,
  extrude the section's actual outer loops (holes dropped; the measured cuts
  recreate them). No hulls, no seams; slot roof bridges come along for free.
- *Void-run cuts*: a slot/clevis cutter must cut only the MEASURED void runs
  per scan row (never "everything past the first material"), with material
  OR-ed over stations across the cut width so wall fillets survive.
- *Mirror parts*: verify mirroring (volume ppm + centroid negation), then
  x-mirror the proven plan mechanically (Palm_right == mirrored Palm_left to
  4 IoU decimals). A first-class `mirror_of` plan strategy is a wanted feature
  (Snap_Pins had a y-mirrored pin that needed a full re-measure instead).

**Worked target — the palm.** The sibling STL workspace hit a **~0.90 IoU primitive
ceiling** on this exact part, because it built the dome and its surrounding primitives
*separately* and they never blended. Step 2 (segmented `hull()` of the masses into one
continuous shell) is precisely the move that reproduces the original CAD loft and is
the concrete path *past* 0.90. This is the emitter's flagship organic case.

> Emitter note: the classifier's `freeform` strategy label denotes this organic case —
> route those bodies to the MASS → HULL → SUBTRACT emitter, not to a `polyhedron`.

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
  classify/    heuristic strategy SUGGESTIONS (advisory; agent plan overrides)
  plan.py      plan.json schema + validation (the agent's strategy artifact)
  report.py    deterministic per-body digest (the agent's plan-authoring senses)
  probe.py     on-demand exact geometry queries (raycast/section/nearest-feature)
  emit/        plan-driven emitters: csg.py (box/cylinder/sphere/extrude +
               booleans + instance_of), revolve.py (exact RZ profile), stubs
  eval/        alignment + IoU + localized errors + heatmap + assertions
```

CSG plan primitives (`emit/csg.py`, all dims measured, all with provenance):
`box` (min+size or center+size+rotate), `cylinder` (p0→p1, r, optional r2
frustum), `sphere`, `extrude` (measured 2D polygon along a world axis; profile
in cyclic in-plane axes: x→(y,z), y→(z,x), z→(x,y)), combinators
`union`/`difference`/`intersection`/`hull`, and `instance_of` for repeated
bodies. A plan that cannot execute exactly fails loudly — never a silent stub.

## Open questions / risks
- B-rep backend: pythonocc-core vs FreeCAD headless (pick one, wrap behind `ingest/`).
- Assembly placement: STEP assemblies carry per-instance transforms — preserve them.
- Lofted B-spline faces (from CAD loft operations) are the main modelling challenge —
  not because they're free-form, but because recovering the two bounding profiles +
  the sweep path is fiddlier than reading a cylinder radius. They stay parametric.
- A STEP that is actually a tessellated mesh (all tiny facets, no analytic faces) is
  out of scope for primitive reconstruction — detect it early and flag it, don't dump
  it into a `polyhedron`.
