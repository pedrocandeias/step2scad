# Protocolo de Reconstrução Paramétrica STEP → OpenSCAD

**Caso de estudo:** componentes da prótese e-NABLE Phoenix Hand v3
**Critério de aceitação:** IoU volumétrico ≥ 0,95 face ao sólido original, saída totalmente paramétrica, sem modelação manual
**Data:** julho de 2026

---

## 1. Objetivo e princípios

Este protocolo descreve o processo automatizado de reconstrução de sólidos
B-rep (ficheiros `.step`) em modelos OpenSCAD paramétricos e legíveis,
aplicado às nove peças da mão protésica e-NABLE Phoenix. O processo assenta
em quatro princípios invioláveis:

1. **Medir, nunca estimar.** Todos os valores numéricos do modelo final
   provêm de parâmetros exatos do B-rep (raio/eixo de cilindros, normal/
   offset de planos, etc.) ou, para regiões genuinamente livres, de medições
   sobre a tesselação de alta resolução (secções, raycasts, varrimentos de
   ocupação). Cada valor transporta a sua proveniência em comentário.
2. **Separação estrita entre estratégia e execução.** Um agente de IA decide
   *apenas* a estratégia (que primitivas, que booleanos, que medições) e
   avalia os resultados; toda a mecânica — extração, medição, emissão de
   SCAD, renderização, avaliação — é executada por scripts determinísticos
   e reprodutíveis. A estratégia materializa-se num artefacto auditável
   (`plan.json`); o emissor executa o plano sem juízo próprio.
3. **Verificação visual e métrica obrigatória.** Nenhuma peça é dada como
   concluída sem: IoU booleano exato, verificação das asserções estruturais,
   e leitura humana/agente do mapa de calor de distâncias e da sobreposição
   com o original ("ghost overlay").
4. **Nunca declarar um teto de qualidade.** Quando o IoU estagna, cada região
   de erro localizada é convertida numa intervenção concreta (adicionar,
   subtrair ou corrigir uma primitiva medida), aplicada e re-medida.

## 2. Ferramentas

| Componente | Função |
|---|---|
| `pythonocc-core` (OpenCASCADE) | leitura do B-rep, extração de superfícies analíticas exatas, tesselação |
| `src/step2scad/ingest/` | `features.json`: por corpo, faces com tipo+parâmetros exatos, grafo de adjacência, bbox, volume |
| `src/step2scad/report.py` | resumo por corpo para autoria do plano: planos agrupados por normal, cilindros agrupados por eixo, adjacência de b-splines |
| `src/step2scad/probe.py` | perceção ativa: `raycast`, `section`, `slices`, `contains`, `nearest-feature`, `compare` |
| `src/step2scad/plan.py` | esquema e validação do plano (primitivas `box`/`cylinder`/`sphere`/`extrude`, booleanos, `instance_of`) |
| `src/step2scad/emit/` | emissores plan-driven: CSG, perfil RZ exato (`rotate_extrude`) |
| `src/step2scad/eval/` | alinhamento, IoU booleano exato, diagnóstico localizado (FP/FN por voxel, varrimentos de área de secção), asserções, mapa de calor |
| OpenSCAD (backend Manifold) | renderização `.scad` → STL/PNG e cálculo booleano exato de recurso |
| `trimesh` | operações de malha, medições sobre a tesselação |

## 3. Pipeline por peça

Comando único (o plano é o artefacto de estratégia do agente):

```
PYTHONPATH=src python3 -m step2scad models/<peça>.step --plan output/<peça>/plan.json
```

### Passo 1 — Ingestão (determinística)

Extrair de cada corpo sólido as faces com parâmetros exatos (plano:
normal+origem; cilindro: eixo+raio; cone: semi-ângulo; esfera; toro), o
grafo de adjacência face-a-face com a convexidade das transições, o volume
e a caixa envolvente. Resultado: `features.json`.

*Armadilha documentada:* a `Bnd_Box` do OpenCASCADE sobrestima a extensão de
faces b-spline (usa o invólucro dos pontos de controlo); as extensões reais
medem-se na tesselação ou com o probe.

### Passo 2 — Levantamento e classificação estratégica (agente)

1. Correr `report.py` e ler o resumo: grupos de planos, clusters de eixos de
   cilindros (furos vs. ressaltos, arcos completos vs. parciais), lista de
   b-splines com vizinhança.
2. Ver secções reais: `probe slices <eixo> 12 --png` (montagem) e secções
   dedicadas nos planos ambíguos — **olhar para as imagens**.
3. Resolver ambiguidades com medições dirigidas (`raycast` para espessuras
   de parede e posições de superfícies curvas; `section` para topologia).
4. Identificar corpos repetidos: candidatos a `instance_of` exigem volumes
   iguais (≤ ~0,01 %) **e** verificação de não-espelhamento (posição de uma
   assimetria, p. ex. o lado do escareado do pino da dobradiça). Peças
   espelhadas verdadeiras validam-se por volume (ppm) + centróides negados
   e reconstroem-se por transformação mecânica x→−x do plano da peça irmã.
5. Escolher a estratégia por corpo. O classificador heurístico serve apenas
   de sugestão e fica registado para auditoria (`suggested_strategy`).

### Passo 3 — Autoria do plano (agente escreve; script calcula)

O agente escreve um script de autoria (guardado como artefacto) que deriva
mecanicamente cada valor do plano a partir de `features.json` e das medições
do probe, e emite `plan.json`. Receitas comprovadas por classe de geometria:

- **Sólido de revolução** (rolamento): caminho `rotate_extrude` existente —
  perfil RZ exato a partir das faces coaxiais, com autoverificação de volume
  (teorema de Pappus).
- **Prismático/facetado** (Tensioner_Pins, Tensioner_Block, Arm_Guard):
  interseção/extrusão de polígonos medidos; contornos extraídos de secções
  de tesselação **fina** (deflexão ≈ 0,008–0,01 mm — a tesselação por defeito
  enviesa contornos ~0,05 mm para dentro); vértices de octógonos como
  interseções de pares de planos exatos; chanfros como planos exatos;
  placas 2,5D como pilha de bandas entre cotas z exatas do B-rep.
- **Concha orgânica com secções convexas** (Distals): "hull-loft" — casco
  convexo de secções medidas em estações densas ao longo do eixo dominante,
  com `hull()` entre lâminas consecutivas; cortes exatos por cima (garfo,
  furos, ranhuras, canais).
- **Concha orgânica com secções não convexas** (Palmas): **pilha de lâminas
  de contorno** — por banda, os contornos exteriores reais da secção
  (lóbulos interiores descartados; os cortes medidos recriam-nos). *Nunca*
  recortar as secções numa coordenada arbitrária e fazer hull de metades:
  os cascos "beliscam" na junta e enchem selas côncavas.
- **Cavidades interiores**: varrimento de ocupação por colunas — por
  estação, por coluna x, o primeiro intervalo de vazio *interior* (vazio com
  material acima), com solo e teto medidos; cobre cavidades cujo piso não
  está no plano da base.
- **Ranhuras/garfos (clevis)**: cortar **apenas os intervalos de vazio
  medidos** por linha de varrimento (nunca "tudo para lá do primeiro
  material" — isso decepa lábios de piso e pontes de teto), com o material
  agregado por OR sobre três estações na largura do corte, para preservar
  boleados junto às paredes.

Regras transversais: todo o excesso de corte (overshoot) é declarado
explicitamente no plano; primitivas repetidas via `instance_of` com o delta
exato de centróides; cada primitiva com campo `source` (proveniência).

### Passo 4 — Emissão e exportação (determinísticas)

O emissor traduz o plano 1:1 para OpenSCAD legível: bloco de variáveis
nomeadas com comentários de proveniência + um módulo por corpo cuja árvore
CSG espelha o plano. Falha de execução do plano é erro fatal (nunca um
substituto silencioso). Renderização para STL com `--backend Manifold`
(garante STL manifold; o backend por defeito produz saída não-manifold em
superfícies CSG coincidentes).

### Passo 5 — Avaliação (determinística)

1. **Alinhamento**: identidade preferida (o emissor constrói nas coordenadas
   originais); alternativas por centróide/eixos principais só se vencerem
   por margem clara (evita que ruído de amostragem desalinhe uma
   reconstrução exata).
2. **IoU booleano exato**: motor manifold; se a malha tiver arestas de
   tangência que o `trimesh` rejeite, recurso ao booleano do OpenSCAD
   (exato); só em último caso IoU por voxels. *O fallback por voxels
   subestimava ~1 %.*
3. **Diagnóstico localizado**: regiões FP/FN por voxels com centróides,
   varrimentos de área de secção por eixo, mapa de calor de distância à
   superfície, asserções (estanquidade, volume, bbox, topologia/género,
   simetria, contagem de furos).
4. **Verificação visual**: previews multi-ângulo, sobreposição fantasma,
   mapa de calor — lidos, não apenas gerados.

*Armadilha documentada:* com arestas de tangência na malha reconstruída, o
`contains()` do trimesh fabrica regiões FP/FN **fantasma** — todo o resíduo
surpreendente é confirmado com raycasts orig-vs-recon antes de agir.
A referência tesselada é reparada por corpo (faces-lasca que o OCC recusa
triangular são fechadas por costura) para manter a estanquidade.

### Passo 6 — Iteração dirigida pelos resíduos

Enquanto IoU < alvo (ou enquanto restarem resíduos explicáveis): ordenar as
regiões de erro, converter cada uma numa intervenção concreta e **medida**
(região FN → primitiva adicionada/alargada; região FP → corte adicionado/
estreitado; défice de área a uma cota → perfil corrigido nessa cota),
re-executar o pipeline e manter apenas o que melhora. Exemplos reais:
Distals 0,914 → 0,984 em 8 iterações; Palm_left 0,885 → 0,965 em 6;
Proximals 0,933 → 0,980 em 7 — cada passo justificado por um diagnóstico.

## 4. Resultados

| Peça | IoU booleano | Iterações | Estratégia dominante |
|---|---|---|---|
| F695-2Z (rolamento) | 0,9978 | 1 | perfil RZ exato (`rotate_extrude`) |
| Tensioner_Pins (3 corpos) | 0,9991 | 1 | interseção de 3 octógonos + ranhura medida + furo cego; instâncias |
| Tensioner_Block | 0,9984 | 2 | torre prismática + flange + esfera − canais |
| Arm_Guard | 0,9930 | 3 | pilha de bandas 2,5D entre planos z exatos |
| Snap_Pins (13 corpos) | 0,9792 | ~4 | hull-lofts + cortes de silhueta; 7 únicos + 4 instâncias |
| Distals (5 corpos) | 0,9839 | 8 | hull-loft + 9 cortes exatos; 2 instâncias |
| Proximals (5 corpos) | 0,9796 | 7 | lofts viga/crista/coroa + garfo/túnel/pinos; 3 instâncias |
| Palm_left | 0,9652 | 6 | pilha de lâminas de contorno + cavidade por ocupação + cortes por intervalos de vazio |
| Palm_right | 0,9652 | 1 | espelho x mecânico do plano Palm_left (espelhamento provado: Δvolume 8 ppm) |

Todas as peças ≥ 0,95 com medição booleana exata; mapas de calor uniformemente
baixos (médias 0,02–0,06 mm). As asserções de estanquidade/género do trimesh
falham nas peças com arestas de tangência ou lâminas em escada — a geometria
foi verificada de forma independente (booleano exato + raycasts + mapa de calor).

## 5. Lições registadas (para reutilização)

1. Hulls convexos de secções **recortadas** beliscam na junta; conchas não
   convexas exigem lâminas de contorno.
2. Cortes de ranhura devem remover apenas vazios medidos por linha, com
   material agregado em várias estações na largura.
3. Peças espelhadas: provar o espelhamento (volume + centróides) e espelhar
   o plano mecanicamente; um `mirror_of` de primeira classe no esquema de
   plano é trabalho futuro.
4. Tesselação fina para contornos medidos; `Bnd_Box` OCC não é fiável em
   b-splines; secções trimesh podem vir parciais (reparação por consistência
   com vizinhos); raycasts alinhados com eixos podem falhar (perturbar 0,01).
5. Normais de plano em `features.json` são as naturais da superfície, não
   corrigidas pela orientação da face — confiar nos pontos `origin`.
6. `hull()` de cilindros de blend sobrepostos enche as concavidades; usar
   `union` e cortar o topo na tangente medida.

## 6. Reprodutibilidade

Artefactos por peça em `output/<peça>/`: `features.json` (medições),
`classification.json` (sugestão heurística + decisão), `plan.json`
(estratégia integral, cada valor com proveniência), `<peça>.scad`
(entregável paramétrico), `eval.json` (métricas + diagnóstico + registo de
refinamento), previews e mapa de calor. Os scripts de autoria dos planos
estão preservados em `scripts/authoring/` (material suplementar, §8.2).
A reexecução do comando do §3 regenera todos os derivados a partir do STEP
e do plano.

## 7. Etapa 2 — Parametrização semântica (pós-reconstrução)

Atingido o alvo geométrico, o plano é re-expresso em forma **humanamente
legível e genuinamente paramétrica** — o critério de estilo é um modelo
paramétrico afinado à mão e aprovado pelo autor (o template `arm-guard-v13`
do projeto irmão de reconstrução por STL). Piloto: Arm_Guard, IoU 0,9857
na forma semântica (vs 0,9930 na forma geométrica em bandas; a diferença —
boleado do rebordo simplificado e colares de chanfro omitidos — fica
documentada no plano).

Extensões ao esquema de plano (v2/v3, `src/step2scad/plan.py`) e ao emissor:

1. **Parâmetros nomeados com proveniência obrigatória**, incluindo derivados
   por expressão (`fillet_rc = mount_r - fillet_r`); expressões validadas por
   avaliação segura e emitidas simbolicamente.
2. **Módulos paramétricos com argumentos formais** e nós de instanciação.
3. **Contornos partilhados + operações 2D**: cada contorno medido é declarado
   uma única vez; as zonas derivam por `offset` (só depois de o inset ser
   **medido uniforme**, desvio-padrão < 0,05) e por recortes retangulares/
   poligonais — em vez de duplicar polígonos por camada.
4. **Nós de transformação** (translate/rotate/mirror): a simetria é
   **verificada por medição** e depois expressa — as quatro ranhuras do
   Arm_Guard tornaram-se um módulo na origem + dois centros + parâmetros
   partilhados (`slot_len` = 20,000; `slot_ang` = 8,578° — coincidente com o
   valor sondado à mão no template de referência), com o lado direito por
   `mirror`.
5. **Reconhecimento de primitivas antes de despejar polígonos**: ajustes de
   círculo/cápsula/esfera às camadas medidas, confrontados com as faces
   exatas do B-rep — um lóbulo "orgânico" de 44 pontos era o cilindro exato
   r=7,995 do montante; cinco bandas do cume eram a esfera exata do B-rep;
   o boleado do topo do montante tornou-se uma cadeia de troncos de cone
   medidos entre níveis de plano exatos.
6. **Nomenclatura semântica** para o que permanece orgânico
   (`mount_skirt_L_l01`, `rail_hump_R_l03`), classificada por posição.

Parametricidade provada por edição: `slot_len` 20→30 alonga as quatro
ranhuras coerentemente (−439 mm³) através de um único parâmetro;
`z_plate_top` engrossa a placa; `mount_r` redimensiona ambos os montantes.

**Armadilha de medição descoberta nesta etapa** (afeta qualquer ferramenta):
o STL de uma reconstrução com camadas coincidentes corrompe-se no re-encontro
de vértices de *todas* as ferramentas de malha testadas (importação OpenSCAD,
trimesh, manifold3d — três volumes errados diferentes). A medição fiável
mantém o candidato em CSG nativo (`use <recon.scad>` + booleano contra a
referência importada) — caminho `boolean(openscad-native-csg)` do avaliador;
os diagnósticos baseados em `contains()` produzem regiões fantasma nestas
malhas e todos os resíduos se confirmam por sobreposição de secções.

Guião de autoria: `scripts/authoring/author_armguard_parametric.py`
(reconhecimento de primitivas, verificação de simetrias e insets, geração do
plano semântico). O plano geométrico de bandas fica preservado
(`plan_bandstack.json`) como variante de máxima fidelidade.

### 7.x Resultados da semanticização da frota (marco 0.5.0)

A fase semântica foi aplicada às oito peças CSG por scripts de autoria
dedicados (`scripts/authoring/author_*_parametric.py`), todos assentes na
biblioteca de medição `src/step2scad/fitting.py` (ajustes de círculo/reta/
cápsula com resíduos, teste de offset uniforme, vetorizador de polígonos com
snap a faces exatas). O custo de fidelidade de cada parametrização foi
quantificado contra o plano geométrico v1 (política: preferir a forma
paramétrica editável, mantendo IoU ≥ 0,95 e citando o delta):

| Peça | IoU v1 | IoU semântico | Δ | Nota |
|---|---|---|---|---|
| Tensioner_Pins | 0,9991 | 0,9987 | −0,0004 | paredes do slot = 2 arcos quase concêntricos ajustados |
| Tensioner_Block | 0,9984 | 0,9904 | −0,0080 | canais laterais espelho exato; tol de vetorização 0,02 |
| Arm_Guard | 0,9930 | 0,9844 | −0,0086 | 100% paramétrico: cones exatos, leis 45°, secção-ampulheta |
| Snap_Pins | 0,9792 | **0,9818** | **+0,0026** | cadeias de cilindros-patamar cortadas por planos exatos |
| Distals | 0,9839 | 0,9809 | −0,0030 | estações vetorizadas; loft mantido (afunilamento real) |
| Proximals | 0,9796 | 0,9762 | −0,0034 | lóbulos r=6,000 concêntricos com os furos; 754→212 primitivas |
| Palm_left | 0,9652 | 0,9641 | −0,0011 | 665 lâminas colapsadas; cúpula honestamente orgânica |
| Palm_right | 0,9652 | 0,9641 | −0,0011 | espelho único do plano semântico esquerdo |

O caso Snap_Pins merece destaque metodológico: a semanticização **subiu** o
IoU — a exigência de exprimir cada pino como primitivas nomeadas revelou que
as secções eram círculos achatados por planos exatos, que os hulls do v1
circunscreviam como círculos completos. A legibilidade não foi um custo:
foi um instrumento de medição adicional. Nos casos contrários (afunilamento
dos Distals, curvatura da cúpula das palmas), a medição negou a existência de
leis dentro das tolerâncias e as regiões mantiveram-se como bandas medidas
com nomes semânticos — o resíduo do ajuste é sempre o árbitro.

### 7.y Sólidos-lei: máquina vs afinação manual (Proximals)

A decomposição secção-parâmetro-lei foi confrontada com o template afinado à
mão (`openscad-parametric-reconstructor/templates/Proximals.scad`). O
resultado valida a *linguagem* e corrige os *valores*: o autor humano acertou
na forma de todas as leis (domo longitudinal cilíndrico, scoops côncavos no
ventre, afunilamento linear), mas a máquina mediu domo r=52,34 (não 60),
scoops assimétricos (traseiro r=11,76; frontal r=7,57 com resíduo 0,009 — um
círculo quase exato que o olho leu como simétrico) e inclinação da pala
−6,4° (não −6,0°). As features pequenas do template (knuckle r6,0; furo 2,33;
túnel 1,12) correspondem às faces exatas do B-rep (6,000; 2,300/2,375;
1,125). IoU 0,9716 (custo −0,0046, citado), crown de 46 primitivas → 9
sólidos-lei + 11 parâmetros.

### 7.z Arquitetura de acoplamento palma ↔ dedos (faces exatas)

A cirurgia guiada pelo auditor de cobertura reivindicou a arquitetura de
acoplamento da palma — todas as medidas são faces exatas do B-rep citadas
no plano:

| Feature da palma | Medida | Contraparte | Folga |
|---|---|---|---|
| Encaixe de dedo (×4) | 6,00 | viga do proximal 5,200 | 0,80 |
| Coroa das paredes clevis | r6,000 | lóbulo do proximal r6,000 | à face |
| Garganta do polegar | 6,00 a 50,000° exatos | família dos encaixes | — |
| Ranhura de elástico (×4) | 2,20, pontas r1,10 | elástico de retorno | — |
| Aba de retenção dorsal | 2,64 | clip do proximal | — |
| Parede do punho (×2) | 5,00 | orelhas r8,000 | — |

O ciclo observação-humana → detetor-genérico repetiu-se quatro vezes nesta
fase (escadas nas leis → emissão lisa; círculos fatiados →
`round_regions_perp_z`; geometria por reconhecer → `unclaimed_faces`;
planos sob lofts → estágio de aparos com validação FP-only que rejeitou 11
de 18 candidatos por cortarem material verdadeiro).

## 8. Detalhe dos scripts

### 8.1 Módulos permanentes do pipeline (`src/step2scad/`)

Código determinístico e reutilizável — nenhuma decisão de estratégia vive
aqui. Mesma entrada → mesma saída.

**`cli.py` / `__main__.py`** — ponto de entrada
`python3 -m step2scad <ficheiro.step> [--plan plan.json] [--until ESTÁGIO]
[--out DIR] [--icp]`. Imprime o resumo final (IoU, veredicto) e reencaminha
para o orquestrador.

**`pipeline.py`** — orquestrador dos seis estágios (ingest → classify →
emit → export → eval → refine). Escreve todos os artefactos de `output/
<peça>/`, imprime o diagnóstico localizado ordenado e o resultado das
asserções. Aceita o `plan.json` e injeta-o na classificação e na emissão.

**`ingest/step_reader.py`** — leitura do B-rep via OpenCASCADE. Por sólido:
uma ficha por face com tipo de superfície e parâmetros exatos (plano:
normal+origem; cilindro: eixo+raio; cone: semi-ângulo+raio de referência;
esfera; toro: raios maior/menor), intervalos paramétricos `u/v` (dos quais
se derivam extensões axiais e arcos exatos), orientação (face invertida =
furo), grafo de adjacência com o tipo de curva e a convexidade de cada
transição (côncava/convexa/tangencial, via `ChFi3d`), volume, centróide,
bbox e eixos principais. Saída: `features.json` — a fonte única de verdade
dimensional. *Limitação conhecida:* as normais de plano são as naturais da
superfície (não corrigidas pela orientação da face).

**`ingest/tessellate.py`** — tesselação de referência (deflexão 0,1 % da
diagonal por defeito; parametrizável — os contornos medidos usam 0,008–0,01).
Inclui a reparação de estanquidade: remoção de triângulos degenerados e de
fragmentos de 1–2 triângulos, e **costura por corpo** dos anéis de fronteira
deixados por faces-lasca que o OCC recusa triangular (vistos: um blend
tórico de 0,4 mm², um plano de 0,05 mm²), com correção de orientação e
descarte de bolhas de volume nulo. Sem esta reparação a referência não é
estanque e todo o pipeline de avaliação degrada.

**`classify/heuristics.py`** — classificador heurístico *apenas sugestivo*
(rotational/prismático/csg/freeform, por frações de área e clusters de
eixos). Desde a introdução do plano, a sua saída fica registada como
`suggested_strategy` para auditoria; a decisão real é do agente.

**`plan.py`** — esquema e validação do plano. Estrutura: lista de corpos,
cada um com `strategy` (`csg`, `instance_of`, `rotate_extrude`, …) e, para
CSG, uma árvore de nós: combinadores (`union`/`difference`/`intersection`/
`hull`) sobre primitivas `box` (min+size ou center+size+rotate), `cylinder`
(p0→p1, r, r2 opcional para troncos de cone), `sphere` e `extrude` (polígono
2D medido ao longo de um eixo do mundo; convenção cíclica dos eixos no plano
do perfil: x→(y,z), y→(z,x), z→(x,y)). Validação estrita: cada primitiva
exige `name` e `source` (proveniência); dimensões positivas; `instance_of`
exige corpo-mãe anterior e vetor de translação. Um plano inválido é erro
imediato.

**`emit/csg.py`** — emissor plan-driven. Percorre a árvore e emite OpenSCAD
legível: um bloco de variáveis nomeadas por primitiva (com o `source` em
comentário) e um módulo por corpo cuja árvore CSG espelha o plano 1:1.
Comprimentos de cilindros calculados no próprio OpenSCAD
(`norm(p1-p0)`) para que editar uma variável continue a editar a geometria;
rotações de extrusão emitidas como `rotate([...])` fixos que implementam a
convenção cíclica. `instance_of` emite `translate(delta) corpo_mãe()`.

**`emit/revolve.py`** — emissor de sólidos de revolução: reconstrói o
perfil RZ exato a partir das faces coaxiais (cilindros → segmentos
verticais; cones → segmentos inclinados; toros/esferas → arcos
discretizados dos parâmetros exatos; planos ⟂ eixo → patamares), monta as
envolventes exterior e interior por nós de cota, e **autoverifica** o volume
do sólido de revolução (teorema de Pappus) contra o volume exato do B-rep
(tolerância 2 %) antes de escrever geometria. Variáveis com nomes semânticos
(`bore_r`, `od_r`, `flange_h`, chanfros) e proveniência por face.

**`emit/placeholder.py`** — despacho de estratégias por corpo (plano →
`csg`/`instance_of`; classificação → `rotate_extrude`; restos → stub bbox
documentado). Com plano presente, qualquer falha é fatal — nunca um
substituto silencioso.

**`refine.py`** — ciclo de refinamento automático para corpos de revolução:
converte défices/excessos de área de secção a cada cota em correções radiais
de primeira ordem (dr = ΔA / 2πr) aplicadas como *overrides* de vértices do
perfil, re-mede, e mantém apenas o que melhora o IoU. Para as restantes
estratégias, o papel equivalente é desempenhado pelo agente no passo 6.

**`render.py`** — invólucro do binário OpenSCAD: STL sempre com
`--backend Manifold` (garantia de malha manifold), PNGs multi-ângulo.

**`eval/iou.py`** — alinhamento (identidade preferida com margem de 1 %;
candidatos por centróide e eixos principais pontuados por fração de amostras
contidas) e IoU booleano com cadeia de recurso: (1) motor manifold do
trimesh; (2) repetição após reparação de malha; (3) **booleano do OpenSCAD**
(interseção e união renderizadas e medidas — exato, tolera arestas de
tangência); (4) grelha de voxels (pitch = diagonal/400) como último recurso.
O método usado fica registado em `eval.json`.

**`eval/localized.py`** — diagnóstico *onde e quanto*: grelha de voxels
classificada em FP/FN com agregação em regiões (volume + centróide),
varrimentos de área de secção ao longo dos três eixos (recon vs.
referência), estatísticas de distância à superfície. É a entrada principal
do passo 6.

**`eval/assertions.py`** — asserções estruturais que o IoU não vê:
estanquidade de ambas as malhas, erro de volume, delta de bbox por eixo,
topologia (corpos/Euler/género), simetrias principais, contagem de furos.

**`eval/heatmap.py`** — mapa de calor da distância recon→referência
(PNG multi-vista + PLY colorido) para a verificação visual do passo 5.

**`probe.py`** — CLI de perceção ativa sobre qualquer modelo
(`.step`/`.stl`/`.scad`, com cache de tesselação): `contains`, `raycast`
(segmentos material/vazio → espessuras e posições de paredes lidas
diretamente), `distance`, `section`/`area`/`slices` (+ PNG), `bbox`,
`volume`, `massprops`, `nearest-feature` (ponto → face B-rep exata mais
próxima, via BRepExtrema), `compare` (IoU rápido entre dois modelos).

**`report.py`** — resumo de autoria por corpo: planos agrupados por normal
(faces complanares fundidas, ordenadas por offset), cilindros agrupados por
eixo (raio, extensão no mundo derivada dos `v_range` exatos, furo/ressalto,
arco completo/parcial), cones/toros/esferas, b-splines com graus e
vizinhança. É o que torna um `features.json` de 400 faces legível para
decidir estratégia.

### 8.2 Scripts de autoria de planos (`scripts/authoring/`)

Um por peça; escritos pelo agente durante a reconstrução e preservados como
material suplementar. O seu papel é **derivar mecanicamente** cada valor do
plano a partir de `features.json` e de medições — a estratégia está na
estrutura do script; nenhum número é escrito à mão. Todos terminam com
`json.dump(plan, "output/<peça>/plan.json")`.

**`author_pin_plan.py`** (Tensioner_Pins, IoU 0,9991) — vértices dos três
octógonos calculados como interseções de pares de equações de planos exatos
(`isect2`); paredes da ranhura amostradas por raycast a 15 cotas (validada a
natureza prismática: variação < 3 µm em x) com extrapolação linear
declarada nos extremos; furo cego do cilindro exato + plano de fundo;
corpos 1/2 por delta exato de centróides.

**`author_tblock_plan.py`** (Tensioner_Block, 0,9984) — contornos da torre
prismática e da flange medidos em secções de tesselação fina (deflexão
0,008; a lição da polarização de 0,05 mm dos contornos nasceu aqui); planos
z exatos para todos os patamares; esfera de detenção exata; três canais
prismáticos por lóbulos interiores medidos.

**`author_armguard_plan.py`** (Arm_Guard, 0,9930) — pilha 2,5D: contornos
(exterior somado + furos subtraídos) medidos no plano médio de cada banda,
extrudidos entre cotas z exatas do B-rep, com subdivisão de todas as bandas
a ≤ 0,25 mm (o que mantém o escadeamento das rampas de 45° dentro da
tolerância); fusão de cotas quase duplicadas (< 5 µm); decimação 0,03 mm.
A experiência falhada (cortes por caixas de meio-espaço inclinadas escavam
o tabuleiro sob salientes) foi revertida e está documentada no relatório do
agente e nas notas do plano — não sobrevive no código final.

**`author_snap_pins_plan.py`** (Snap_Pins, 0,9792) — hull-loft por pino ao
longo do eixo longo + cortes verticais de silhueta (casco-menos-contorno em
planta, via `shapely`, com tampão de +0,015 mm para evitar paredes de corte
coincidentes com a superfície do loft); o espelhamento de um dos pinos foi
identificado na fase de análise (assinaturas de faces-âncora — relatório do
agente) e o corpo espelhado recebeu plano próprio integralmente medido;
anilhas delegadas ao caminho `rotate_extrude` (sem entrada no plano);
rótulos gravados (< 0,3 mm³) deliberadamente omitidos e documentados no
próprio plano.

**`author_distals_plan.py`** (Distals, 0,9839) — a implementação de
referência do hull-loft: estações densas na lóbula da dobradiça e na ponta;
perfis por casco convexo de secções **fundidas de três fatias** (y ± 0,06) e
passe de reparação por consistência com vizinhos (secções parciais do
trimesh re-amostradas ou descartadas); cortes exatos: garfo (paredes/planos
exatos + parede frontal inclinada), alívio r7,5, furo do pino com
escareados, ranhura inferior com coves r2, canal superior (plano inclinado
exato), barra do cordão como `union` de cilindros exatos com o topo cortado
na tangente medida (a lição do `hull` que enchia as concavidades); corpos
3/4 por `instance_of`.

**`author_palm_left.py`** (Palm_left, 0,9652) — a implementação de
referência da concha não convexa: `outline_profiles` (lâminas de contorno
não convexas, lóbulos interiores identificados por contenção 2D e
descartados) empilhadas do y mínimo ao máximo da malha; cavidade por
varrimento de ocupação por colunas com solo e teto medidos (primeiro
intervalo de vazio interior por coluna); 105 furos da grelha da base com
arestas ajustadas aos planos exatos; cortes de garfo por **intervalos de
vazio** por linha com material agregado em três estações na largura;
ranhura do polegar em caixas rodadas finas por linha (planos oblíquos
exatos); barril do pulso e baía com paredes inclinadas medidas a duas
cotas; canais de tendão como todos os cilindros invertidos r∈{1,0;1,1;1,15}
cortados segmento-a-segmento pelos seus eixos exatos.

**`mirror_palm_plan.py`** (Palm_right, 0,9652) — transformação mecânica
x→−x do plano Palm_left validado: caixas (min/center negados, ângulo z
negado), cilindros (p0/p1), perfis de extrusão conforme o eixo (negação da
coordenada certa da convenção cíclica; extensões trocadas para eixo x).
Pré-condição verificada: espelhamento provado por Δvolume de 8 ppm e
centróides x-negados. Cada `source` mantém a proveniência acrescentando a
nota de espelhamento.

**`author_proximals_plan.py`** (Proximals, 0,9796) — lofts em três zonas
(viga com pontos restringidos à janela exata das paredes; crista dorsal em
**duas bandas** — tronco entre as paredes laterais exatas e cobertura numa
janela alargada acima do sotobanco medido, porque a cobertura alarga
~0,35 mm além das paredes do tronco; coroa a toda a largura); cortes: túnel
do tendão (face cilíndrica exata r1,125), ranhuras de canal tangentes ao
túnel fora da ponte de piso medida (paredes da ponte desambiguadas por
medição quando a lista de faces é ambígua), dois furos de pino exatos,
rebaixos sob o tabuleiro até ao sotobanco medido por raycast, bolsa do
elástico (piso = plano +z exato; parede traseira medida por raycast, sem
plano analítico) com ombros laterais a flanquear a crista central (cujo
alargamento no topo é medido para os cortes não a deceparem), e **garfo
palmar** (vão a toda a altura entre planos de parede exatos — invisível nas
montagens de secções, encontrado por raycast); corpos 0/1/4 por
`instance_of` com deltas exatos.

*(Nota: o script de autoria inicial do Palm_right pelo agente dedicado —
duas conchas hull-loft recortadas, IoU 0,9271 — foi substituído pela via do
espelhamento; fica no histórico como evidência da lição §5.1.)*
