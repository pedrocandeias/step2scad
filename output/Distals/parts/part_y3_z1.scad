// part_y3_z1 — parte independente do distal (celula y[11.306,22.204] z[8.714,16.31])
// Forma exterior = outline.scad (loft de seccoes X-Z medidas, partilhado pelas 8 partes;
// cupula e ponta estao nas seccoes). Sem vazios interiores nesta celula.
$fn = 96;
show_ghost = true;
if (show_ghost) %import("../body0_ref.stl");  // ghost COMPLETO; a parte fica no sitio certo
include <outline.scad>

module cellbox() translate([-34, 11.306, 8.714]) cube([18, 10.898, 8.596]);

intersection() { outer_body(); cellbox(); }
