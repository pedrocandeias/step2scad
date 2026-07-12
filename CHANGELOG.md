# Changelog

All notable changes to **step2scad** are documented here.
Format based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/);
versions are project milestones (no releases published yet).

## [Unreleased]

### Added
- **Distals body0 8-part grid via SHARED measured-outline loft** —
  `output/Distals/parts/`: one `outline.scad` (50 X-Z convex section
  outlines measured from the reference tessellation, lofted with ruled
  hulls — no band stacks) is the outer form for ALL 8 grid parts; each part
  subtracts only its measured interior voids (`voids.scad`). Grid total IoU
  0.825 → **0.9888** boolean(openscad-native-csg) (per part: y0_z0 0.9792 ·
  y0_z1 0.9817 · y1_z0 0.9802 · y1_z1 0.9888 · y2_z0 0.9931 · y2_z1 0.9931 ·
  y3_z0 0.9960 · y3_z1 0.9965; volumes within ~1%). Outer envelope covers
  the whole body to FN 5.6 mm³. New tools: `scripts/outline_loft.py`
  (generator) and `scripts/probe_columns.py` (occupied-z-interval column
  probe — reads the interior structure that section outlines bridge over).
- **Parts reunited as ONE piece** — `output/Distals/parts/body0_whole.scad`:
  same shared outer form minus the UNION of the measured voids (no cell
  seams), poste-guia and dorsal bridge added back. **IoU 0.9890**
  boolean(openscad-native-csg) vs the whole body0, volume +0.27%. The fenda
  transition was re-measured for the reunion (ramp with a knee 1.9→5.65 at
  y −8.5..−8.3, full-material front at y −7.85, floor hump z 10.20) — one
  shared `fenda_full()` void now serves both grid cells and the whole.
- **Distals interior measured, not assumed** (probe columns): the "bore" is
  a **keyhole slot** (empty band z 6.1–10.3; short in the left plate
  y −17.75..−13.05, long through the right prong y −18.45..−12.12 with
  diagonal end caps) plus a **counterbore** on the outer left face
  (enlarged profile, constant to x≈−29.3) — the old circular r2.75/r2.25
  bores both over- and under-cut. Open dorsal slot y −7..3.87 over a
  sloping cavity floor (z 9.6→13.05) crossed by a **bridge strap**
  y −1.35..1.3; the central fenda really ends at y −8.9 with a measured
  ramp; back-bottom flange groove y −20.26..−20.12.
- **Per-part `color` field** (plan schema + emitter): any node may carry
  `"color": "<name>"` or `[r,g,b]`, emitted as `color(...) { ... }` so
  individual pieces are visually distinguishable (author needs to point at
  parts to adjust). Cosmetic; geometry/IoU unaffected (Arm_Guard 0.9844).
  Piloted on the thumb: left prong Red, right prong Blue, top bridge Green.
- **`scale` transform** (plan schema + emitter): enables scaled/flattened
  primitives (e.g. a flattened-sphere "esfera espalmada" dome). Regressions
  unchanged (Arm_Guard 0.9844, Distals 0.9772).
- **Palm_left COARSE big-primitive variant** (author's directive: smooth
  form over IoU fidelity) — `scripts/authoring/palm_primitive.py` builds the
  palm from a handful of large measured primitives: flat base plate + body
  box + flattened-sphere dome + tube finger sockets + disc wrist ears +
  tilted thumb block (two parallel boxes + bored top). Emitted as a SEPARATE
  slug (`Palm_left_primitive`) so the committed loft palm (0.9641) is
  untouched. Low IoU by design; the deliverable is a clean editable form.
- **Canonical-arch palm shell — measured tradeoff (experiment, unchained)**:
  `archloft_palm.py` lofts ONE continuous canonical-arch skin (V2-template
  architecture: 31 stations, fixed-role 72/56-pt arches, monotone
  correspondence) — this ELIMINATES the control-loft fragment creases but
  scores 0.9413, below the 0.95 spec. Localized the gap: a spatially uniform
  ~0.25mm-RMS sheet over the entire dorsal surface (FP 1080 + FN 1542 mm3,
  net -317), i.e. a single smooth arch per station cannot represent the
  surface's real ±0.25mm detail (the hand template accepts ~1.25mm silhouette
  for the same reason). Decision (author): ship the control-loft 0.9641
  (passes spec, has creases); keep archloft as an auditable finding.
  Fidelity-vs-smoothness is a genuine tradeoff at the palm dome.
- **Palm shell re-architected to decimated control-outline lofts**
  (author's directive: aggressive over incremental): 726 band slabs →
  **84 skins over 382 control sections + 160 slabs** (chains <3 inherit v1
  fragmentation). Tolerance curve measured: 0.15→0.9639/487 · 0.30→0.9641/382
  · 0.50→0.9607/309 — 0.30 adopted. Both palms **0.9641** (−0.0013 vs the
  skinned bands, floor 0.9600 held) with staircase geometry eliminated AS A
  CLASS. New generic `fitting.decimate_sections_ruled` (ruled-interpolation
  decimation for NON-convex outlines) + `pair_rings`.
- **Measured dead-end documented** (the batch's most valuable finding):
  lofting full re-sliced reference sections fails geometrically — ruled
  skins between deeply concave outlines SELF-INTERSECT (Manifold resolved
  them at −10000 mm³) — which is exactly WHY v1 fragmented sections. The
  unused rebuild path stays in the stage with the fix identified: monotone
  nearest-point correspondence (would also erase the remaining
  fragment-boundary creases).
- **Model version stamp** (author's request): every emitted `.scad` starts
  with `// VERSION: vN — <timestamp>` and `echo("*** <part> reconstruction
  vN ***")` (visible in the OpenSCAD console on load). The counter lives in
  `output/<part>/scad_version.json` and bumps ONLY when the emitted content
  actually changes (hash of the unstamped text) — so the number is a true
  modification count, not a run count.
- **De-staircasing rule (author's) as generic constructs — palms GAIN
  fidelity**: `skin` (ruled loft through consecutive band TOP edges;
  authoring-time vertex correspondence by parameter-union rings — uniform
  arc resampling CUTS CORNERS, measured: 0.9506 with a 1577 mm³ FN sheet
  before the fix; CCW + equal-count validation; watertight polyhedron
  emission) and `heightfield` (editable control-height grid → smooth
  bilinear polyhedron, unit-tested; available for future z(x,y) surfaces —
  the palm ended up not needing it, skin covered dome+walls with one
  mechanism). Palm band slabs 726 → 303 (423 collapsed into 87 skins;
  honest slab fallback at the 36 measured topology breaks). **Both palms
  0.9637 → 0.9654 (+0.0017)** — ruled surfaces beat 0.25 mm stairs.
  Fill-to-plane stage deferred: the skins changed the FN landscape;
  re-measure before building the dual of planetrims.
- **Palm mating-architecture recognition** (coverage-audit-driven surgery,
  3 batches, both palms steady at 0.9637; auditor 671→583 unclaimed faces,
  unclaimed plane area 11289→6116 mm²). The MATING TABLE (all exact faces):
  finger sockets 6.00 ↔ proximal beam 5.200 (0.80 clearance); clevis crowns
  r6.000 ↔ proximal lobes r6.000; thumb throat 6.00 at an exact 50.000°;
  elastic grooves 2.20 with r1.10 tips; dorsal retention lips 2.64; wrist
  walls 5.00 carrying the r8.000 ears. New chained stages:
  `knuckleblock_palm.py` (16 named mating params, geometry-neutral — the
  walls were already exact in band footprints; they lacked EXPLANATION) and
  `planetrims_palm.py` (7 exact tilted-plane trims kept; 11 REJECTED by
  FP-only sampling — bands sat under the plane, trimming would cut 223 mm³
  of true material). Honest negative: thumb-clevis band replacement needs
  anatomical re-segmentation (full-width footprints) — future work.

### Fixed
- ⚠ measurement trap (reconfirmed on Distals parts): voxel `contains()`
  diagnostics report **phantom FN** on non-watertight part meshes caused by
  exactly-coincident CSG faces (e.g. a guide-post top flush with the channel
  void top). Re-probe with small offsets before acting on a single column;
  avoid exact tangency in emitted CSG (nudge overlaps by 0.01).
- Plane normals from features.json are UNORIENTED (reconfirmed the hard
  way: trusting them flipped half the trim wedges inward, −11000 mm³) —
  stages orient by two-sided containment probes. Face-selection must
  cluster connected triangles by aligned normal (infinite planes catch
  coincident far geometry); use triangle centroids, not sparse vertices;
  plan-editing stages must be idempotent.
- **Palm round-region surgery** (author-spotted failure, root-caused and
  scripted): the knuckle-post crowns and rear ears were exact B-rep faces
  all along (7 clevis walls crowned by x-axis r6.000 cylinders — the mating
  geometry of the proximal r6.000 lobes; ears = r8.000 discs) that the band
  stack staircased because the earlier scan fit the TESSELLATION instead of
  reading the face list. `roundregions_palm.py` removes 145 staircase bands
  and places 8 exact solids (each intersected with the envelope of the
  bands it replaced — first attempt overshot 1054 mm³ where walls emerge
  from the deck; measured, fixed). Both palms 0.9637 (−0.0004, neutral);
  clevis crowns now read as smooth round lobes. Detection is now automatic
  for every model: `round_regions_perp_z` in the report digest + mandatory
  recipe check. Remaining candidates logged: one merged-footprint wall, the
  tilted thumb-clevis family (r7.5/7.0/6.0).
- **Distals shell on law-solids — IoU GAIN**: 0.9714 → **0.9772** (+0.0058).
  Each finger shell = pairwise control-slice hulls ∩ three WINDOWED roof
  laws that tile without gaps (straight mid-roof + valley arc [box−cyl,
  lower branch] + dorsal boss arc [cyl∪box, upper branch]) − a gentle
  measured underside wrap (arc r≈75-100 — NOT the r13 scoop the hand
  template assumed; law kind auto-selected line/arc by residual). Family
  feature: the mid-roof slope is shared across all three unique fingers
  (−0.057..−0.061). Architecture lessons measured: global hulls bridge
  concavities (+943 mm³ FP — pairwise chains + law shaving is the safe
  base); law windows must tile; tips/heels stay honestly on slices.
  New stage `scripts/authoring/lawsolids_distals.py`; 160 prims / 45 params.
- **Palm law-solid scan — auditable negative result**
  (`scripts/authoring/lawsolids_palm.py`, ~10 s, plan-neutral): four law
  families tested against the remaining 602+137 palm bands (arc offset laws
  at the knuckle posts; sphere/cylinder caps at the tips; windowed wrist-edge
  laws; cavity offsets) — ALL rejected by residual (stds 1.3-12.8 mm; tip
  quadric residuals 1.9-3.1 mm; the post tops change TOPOLOGY as the clevis
  slots begin). No substitution qualified under the ≥0.955 batch policy;
  both palms stay 0.9641 untouched. The palm dome is genuinely organic at
  band resolution — future gains would come from anatomical re-segmentation
  upstream, not from more law fitting.
- **Snap_Pins heads on law-solids**: every head collapsed from 6-7 pairwise
  hulls to 2 auto-selected control slices; rectangular head plates
  RECOGNIZED as named `box` prims (4-vertex axis-aligned stations, interp
  error 0.000); family feature: the 3.3×5.5 plate recurs on three pins.
  Prims 148→91 (551 in v1), IoU 0.9818 with delta ±0.0000. New stage
  `scripts/authoring/lawsolids_snap_pins.py` chained from the authoring
  script; remaining residual (38.9 mm³, pin-head transition rounds) noted
  as a future offset_sweep-round candidate.
- **Thumb proximal on law-solids** (crownlaws generalized per-body, control
  slices auto-selected via `decimate_stations`, 37→12): thumb crown = 12
  slices ∩ arc roof (r=36.22) − scoops r=8.44/7.42. Thumb offline 0.9718
  (−0.0028), whole part 0.9708 (−0.0008). Anatomy comparison: the thumb is
  more curved (dome 36 vs 52) and the ~r7.5 front scoop is a FAMILY feature
  (near-exact circle on fingers and thumb, res 0.009/0.017). Trap logged:
  law-fit sampling windows must exclude out-of-feature points (rear scoop
  res 0.378→0.011 after windowing) — windows are per-body config constants
  with justification comments.
- **Humanizer emission layer**: generated `.scad` files now read like the
  hand-written templates — narrative file header, per-body anatomy block
  (notes + module inventory with docs), parameters grouped by feature with
  section separators (stable group sort with forward-reference repair —
  OpenSCAD evaluates assignments in order), top-level feature tinting
  (`show_colors` + `tint()` palette), and a ghost-overlay toggle
  (`show_original` + `%import(<part>_ref.stl)`). Fidelity-neutral by
  construction (regressions across the fleet unchanged).
- **Section-parameter-law decomposition (law-solids)** — the automated
  version of what the hand-tuned Proximals template does by eye: fit each
  measured cross-section as a parametric composition, fit LAWS along the
  axis to the section parameters, and emit the shell as an INTERSECTION of
  law-solids. Pilot on the Proximals crown ("no clean law" last pass):
  46 measured prims → 9 law-solids + 11 named params (hull of 4 control
  slices ∩ longitudinal arc roof [box−cylinder r=52.34] − two underside
  scoops + fin lip sweep). IoU 0.9716 (−0.0046, within policy).
  **Machine-vs-hand headline:** the template got the SHAPES of every law
  right (independent validation of the decomposition language) but the
  machine corrected the VALUES — dome r=52.34 not 60; the scoops are
  asymmetric (rear r=11.76, front r=7.57 with residual 0.009 — a near-exact
  circle the eye read as symmetric); fin top slope −6.4° not −6.0°.
  New stage: `scripts/authoring/crownlaws_proximals.py` (re-measures on
  every run, residual asserts). Noted follow-ups: thumb body still on the
  old crown; `sweep` arc law could grow a `branch` field for concave roofs.
- **`fitting.decimate_stations`** — loft-station decimation to parametric
  CONTROL sections: an interior station survives only if the hull of its
  neighbors cannot reproduce it within tolerance (support-function
  interpolation, exact for convex hull cross-sections; greedy min-error
  removal). Distals: 45/47/45 measured stations → 16/13/13 control sections
  per finger at tol 0.30; measured cost curve cited in the plan notes
  (28 sections @ IoU 0.9809 / ~14 @ 0.9714 / ~10 @ 0.9615 — 0.30 chosen per
  the parametric-preferred policy). Each surviving section is an editable
  vectorized profile; the Proximals crown loft is the next candidate.

## [0.5.0] — 2026-07-06 · Fleet semanticization + smooth laws

**All eight CSG parts are now human-readable and truly parametric** (schema
v2/v3: named sourced params, modules, mirrors, vectorized outlines, fitted
laws with smooth emission). The parametrization cost was quantified per part
(decision policy: prefer editable, cite the delta):

| Part | v1 IoU | Semantic IoU | Δ | Highlights |
|---|---|---|---|---|
| Tensioner_Pins | 0.9991 | 0.9987 | −0.0004 | slot walls = 2 near-concentric fitted arcs; expression octagons; 78-line scad |
| Tensioner_Block | 0.9984 | 0.9904 | −0.0080 | exact-mirror side channels; vectorize tol tightened 0.06→0.02 after costing |
| Arm_Guard | 0.9930 | 0.9844 | −0.0086 | fully parametric: exact cones, 45° laws, hourglass ridge, vectorized outlines |
| Snap_Pins | 0.9792 | **0.9818** | **+0.0026** | pins = plateau-cylinder revolve chains clipped by exact plane flats (v1 hulls had circumscribed the flats!) |
| Distals | 0.9839 | 0.9809 | −0.0030 | zone-named vectorized stations; hull-loft kept — taper measured as real |
| Proximals | 0.9796 | 0.9762 | −0.0034 | knuckle lobes r=6.000 exactly concentric with pin bores; 754→212 prims |
| Palm_left | 0.9652 | 0.9641 | −0.0011 | 619+46 constant-outline runs collapsed; 1938→1405 prims; dome honestly organic |
| Palm_right | 0.9652 | 0.9641 | −0.0011 | single mirror-wrap of the left semantic plan |

(F695-2Z bearing stays 0.9978 — exact RZ revolve, semantic by construction.)

### Added
- **`src/step2scad/fitting.py`**: the fitting/vectorizing utilities promoted
  from the Arm_Guard authoring script to a shared library — circle/line/
  capsule fits (all returning residuals), `dist_to_poly`, `uniform_offset`
  (assert-guarded), the polygon `vectorize`r with every hard-learned guard,
  and `z_cylinder_circles` (the exact-face snap pool). All per-part
  semanticization scripts build on it.
- **Smooth law emission — no more slab stairs**: `sweep` and `offset_sweep`
  no longer discretize their laws into stepped slabs (the staircase artifacts
  the author spotted in renders). Each law now emits its EXACT smooth
  geometric equivalent: a linear height law is a tilted half-space clip; an
  ARC height law IS a horizontal cylinder (axis along the cross direction) +
  under-fill; an offset chamfer/roundover is a `minkowski` with a cone /
  revolved-arc bit (round corner joins — outline corners are arcs anyway).
  Arm_Guard: IoU 0.9838 → **0.9844** (smooth is truer than mid-sampled
  stairs) and the recon mesh got clean enough that voxel diagnostics jumped
  from 0.20 to 0.87 (far fewer tangency phantoms).
- **Profile vectorizer + `path` 2D node**: measured polygon dumps decompose
  into LINES + FITTED ARCS (circle fits with guards: max radius, monotonic
  sweep, dense sampling, corner-anchored walk), arcs snapped to exact
  z-axis B-rep cylinder faces when center+radius agree (angles recomputed
  from the snapped center). Emitted as `polygon(concat(..., [for (k=...)
  arc points]))` — the v13 `boss_profile_2d` idiom. Arm_Guard: the 97-point
  plate outline is now 64 line vertices + 4 exact-face arcs (r6 corners
  #54/#70, r7.995 mount lobes); windows and rail base likewise. IoU
  unchanged at 0.9838 (vectorization is fidelity-neutral).

- **Multi-body semantic emission**: `_prefix_entry` bakes the body prefix
  into every name-like token (params, profile keys/refs, module keys/calls,
  node names, expression identifiers; module formal args shadow) — unblocks
  params/modules/refs for multi-body parts. Found by the Distals agent.
- Per-part authoring scripts under `scripts/authoring/author_*_parametric.py`
  (all import `fitting.py`); `mirror_palm_plan.py` gained the v2/v3
  mirror-wrap mode.

### Fixed
- Preview PNGs render with `--render`: the OpenCSG preview silently produces
  BLANK images on tangency-heavy CSG (found on Palm_left and Proximals).
- Circle-fit blindness to flats: any convex profile whose VERTICES lie on a
  circle fits as that circle (res 0.000) — flats live in edges. Authorize
  circles by vertex count and confirm flats against exact plane faces
  (Snap_Pins v1 had circumscribed flat-topped sections as full circles; the
  semantic pass fixed it and GAINED 0.26pp).
- Vectorizer traps found while stabilizing it: greedy arc windows must not
  wrap past the wrapped start (duplicate overlapping arcs = self-intersecting
  polygon), snapped arcs must recompute their angles from the exact center,
  and PCA rect fits mis-assign axes on near-square loops (the pin windows
  reverted to vectorized measured paths after a 163 mm³ overcut).
- **Arm_Guard 100% parametric** (IoU 0.9838): the last organic layers fell —
  mount skirts are the EXACT 45° cone faces #29/#105 (frustum r 8.995→7.995,
  z 1.8013→2.8014; band circles matched the cone law to 0.005); the plate rim
  chamfer's fitted law was cross-validated as the EXACT cone faces #93/#114
  (r 7.495→7.995); wings = shared outline ∩ measured straight clip
  (wing_x_cut); strap rails = measured base footprint under a uniform 45°
  offset law (shrink == dz, std 0.012). Five modules, 54 named params, zero
  `bNoM` layers. **Decision policy adopted:** prefer the parametric editable
  form over organic layers when the quantified cost is acceptable — measured
  here: −0.0019 IoU vs semantic-with-layers (0.9857), −0.0092 vs the raw band
  stack (0.9930).
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
