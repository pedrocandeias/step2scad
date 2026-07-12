// part_y1_z1 — parte independente do distal (celula y[-10.489,0.408] z[8.714,13.9])
// Forma exterior = outline.scad (loft de seccoes X-Z medidas, partilhado pelas 8 partes);
// vazios interiores: fenda central (y<-7) + cavidade (fecha em y=3.8).
$fn = 96;
show_ghost = true;
if (show_ghost) %import("../body0_ref.stl");  // ghost COMPLETO; a parte fica no sitio certo
include <outline.scad>

module cellbox() translate([-34, -10.489, 8.714]) cube([18, 10.897, 5.186]);

include <voids.scad>
module solid() union() {
  difference() {
    outer_body();
    fenda_z1();       // fenda ate y=-8.2 + bolsa sob o piso
    cavity_void();    // vazio acima do piso medido (aberto no dorso)
  }
  intersection() { bridge(); outer_body(); }   // ponte dorsal medida
}
intersection() { solid(); cellbox(); }
