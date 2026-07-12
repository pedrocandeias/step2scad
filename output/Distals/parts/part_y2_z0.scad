// part_y2_z0 — parte independente do distal (celula y[0.408,11.306] z[1.118,8.714])
// Forma exterior = outline.scad (loft de seccoes X-Z medidas, partilhado pelas 8 partes,
// inclui a barriga frontal); vazio interior: cauda do canal (ate y=2.24).
$fn = 96;
show_ghost = true;
if (show_ghost) %import("../body0_ref.stl");  // ghost COMPLETO; a parte fica no sitio certo
include <outline.scad>
include <voids.scad>

module cellbox() translate([-34, 0.408, 0.118]) cube([18, 10.898, 8.596]);

module solid() difference() {
  outer_body();
  canal_void(0.3, 1.95);                                      // cauda do canal
}
intersection() { solid(); cellbox(); }
