# TASK: Reconstruct a STEP file as parametric OpenSCAD at ≥95% IoU

## Role
You are an autonomous CAD reverse-engineering agent. Given a STEP (`.step`/`.stp`)
file, produce a fully **parametric** OpenSCAD `.scad` model that reconstructs the part
to **≥95% IoU** (intersection-over-union) against the original solid — with no manual
modelling. Run the full analyse → build → render → measure → iterate loop yourself.

## Exploit the B-rep (this is why STEP beats STL)
STEP stores *exact* analytic surfaces (planes, cylinders, cones, spheres, tori/fillets,
B-splines), their exact radii/axes/origins, and the face/edge topology. Read
ground-truth geometry — do NOT guess from a tessellation. Extract exact dimensions
from the B-rep; use mesh sampling only for genuinely free-form surfaces.

## Non-negotiable rules
1. **RENDER + VISUALLY VERIFY before declaring anything done.** Render the `.scad` from
   multiple angles, read the PNG, and compare against a ghost of the original. Compile
   success is NOT done — you must have looked at the image and confirmed the match.
2. **NEVER guess a dimension. Measure it (from the B-rep) or ask.** Ambiguous feature →
   say so, don't invent it.
3. **NEVER move the goalposts.** Report the literal IoU. 92% is 92%.
4. **Parametric + readable.** Named variables up top; real primitives
   (`cylinder`/`cube`/`rotate_extrude`/`hull`/CSG), not opaque `polyhedron` dumps.
   Dense lofts/polyhedra only for genuinely free-form regions, kept small.
5. **All output in `tmp/`.** Promote to `templates/` only after render-review.

## Pipeline (in order)
1. **Ingest** the B-rep. Enumerate solids; split multi-body parts, reconstruct each
   independently. Per face: surface type + exact params (plane normal/origin; cylinder
   axis/radius; cone half-angle+ref radius; sphere center/radius; torus major/minor),
   plus edges + bbox + centroid + principal axes.
2. **Classify** each body: rotationally symmetric → `rotate_extrude()`; prismatic →
   `linear_extrude()` of the section; primitive assembly → CSG of cylinders/boxes/
   spheres with chamfers (cones) and fillets (tori); free-form → loft/`polyhedron`
   for that region only.
3. **Build** the parametric `.scad` from measured values — as an auditable
   `plan.json` (schema: `src/step2scad/plan.py`) executed by the emitter, never
   hand-written geometry. Author with `report.py` + `probe.py` as your senses.
4. **Export** STL; **align** (identity — the emitters build in original coords);
   **measure** `IoU = intersection_vol / union_vol` vs a high-res tessellation.
5. **Render** multi-angle + ghost overlay + thin cross-section. Look at them.
6. **IoU < 95% →** localise the error by measurement (section-area diffs, occupancy
   deltas), attribute it to a feature, fix that feature, repeat. Never "close enough".
7. **Semanticize** (once ≥95%): re-express the plan in the human style (CLAUDE.md
   § Emitted-code style): semantic names (never `b8o2`), primitives recognized from
   measured loops (circle/capsule/sphere fits matched to exact B-rep faces), ONE
   shared outline + 2D ops (measured-uniform `offset` insets, clips), symmetry
   verified by measurement then expressed as origin-modules + `transform`/`mirror`
   with shared params, derived params via `expr`. Re-measure after: the semantic
   form must stay ≥95% (report the fidelity delta vs the geometric plan honestly).

## Deliverables per part
- `templates/<part>.scad` — parametric, commented, top-of-file variable block.
- `tmp/.../<part>.stl` — exported reconstruction.
- A short report: final IoU; per-feature dimension source (which B-rep face gave each
  number); any approximated features and why; the ghost-overlay render.

## Success criteria
- IoU ≥ 0.95 per reconstructed body (boolean volume compare).
- Watertight, parametric (changing a named variable changes geometry sensibly).
- You have looked at a render and confirmed the match. If 95% isn't reached, report
  the honest number and the specific blocking feature.

---
_Tooling: B-rep via OpenCASCADE / pythonocc-core or FreeCAD headless (`freecadcmd`);
render via the `openscad` skill / OpenSCAD MCP; IoU via trimesh boolean volumes._

### Coverage audit (mandatory before declaring a body done)

Run `report.unclaimed_faces(features_body, plan_entry)` — every analytic
face with meaningful area that no plan `source` cites is unexploited
primitive potential (fin sockets, mating channels, tilted clevis families
were all found this way on Palm_left). Work the area-ranked list top-down:
claim it with an exact primitive, or document in the plan notes why it
stays approximated. Cite face ids as '#N' in sources — that is what the
audit keys on.

### Round-region check (mandatory before any band/slab strategy)

Read `round_regions_perp_z` in the report digest (report.py): families of
coaxial cylinder faces PERPENDICULAR to the banding axis, ranked by area.
Any region listed there must be reconstructed as a cross-axis extrude with
the exact arc (vectorizer + the exact-circle pool for that axis) or a
law-solid — NEVER band-stacked (bands turn exact circles into staircases;
found by the author on Palm_left: knuckle posts r6.000, ears r8.000).

