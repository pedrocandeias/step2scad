// voids.scad — vazios interiores MEDIDOS do distal body0 (probe_col.py em colunas z),
// partilhados pelas partes. Perfis em (y,z), extrudidos em x via rotate([90,0,90]).
// Banda central (fenda/cavidade/canal): x[-28.08,-22.08].

cx0 = -28.08; cx1 = -22.08;  // banda central
module band_prism(h0 = 0, h1 = 16) { }  // (doc)

module yz_prism(x0, len) translate([x0, 0, 0]) rotate([90, 0, 90])
  linear_extrude(len) children();

// ---- keyhole slot (substitui os furos circulares): vazio z~[6.1,10.3] ----
// slot CURTO (placa esq., x ate -21.08), com abocardado (flare) na face exterior
module slot_short_2d() polygon([   // medido em x=-29
  [-17.75, 8.18], [-17.5, 7.45], [-17.2, 6.85], [-16.9, 6.50], [-15.4, 6.15],
  [-13.9, 6.45], [-13.6, 6.75], [-13.3, 7.25], [-13.05, 8.18],
  [-13.3, 9.10], [-13.6, 9.60], [-13.9, 9.90], [-15.4, 10.20],
  [-16.9, 9.85], [-17.2, 9.50], [-17.5, 8.90]]);
module slot_counterbore_2d() polygon([   // rebaixo medido (x-31..-29.6, constante ate a face)
  [-18.05, 8.18], [-17.8, 6.90], [-16.9, 5.85], [-15.4, 5.40], [-13.9, 5.80],
  [-13.0, 6.75], [-12.7, 8.18], [-13.0, 9.60], [-13.6, 10.30], [-13.9, 10.50],
  [-15.4, 10.95], [-16.9, 10.45], [-17.2, 10.25], [-17.8, 9.45]]);
// slot LONGO (prong dir., x>-21.08): tampas diagonais medidas
module slot_long_2d() polygon([
  [-18.45, 6.30], [-12.9, 6.00], [-12.6, 6.00], [-12.3, 9.15], [-12.12, 10.00],
  [-12.9, 10.05], [-18.1, 10.35], [-18.4, 7.70]]);
module keyhole_slots() {
  yz_prism(-32.5, 3.2) slot_counterbore_2d(); // rebaixo: face esq. ate x=-29.3
  yz_prism(-29.3, 8.22) slot_short_2d();      // ate x=-21.08 (degrau medido)
  yz_prism(-21.08, 5.2) slot_long_2d();       // atraves do prong direito
}

// ranhura horizontal atras do rebordo traseiro-fundo (lip chanfrado medido)
module back_groove() yz_prism(-33, 16) polygon([
  [-20.26, 1.25], [-20.22, 2.55], [-20.18, 3.25], [-20.12, 4.50], [-20.26, 4.50]]);

// ---- fenda central + transicao (a fenda acaba em y=-8.9; rampa com joelho,
// bolsa sob o piso e frente cheia em y=-7.85 — tudo medido por colunas z) ----
module fenda_full() {
  translate([cx0, -22, 0]) cube([cx1 - cx0, 13.1, 16]);   // fenda ate y=-8.9
  yz_prism(cx0, cx1 - cx0) polygon([                       // vazio da transicao:
    [-8.9, 1.15], [-8.5, 1.90], [-8.3, 5.65], [-8.1, 6.30],   // rampa (joelho medido)
    [-8.0, 6.80], [-7.9, 7.55], [-7.85, 8.20],                // frente cheia y-7.85
    [-7.9, 8.90], [-8.0, 9.60], [-8.04, 9.60],                // sob o piso (bolsa)
    [-8.04, 16.0], [-8.9, 16.0]]);
}
module fenda_z0() fenda_full();              // celulas z0/z1: o cellbox recorta
module fenda_z1() fenda_full();

// ---- cavidade central: vazio acima do PISO medido (o teto e' a ponte) ----
// piso medido (topo do material inferior) por y; vazio = acima do piso.
module cavity_void() yz_prism(cx0, cx1 - cx0) polygon([
  [-8.05, 9.70], [-7.9, 10.10], [-7.8, 10.20], [-7.5, 10.15], [-6.0, 10.10], [-4.0, 9.95],
  [-2.0, 9.85], [-1.0, 9.75], [0.5, 9.70], [1.0, 9.75], [1.5, 9.90],
  [1.8, 10.05], [2.2, 10.25], [3.0, 11.00], [3.5, 11.85], [3.87, 13.05],
  [3.87, 16.0], [-8.05, 16.0]]);
// ponte (strap) dorsal medida: y[-1.35,1.35], por cima da cavidade
module bridge() yz_prism(cx0, cx1 - cx0) polygon([
  [-1.35, 13.30], [-1.0, 12.00], [-0.5, 11.75], [0.2, 11.70], [0.5, 11.80],
  [1.0, 12.25], [1.3, 12.55], [1.3, 12.70], [1.0, 12.75], [0.5, 13.10],
  [0.2, 13.15], [-1.0, 13.20]]);
