// part_y3_z0 — parte independente do distal (celula y[11.306,22.204] z[4.3,8.714])
// Forma exterior = outline.scad (loft de seccoes X-Z medidas, partilhado pelas 8 partes;
// o casco/barriga esta nas seccoes). Sem vazios interiores nesta celula.
$fn = 96;
show_ghost = true;
if (show_ghost) %import("../body0_ref.stl");  // ghost COMPLETO; a parte fica no sitio certo
include <outline.scad>

module cellbox() translate([-34, 11.306, 4.3]) cube([18, 10.898, 4.414]);

intersection() { outer_body(); cellbox(); }
