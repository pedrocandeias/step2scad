# step2scad — CLAUDE.md

## Project

Automated **STEP → parametric OpenSCAD** reconstructor. Input a `.step`/`.stp`
B-rep solid; output a parametric `.scad` that reconstructs it to **≥95% IoU**, with
no manual modelling. The reconstruction agent prompt is `prompts/reconstruct.md`;
the pipeline design is `ARCHITECTURE.md`.

## Non-negotiable rules

1. 🔴 **RENDER + VISUALLY VERIFY before declaring anything done.** Render the `.scad`
   from multiple angles, read the PNG, and compare against a ghost of the original.
   Parse/compile success is NOT done. You must have *looked at the image* and
   confirmed the geometry matches intent.
2. 🔴 **NEVER guess a dimension. Measure it or ask.** Every number in a `.scad` comes
   from a B-rep measurement (surface type + parameters read from the STEP) or, for
   genuinely free-form regions only, from a mesh occupancy / section measurement.
   No eyeballing renders, no "probably ~X", no analogy to another part. If a feature
   is ambiguous, say so and ask — do not invent it.
3. 🔴 **NEVER move the goalposts to claim success.** Measure IoU against the literal
   goal. If it's 92%, report 92%. Do not switch metrics, redefine terms, or
   generalise from one good body to call the whole part done.
4. 🔴 **Keep it PARAMETRIC and READABLE.** Named variables at the top of the file,
   features expressed as real primitives (`cylinder`/`cube`/`rotate_extrude`/`hull`/
   CSG), not opaque point-dump `polyhedron`s. A human must be able to open the file
   and change a dimension meaningfully. **Organic ≠ free-form:** a real STEP B-rep was
   designed in parametric CAD from primitives + fillets, so even "organic" shells
   reconstruct as CSG/lofts, not sculpts. Lofted (B-spline) faces become a parametric
   `skin()`/`hull()`/BOSL2 sweep between two recovered profiles. A raw `polyhedron`
   vertex-dump is a last resort — and a smell that the input may be a mesh, not a
   true B-rep.
5. 🔴 **Surgical edits to hand-tuned files.** When adding parameters to a `.scad`
   someone is tuning by hand, insert with targeted edits — never rewrite the file or
   clobber existing dialled-in values. If existing values must change, ASK first.
6. 🔴 **NEVER unilaterally declare an IoU ceiling / give up.** "I think we've hit the
   limit" is a TRIGGER to act, not a conclusion — it is the twin of rule 3. When IoU
   plateaus, read the localized-error report and turn each residual into a concrete
   primitive intervention: false-NEGATIVE region → add a primitive there (sphere / cube
   / cylinder sized to it) and fuse it, reshape as needed; false-POSITIVE region →
   subtract or trim; section-area deficit at a z → fix the profile at that height.
   Apply, re-measure, keep if improved, iterate. Only after genuinely exhausting
   targeted attempts do you stop — and even then do NOT quit silently: present the
   remaining error (which regions, how much) + the candidate fixes you'd try next, and
   let the user decide. (Past failures were fixed by exactly these manual moves — the
   "ceiling" was rarely real.)
7. 🔴 **AI agent ONLY for STRATEGY + EVALUATION; everything else is deterministic
   scripts.** The agent (a) decides the reconstruction strategy/plan per body and the
   refinement moves, and (b) evaluates results (reading script diagnostics/probe — its
   senses, since it's blind to 3D) and decides accept vs. try-alternative. All
   mechanical work — B-rep extraction, probing, emitting SCAD *from a given plan*,
   rendering, measuring IoU/diagnostics, split/reassemble — is script-based and
   reproducible. The agent CONTROLS the scripts (calls them, reads output, decides
   next); it never hand-models geometry or bakes judgment into a script. Emit scripts
   are plan-driven: they execute an explicit measured plan. This split is what makes
   the reconstructor automatable.

## Output discipline

- **Reconstruction results go in `output/<slug>/`** — kept in the project (the CLI
  default). The deliverable `.scad` + metrics JSON are git-tracked; bulky regenerable
  binaries (`.stl`/`.png`/`.ply`) are gitignored.
- **`tmp/` is scratch only** — throwaway intermediates, experiments, one-off renders.
  Never rely on anything in `tmp/` persisting.
- Approved, human-reviewed reconstructions are promoted to `templates/`.
- Input STEP files in `models/` are the source of truth — read-only.
- **Keep `CHANGELOG.md` current**: whenever a new reconstruction tool, method,
  schema capability, eval path or recipe lands (or a measurement trap is
  discovered), add it to the changelog in the same change set — under the
  current milestone's Added/Changed/Fixed. Results tables update when a part's
  measured IoU changes.

## Reconstruction pipeline (run in order for every STEP)

1. **Ingest** — parse the B-rep. Enumerate solids/bodies; split multi-body parts and
   reconstruct each independently. Per face, extract surface type + exact params
   (plane normal/origin; cylinder axis/radius; cone half-angle+ref radius; sphere
   center/radius; torus major/minor radius for fillets/rounds), plus edges + bbox.
2. **Classify** each body's strategy: rotationally symmetric → `rotate_extrude()`;
   prismatic → `linear_extrude()` of a 2D section; primitive assembly → CSG of
   cylinders/boxes/spheres with chamfers/fillets from cone/torus faces; lofted/
   "organic" → parametric loft (`skin()`/`hull()`/BOSL2 sweep) between recovered
   profiles. Raw `polyhedron` only as a last resort.
3. **Build** the parametric `.scad` from measured values.
4. **Export** STL and **measure IoU** = intersection_vol / union_vol vs a high-res
   tessellation of the original solid (align first: centroid + principal axes, then
   ICP if needed).
5. **Render** multi-angle + ghost overlay + a thin cross-section. **Look at them.**
6. If IoU < 95%: **diagnose with measurement** (which region drives the error —
   section-area diffs, occupancy maps), fix the responsible feature, repeat. Do not
   stop at "close enough".

## Emitted-code style (binding — piloted on Arm_Guard, details in ARCHITECTURE.md)

Style reference: `~/dev/openscad-parametric-reconstructor/templates/arm-guard-v13.scad`
(hand-tuned, user-approved). The emitted `.scad` must read like it:

- **Semantic names only** — `mount_skirt_L_l01`, never `b8o2`. Classify leftover
  organic layers by position and name them.
- **Recognize primitives before dumping polygons**: fit circles/capsules/spheres to
  measured loops and match them to exact B-rep faces. A 44-point "organic" loop was
  the exact r7.995 mount cylinder; five crest bands were an exact B-rep sphere.
- **One shared outline** (`profiles` in plan.json) + zones derived via 2D ops
  (`offset` insets — only after MEASURING the inset uniform, std<0.05; rect/poly clips).
- **Exploit symmetry after verifying it by measurement**: feature module at the
  origin + `transform`/`mirror` instances with shared params (4 slots = 1 module +
  2 centers + `slot_len`/`slot_ang`/`slot_r`).
- **Derived params** via `"expr"` keep relationships explicit
  (`fillet_rc = mount_r - fillet_r`).
- Plan schema: `src/step2scad/plan.py` (v2 params/modules/expressions; v3 profiles/
  profile2d/transform). Authoring reference: `scripts/authoring/author_armguard_parametric.py`.

## Tooling notes

- B-rep reading: OpenCASCADE / `pythonocc-core`, or FreeCAD headless (`freecadcmd`).
  STL fallback only for free-form surfaces with no analytic form.
- Rendering: the `openscad` skill / OpenSCAD MCP (`render_single`, `compare_renders`).
- IoU: boolean volume compare (trimesh / OpenSCAD `intersection`+`union` volumes).
- ⚠️ Tangency-heavy recons (stacked coincident layers) corrupt in EVERY mesh tool's
  STL round-trip (openscad-import, trimesh, manifold3d gave three different wrong
  volumes). Trust `boolean(openscad-native-csg)` (`use <recon.scad>` wrapper) and
  section overlays; `contains()`-based diagnostics (voxel FP/FN, raycast segment
  classification) report PHANTOMS on such meshes — verify residuals with section
  overlays or orig-vs-recon probe hits before acting (rule 6).
