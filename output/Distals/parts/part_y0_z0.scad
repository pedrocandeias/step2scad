// part_y0_z0 — parte independente do distal (celula y[-21.387,-10.489] z[1.118,8.714])
// Forma exterior = outline.scad (loft de seccoes X-Z medidas, partilhado pelas 8 partes);
// so os vazios interiores sao subtraidos aqui.
$fn = 96;
show_ghost = true;
if (show_ghost) %import("../body0_ref.stl");  // ghost COMPLETO; a parte fica no sitio certo
include <outline.scad>

module cellbox() translate([-34, -21.387, 0.118]) cube([18, 10.898, 8.596]);

include <voids.scad>
module solid() difference() {
  outer_body();
  translate([-28.08, -22, 0]) cube([6.0, 12.4, 16]);   // fenda entre prongs (ate y-9.6)
  keyhole_slots();   // ranhura keyhole medida (curta na placa esq. + longa no prong dir.)
  back_groove();     // ranhura atras do rebordo do fundo (medida y-20.26..-20.12)
}
intersection() { solid(); cellbox(); }
