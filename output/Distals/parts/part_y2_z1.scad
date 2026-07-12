// part_y2_z1 — parte independente do distal (celula y[0.408,11.306] z[8.714,15.6])
// Forma exterior = outline.scad (loft de seccoes X-Z medidas, partilhado pelas 8 partes);
// vazios interiores: slot dorsal (y0.98..3.80) + nariz da cavidade.
$fn = 96;
show_ghost = true;
if (show_ghost) %import("../body0_ref.stl");  // ghost COMPLETO; a parte fica no sitio certo
include <outline.scad>

module cellbox() translate([-34, 0.408, 8.714]) cube([18, 10.898, 7.886]);

include <voids.scad>
module solid() union() {
  difference() {
    outer_body();
    cavity_void();    // vazio acima do piso medido (slot dorsal aberto ate y=3.87)
  }
  intersection() { bridge(); outer_body(); }   // ponte dorsal medida
}
intersection() { solid(); cellbox(); }
