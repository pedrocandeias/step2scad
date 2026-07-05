# step2scad

**Automated STEP → parametric OpenSCAD reconstruction.**
*Reconstrução automática de sólidos STEP em modelos OpenSCAD paramétricos.*

[English](#english) · [Português](#português)

---

## English

Give it a STEP (`.step` / `.stp`) B-rep solid; it produces a fully **parametric,
human-readable** OpenSCAD model that reconstructs the part to **≥95% volumetric
IoU** against the original — with **zero manual modelling**. Every dimension in
the output is a measured value (an exact B-rep parameter or a probe measurement
on a high-resolution tessellation), each annotated with its provenance.

Validated on the complete **e-NABLE Phoenix Hand v3** prosthetic (9 parts, 30
solid bodies), including the "organic" palm shells:

| Part | Boolean IoU | Strategy |
|---|---|---|
| F695-2Z (bearing) | 0.9978 | exact RZ profile (`rotate_extrude`) |
| Tensioner_Pins | 0.9991 | intersection of 3 measured octagonal prisms + slot + bore |
| Tensioner_Block | 0.9984 | prismatic tower + flange + exact sphere − channels |
| Arm_Guard | 0.9930 / 0.9857* | 2.5D band stack; *semantic parametric form (modules, shared outline, symmetry) |
| Snap_Pins | 0.9792 | hull-lofts + silhouette cutters (13 bodies) |
| Distals | 0.9839 | hull-loft shell + 9 exact cuts (5 bodies) |
| Proximals | 0.9796 | three-zone lofts + fork/tunnel/pin cuts (5 bodies) |
| Palm_left | 0.9652 | non-convex outline-slab shell + occupancy-scanned cavity |
| Palm_right | 0.9652 | mechanical x-mirror of the verified Palm_left plan |

All IoU values are **exact boolean** intersection/union volume ratios, not
voxel estimates. Beyond geometric fidelity, plans can be **semanticized** into
human-editable form — named parameters with provenance, feature modules,
symmetry via `mirror`, zones derived from one shared outline — piloted on
Arm_Guard (`slot_len`/`slot_ang`/`mount_r` are real, editable parameters).
Full methodology (in Portuguese, with per-script detail):
[`docs/reconstruction_protocol_phoenix_hand.md`](docs/reconstruction_protocol_phoenix_hand.md).

### How it works

The system splits **strategy** from **execution**:

- **Deterministic pipeline** (`ingest → classify → emit → export → eval →
  refine`): exact B-rep feature extraction (OpenCASCADE), a geometry *probe*
  (raycasts, sections, occupancy — active perception over any model), a
  plan-driven `.scad` emitter, and an evaluation stack (exact boolean IoU with
  fallbacks, localized FP/FN diagnostics, surface-distance heatmaps, structural
  assertions).
- **An AI agent decides only the strategy** — which primitives, booleans and
  measurements compose each body — and records it as an auditable
  **`plan.json`** (schema: [`src/step2scad/plan.py`](src/step2scad/plan.py));
  the emitter executes the plan exactly, with no judgment of its own. The
  agent then reads the eval diagnostics and iterates: each localized error
  region becomes a concrete, measured intervention.

```bash
# reconstruct one part; results land in output/<part>/
PYTHONPATH=src python3 -m step2scad models/F695-2Z.step
# with an agent-authored plan (the strategy artifact):
PYTHONPATH=src python3 -m step2scad models/part.step --plan output/part/plan.json
# the agent's senses:
PYTHONPATH=src python3 -m step2scad.report output/part/features.json
PYTHONPATH=src python3 -m step2scad.probe models/part.step section z 3.0 --png
```

Requirements: Python 3.12+, `pythonocc-core` (OCP), `trimesh`, `numpy`,
`matplotlib`, `shapely`, and an [OpenSCAD](https://openscad.org) build with the
Manifold backend.

### Layout

```
models/            input STEP files (source of truth, read-only)
src/step2scad/     the deterministic pipeline (ingest/plan/emit/eval/probe/report)
scripts/authoring/ per-part plan-authoring scripts (supplementary material)
output/<part>/     deliverables: plan.json + parametric .scad + eval.json
docs/              the reconstruction protocol
prompts/           the reconstruction agent prompt
ARCHITECTURE.md    pipeline design + proven shell recipes
```

---

## Português

Recebe um sólido B-rep STEP (`.step`/`.stp`) e produz um modelo OpenSCAD
totalmente **paramétrico e legível** que reconstrói a peça com **IoU
volumétrico ≥ 95 %** face ao original — **sem modelação manual**. Todos os
valores do modelo final são medidos (parâmetros exatos do B-rep ou medições
sobre a tesselação de alta resolução), cada um anotado com a sua proveniência.

Validado na prótese **e-NABLE Phoenix Hand v3** completa (9 peças, 30 corpos
sólidos), incluindo as conchas "orgânicas" das palmas — resultados na tabela
acima, todos com IoU booleano exato.

O sistema separa **estratégia** de **execução**: um pipeline determinístico
(extração B-rep exata, sonda geométrica, emissor de OpenSCAD orientado por
plano, avaliação com IoU booleano exato + diagnóstico localizado + mapas de
calor) e um agente de IA que decide *apenas* a estratégia por corpo,
registando-a num **`plan.json`** auditável que o emissor executa à letra.
Quando o IoU fica aquém, cada região de erro localizada é convertida numa
intervenção concreta e medida — nunca se declara um "teto" de qualidade.

O protocolo completo do processo, escrito para integração em contexto
académico e com o detalhe de cada script, está em
[`docs/reconstruction_protocol_phoenix_hand.md`](docs/reconstruction_protocol_phoenix_hand.md).

---

## License / Licença

This repository is licensed under **[CC BY-SA 4.0](LICENSE)**
(Attribution-ShareAlike 4.0 International).

The Phoenix Hand v3 input models in `models/` derive from the
**[e-NABLE](https://enablingthefuture.org/) Phoenix Hand** by the e-NABLE
community, itself shared under CC BY-SA — attribution and share-alike are
preserved here. / Os modelos STEP de entrada derivam da **Phoenix Hand** da
comunidade **e-NABLE**, partilhada sob CC BY-SA — a atribuição e a partilha
nos mesmos termos são preservadas neste repositório.
