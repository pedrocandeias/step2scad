// part_y1_z0 — parte independente do distal (celula y[-10.489,0.408] z[1.118,8.714])
// Forma exterior = outline.scad (loft de seccoes X-Z medidas, partilhado pelas 8 partes);
// vazios interiores: fenda central, canal (par de ranhuras r2); mais o poste-guia.
$fn = 96;
show_ghost = true;
if (show_ghost) %import("../body0_ref.stl");  // ghost COMPLETO; a parte fica no sitio certo
include <outline.scad>

module cellbox() translate([-34, -10.489, 0.118]) cube([18, 10.897, 8.596]);

include <voids.scad>
module solid() union() { difference() {
  outer_body();
  fenda_z0();                                               // fenda ate y=-8.9 + rampa
  hull() for (cx = [-26.08, -24.08])                        // canal medido
    translate([cx, -9.61, 2.82]) rotate([-90, 0, 0]) cylinder(h = 11.85, r = 2.0);
}
  translate([-26.39, -8.42, 1.1]) cube([2.65, 8.72, 3.73]); // poste-guia (topo 0.01 acima do canal p/ CSG limpo)
}
intersection() { solid(); cellbox(); }
