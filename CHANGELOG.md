# Changelog

All notable changes to **step2scad** are documented here.
Format based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/);
versions are project milestones (no releases published yet).

## [Unreleased]

### Added
- **`offset_sweep` primitive**: edge-treatment sweep — stacked slabs of a 2D
  shape offset by a fitted law delta(z): `linear` (chamfer/ramp) or `round`
  (quarter roundover, bottom/top edge). Pilot: the Arm_Guard plate's bottom
  rim — two discrete offset layers became ONE measured 45° chamfer law
  (inset slope −1.01/mm, res < 0.05), and fidelity improved slightly
  (continuous law beats discrete sampling). Guiding principle (per the
  author): primitives + fitted laws instead of stacked layers; the v12/v13
  templates demonstrate the principle, they are not a literal style guide.
- **`sweep` primitive** (plan schema): rectangular-footprint slab sweep whose
  top follows a fitted height law — circular `arc` (`h = zc + √(R²−(s−sc)²)`)
  or `linear` — clamped to `h_max`, emitted as the v13 rib-transition
  for-loop idiom. Laws must be FITTED to measured band boundaries and the
  residual cited in the provenance.
- Arm_Guard pilot: the 16 measured ridge layers became a parametric
  `center_ridge()` — measured constant (x,z) cross-section (hourglass,
  verified identical at 3 stations) ∩ plan stadium ∩ (45° tail ramp, res
  0.054 + plateau + main arc, res **0.005** + full section + head-taper arc,
  res 0.019). IoU 0.9852 (vs 0.9857 with raw layers — the fitted arcs replace
  the mid-sampled staircase at equal fidelity).

### Fixed
- Bounding boxes lie about widths: the ridge half-width sequence from band
  bboxes suggested a constant ±5.0; the actual cross-section necks to ±3.60.
  Cross-sections are now measured directly (section slice at verified-constant
  stations), not inferred from per-band extents.

## [0.4.0] — 2026-07-05 · Semantic parametric stage

The output stops being merely geometry-faithful and becomes **human-editable**.
Style target: the hand-tuned `arm-guard-v12/v13` templates from the sibling
STL reconstructor. Pilot: Arm_Guard at exact boolean IoU **0.9857** (the
geometric band-stack plan is preserved as `plan_bandstack.json` at 0.9930).

### Added
- **Plan schema v2** (`src/step2scad/plan.py`): body-level named parameters
  with mandatory provenance; safe string expressions in any numeric field
  (`"z_slot_top - z_cut_lo"`); parametric modules with formal arguments and
  call nodes.
- **Plan schema v3**: shared measured 2D `profiles` + 2D operation trees
  (`offset` insets — only claimable after measuring the inset uniform,
  std < 0.05 — and rect/poly clips); `transform` nodes
  (translate/rotate/mirror); derived parameters via `"expr"`.
- **Semantic emitter mode** (`src/step2scad/emit/csg.py`): renders the v13
  idiom — parameter block, origin-centred feature modules, mirrored
  instances, zones derived from one shared outline.
- **Primitive recognition** in plan authoring
  (`scripts/authoring/author_armguard_parametric.py`): circle/capsule/sphere
  fits over measured section loops, matched to exact B-rep faces (a 44-point
  "organic" loop was the exact r7.995 mount cylinder; five crest bands were
  the exact B-rep sphere; torus blends become measured frustum chains between
  exact plane levels). Slot symmetry and rim-inset uniformity are verified by
  measurement before being expressed (`slot_len=20.000`, `slot_ang=8.578°`
  shared by all four slots + `mirror`).
- **Native-CSG boolean IoU** (`boolean(openscad-native-csg)`): the candidate
  never leaves CSG (`use <recon.scad>` wrapper). Needed because STL
  round-trips of tangency-heavy reconstructions corrupt in *every* mesh
  tool's vertex re-merge (OpenSCAD import, trimesh and manifold3d each gave
  a different wrong volume).
- Binding style rules in `CLAUDE.md`, pattern language in `ARCHITECTURE.md`,
  protocol §7 (PT) in `docs/`, step 7 ("Semanticize") in the agent prompt.

### Changed
- Alignment is identity-pinned for pipeline artifacts (the `contains()`-based
  proxy is unreliable on tangency meshes and could silently rotate an exact
  reconstruction).
- Semantic-plan variable names must be meaningful (`mount_skirt_L_l01`,
  `rail_hump_R_l03`) — band-generated names (`b8o2`) are gone.

## [0.3.0] — 2026-07-05 · Full e-NABLE Phoenix Hand v3 set

All nine parts (30 solid bodies) reconstructed autonomously to **≥ 0.95
exact boolean IoU** with zero manual modelling:

| Part | IoU | Strategy |
|---|---|---|
| F695-2Z bearing | 0.9978 | exact RZ profile (`rotate_extrude`) |
| Tensioner_Pins | 0.9991 | 3 measured octagonal prisms ∩ + slot + bore |
| Tensioner_Block | 0.9984 | prismatic tower + flange + exact sphere − channels |
| Arm_Guard | 0.9930 | 2.5D band stack between exact z-planes |
| Snap_Pins | 0.9792 | hull-lofts + silhouette cutters (13 bodies) |
| Distals | 0.9839 | hull-loft shell + 9 exact cuts (5 bodies) |
| Proximals | 0.9796 | three-zone lofts + fork/tunnel/pin cuts (5 bodies) |
| Palm_left | 0.9652 | outline-slab shell + occupancy-scanned cavity |
| Palm_right | 0.9652 | mechanical x-mirror of the verified Palm_left plan |

### Added
- **Plan-driven architecture**: the agent authors an auditable `plan.json`
  per part (strategy = measured primitives + booleans, every value with
  provenance); the emitter executes it exactly and fails loudly. Heuristic
  classifier demoted to an audited suggestion (`suggested_strategy`).
- `src/step2scad/plan.py` (schema v1), `emit/csg.py` (plan-driven CSG
  emitter: box/cylinder/sphere/extrude, booleans + hull, `instance_of`),
  `report.py` (per-body plan-authoring digest), per-part authoring scripts
  under `scripts/authoring/`.
- Organic-shell recipes proven and documented: hull-loft (convex sections),
  outline-slab stack (non-convex — clipped hull halves pinch at the seam),
  per-column occupancy cavity scan, void-run-only slot cuts, verified-mirror
  plan transformation.
- Eval hardening: watertight reference tessellation (per-body stitching of
  OCC-untriangulatable sliver faces), Manifold-backend STL renders, exact
  OpenSCAD-boolean fallback, per-region FP/FN localization, structural
  assertions, surface-distance heatmaps.
- Public repository (CC BY-SA 4.0, e-NABLE attribution) and the full
  reconstruction protocol (PT) for thesis integration.

### Fixed
- OCC `Bnd_Box` overestimation on B-spline faces (control-pole hull) —
  extents measured on the tessellation instead.
- Partial `trimesh.section` results (neighbor-consistency station repair).
- Voxel-fallback IoU under-reporting (~1%) replaced by exact boolean paths.

## [0.2.0] — 2026-07-04 · Working pipeline

### Added
- End-to-end pipeline `ingest → classify → emit → export → eval → refine`
  on OpenCASCADE (`pythonocc-core`): exact per-face B-rep extraction with
  adjacency graph, heuristic classifier, exact RZ-profile `rotate_extrude`
  emitter with Pappus volume self-check, boolean IoU eval with localized
  diagnostics and rule-6 refinement loop.
- Geometry **probe** CLI (raycast / section / slices / contains /
  nearest-feature / compare) — the agent's active perception.
- Multi-body split/reassemble for the Phoenix Hand source STEP.
- First part above target: F695-2Z bearing at IoU 0.9977.

## [0.1.0] — 2026-07-04 · Scaffold

### Added
- Project layout, `ARCHITECTURE.md` (division of labour: deterministic
  scripts vs. strategy/evaluation agent), `CLAUDE.md` non-negotiable rules,
  seed model `e_nable_phoenix_hand_v3.step`.
