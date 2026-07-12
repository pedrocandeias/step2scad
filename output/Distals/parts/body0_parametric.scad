// body0_parametric — Distals body0 como MODELO PARAMETRICO fundido.
// Cada seccao X-Z = hull de 4 circulos (esq/dir/topo/fundo); os cantos sao
// intersecoes circulo-circulo (fechado, sem dumps de pontos). Tres regimes
// MEDIDOS (fit_arcs_json.py + analise de leis, resduos citados):
//   BACK  y[-21.37,-19.2]: estacoes de controlo (rebordo = feature, nao lei)
//   MID   y[-19.2,9.2]:    estacoes de CONTROLO SEMANTICAS (4 circulos nomeados
//                          cada; sem lei unica — r lateral 12->21->6 nao-monotono)
//   DOME  y[9.2,21.6]:     LEIS puras (arcos/retas em y; rms 0.03-0.17)
// Vazios interiores: voids.scad (fenda/rampa, keyhole, canal, cavidade, ponte).
$fn = 96;
show_ghost = false;
if (show_ghost) %import("../body0_ref.stl");
include <voids.scad>

// ---------------- leis do DOME (ajustadas, rms citado) ----------------
// silhueta: zmax = arco R14.38 c(15.80,1.94) rms 0.113; zmin linear rms 0.156
function dome_zmax(y) = 1.94 + sqrt(14.38*14.38 - (y-15.80)*(y-15.80));
function dome_zmin(y) = 0.6405*y - 2.935;
// circulo esquerdo: cx/cz/r arcos rms 0.084/0.057/0.128
function dome_L(y) = [-1.03 - sqrt(26.63*26.63 - (y-15.14)*(y-15.14)),
                      -12.71 + sqrt(25.88*25.88 - (y-23.66)*(y-23.66)),
                      -20.68 + sqrt(26.24*26.24 - (y-7.97)*(y-7.97))];
// circulo direito: idem rms 0.083/0.061/0.137
function dome_R(y) = [-47.61 + sqrt(25.11*25.11 - (y-15.17)*(y-15.17)),
                      -13.36 + sqrt(26.57*26.57 - (y-23.91)*(y-23.91)),
                      -21.27 + sqrt(26.85*26.85 - (y-7.75)*(y-7.75))];
// coroa/fundo: centro em x fixo (rms 0.03); curvatura linear (so 2a ordem);
// cz derivado de zmax/zmin (a silhueta manda, a curvatura afina)
function dome_T(y) = let(r = 8.364 + 0.5928*y) [-25.016 - 0.0023*y, dome_zmax(y) - r, r];
function dome_B(y) = let(r = 16.764 - 0.3228*y) [-25.068 + 0.0010*y, dome_zmin(y) + r, r];

// ------------- estacoes de controlo (4 circulos [cx,cz,r] MEDIDOS) -------------
// nomes semanticos; editar um circulo muda a seccao local (loft regrado entre elas)
st_back_sliver  = [-21.37, [-31.68,8.135,0.645],[-18.51,8.135,0.645],
                           [-25.1,-991.2,1000],[-25.1,1007.5,1000]];   // estadio 14.5x1.29
st_back_open    = [-21.2, [-30.00,8.12,2.28],[-20.57,8.04,2.48],
                          [-25.51,-28.98,38.59],[-25.51,-45.07,51.75]];
st_back_round   = [-20.8, [-29.91,8.03,2.81],[-20.52,8.14,3.00],
                          [-25.58,-25.11,35.83],[-25.61,-55.66,61.23]];
st_pre_flange   = [-20.4, [-29.30,8.00,3.47],[-20.80,8.14,3.45],
                          [-25.47,-22.51,33.98],[-25.39,-62.91,67.79]];
st_pre_flange2  = [-20.24,[-29.30,8.00,3.47],[-20.80,8.14,3.45],
                          [-25.47,-22.51,33.98],[-25.39,-62.91,67.79]]; // face do rebordo
st_flange       = [-20.18,[-20.87,7.39,11.49],[-25.78,7.12,8.18],
                          [-25.71,-21.26,33.35],[-25.05,26.10,25.14]];  // fundo cai p/ z1.12
st_prong_root   = [-19.2, [-19.79,7.46,12.50],[-28.96,7.52,11.14],
                          [-25.46,-1341.29,1354.05],[-25.12,21.08,20.16]];
st_prong_mid    = [-17.6, [-17.37,7.49,14.73],[-30.24,7.53,12.23],
                          [-25.14,-3.28,17.27],[-25.08,18.70,17.82]];
st_keyhole      = [-15.6, [-15.72,7.36,16.13],[-33.58,7.35,15.31],
                          [-24.95,-2.00,16.37],[-25.18,17.16,16.31]];   // centro da ranhura
st_prong_tip    = [-12.4, [-10.59,7.29,21.08],[-31.32,7.40,12.95],
                          [-25.78,5.49,9.03],[-25.17,10.42,9.82]];
st_fenda_mouth  = [-10.4, [-13.80,7.33,17.92],[-31.61,7.39,13.20],
                          [-24.95,2.16,12.11],[-25.05,16.11,15.28]];
st_fenda_throat = [-9.2,  [-16.97,7.22,14.83],[-32.91,7.24,14.53],
                          [-25.08,-5.75,19.72],[-25.04,14.97,14.21]];
st_fenda_end    = [-8.0,  [-19.12,7.28,12.81],[-32.11,7.25,13.86],
                          [-25.35,-5.24,19.15],[-25.31,19.82,18.95]];   // rampa/bolsa
st_cavity_mid   = [-4.0,  [-22.63,7.01,9.86],[-27.31,7.08,9.61],
                          [-25.16,-3.10,16.77],[-25.21,31.07,30.09]];
st_bridge       = [0.4,   [-25.39,6.90,7.62],[-25.19,6.97,8.00],
                          [-25.18,-5.61,18.93],[-25.18,39.38,38.38]];   // ponte dorsal
st_slot_close   = [3.2,   [-26.43,7.03,6.73],[-23.73,6.99,6.68],
                          [-25.12,-4.40,17.51],[-24.95,28.19,27.20]];   // slot fecha y3.87
st_pre_dome     = [6.0,   [-26.90,7.61,6.23],[-23.19,7.54,6.14],
                          [-25.07,0.64,13.00],[-25.06,13.45,12.39]];
st_dome_rise_a  = [7.6,   [-27.04,8.13,5.98],[-23.15,8.16,6.01],
                          [-25.08,1.37,12.83],[-25.13,14.23,12.43]];
st_dome_rise_b  = [8.4,   [-27.11,8.53,5.87],[-23.11,8.52,5.89],
                          [-25.04,2.03,12.53],[-25.05,14.14,11.90]];
// ponta (alem da validade das leis, medida):
st_tip_a        = [22.0,  [-25.91,13.30,0.87],[-23.98,13.23,0.73],
                          [-25.07,12.04,2.30],[-24.81,17.24,4.81]];
st_tip_b        = [22.17, [-25.52,13.51,0.26],[-24.52,13.48,0.33],
                          [-25.08,12.45,1.42],[-24.94,813.14,800]];     // fundo ~plano z13.14

dome_step = 0.8;
stations = concat(
  [st_back_sliver, st_back_open, st_back_round, st_pre_flange, st_pre_flange2,
   st_flange, st_prong_root, st_prong_mid, st_keyhole, st_prong_tip,
   st_fenda_mouth, st_fenda_throat, st_fenda_end, st_cavity_mid, st_bridge,
   st_slot_close, st_pre_dome, st_dome_rise_a, st_dome_rise_b],
  [for (y = [9.2:dome_step:21.61]) [y, dome_L(y), dome_R(y), dome_T(y), dome_B(y)]],
  [st_tip_a, st_tip_b]);

// -------- seccao = hull de 4 arcos, cantos por intersecao circulo-circulo --------
function isect(A, B, dir, c0) = let(
  d = [B[0]-A[0], B[1]-A[1]], L = norm(d), u = d/L,
  a = (A[2]*A[2] - B[2]*B[2] + L*L) / (2*L),
  h = sqrt(max(A[2]*A[2] - a*a, 0)),
  p0 = [A[0]+a*u[0], A[1]+a*u[1]], n = [-u[1], u[0]],
  pA = p0 + h*n, pB = p0 - h*n)
  ((pA-c0)*dir > (pB-c0)*dir) ? pA : pB;
// caminho CURTO entre cantos (perfis subtendem <180°); em semicirculos (~180°)
// desempata pelo lado EXTERIOR do arco (dira = normal exterior do papel do arco)
function arcpts(C, p0, p1, dira, c0) = let(
  a0 = atan2(p0[1]-C[1], p0[0]-C[0]), a1r = atan2(p1[1]-C[1], p1[0]-C[0]),
  d0 = a1r - a0, dw = d0 - 360*floor(d0/360 + 0.5),          // wrap (-180,180]
  alt = (dw > 0) ? dw-360 : dw+360,
  mid = [C[0]+C[2]*cos(a0+dw/2), C[1]+C[2]*sin(a0+dw/2)],
  sw = (abs(dw) < 170) ? dw : (((mid-c0)*dira > 0) ? dw : alt),
  n = min(200, max(2, ceil(abs(sw)/360*2*PI*C[2] / 0.3))))
  [for (i = [0:n]) [C[0]+C[2]*cos(a0+sw*i/n), C[1]+C[2]*sin(a0+sw*i/n)]];
module prof4(L, R, T, B) {
  c0 = [T[0], (L[1]+R[1])/2];
  lb = isect(L, B, [-1,-1], c0); br = isect(B, R, [ 1,-1], c0);
  rt = isect(R, T, [ 1, 1], c0); tl = isect(T, L, [-1, 1], c0);
  polygon(concat(arcpts(B, lb, br, [0,-1], c0), arcpts(R, br, rt, [1,0], c0),
                 arcpts(T, rt, tl, [0, 1], c0), arcpts(L, tl, lb, [-1,0], c0)));
}
module st_slab(st) translate([0, st[0], 0]) rotate([90, 0, 0])
  linear_extrude(0.02) prof4(st[1], st[2], st[3], st[4]);
module outer_body()   // (mesmo nome que outline.scad: as partes podem trocar)
  for (i = [0:len(stations)-2]) hull() { st_slab(stations[i]); st_slab(stations[i+1]); }

// ------------------------------ peca ------------------------------
module solid() union() {
  difference() {
    outer_body();
    fenda_full();        // fenda + transicao medida (rampa com joelho, bolsa)
    keyhole_slots();     // ranhura keyhole (curta esq. + rebaixo na face + longa dir.)
    back_groove();       // ranhura atras do rebordo do fundo
    canal_void();        // canal do fundo (paredes verticais + teto em arco)
    cavity_void();       // vazio acima do piso medido (slot dorsal aberto)
  }
  translate([-26.39, -8.42, 1.1]) cube([2.65, 8.72, 3.73]); // poste-guia
  intersection() { bridge(); outer_body(); }                // ponte dorsal medida
}
solid();
