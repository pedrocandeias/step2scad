// part_y2_z0 — parte independente do distal (celula y[0.408,11.306] z[1.118,8.714])
// Forma exterior = outline.scad (loft de seccoes X-Z medidas, partilhado pelas 8 partes,
// inclui a barriga frontal); vazio interior: cauda do canal (ate y=2.24).
$fn = 96;
show_ghost = true;
if (show_ghost) %import("../body0_ref.stl");  // ghost COMPLETO; a parte fica no sitio certo
include <outline.scad>

module cellbox() translate([-34, 0.408, 0.118]) cube([18, 10.898, 8.596]);

module solid() difference() {
  outer_body();
  hull() for (cx = [-26.08, -24.08])                          // cauda do canal
    translate([cx, 0.3, 2.82]) rotate([-90, 0, 0]) cylinder(h = 1.95, r = 2.0);
}
intersection() { solid(); cellbox(); }
