// body0_whole — as 8 partes da grelha reunidas numa UNICA peça.
// Mesma arquitetura das partes: forma exterior = outline.scad (loft de seccoes
// X-Z medidas) menos a uniao dos vazios interiores medidos (voids.scad);
// poste-guia e ponte dorsal adicionados no fim.
$fn = 96;
show_ghost = false;
if (show_ghost) %import("../body0_ref.stl");
include <outline.scad>
include <voids.scad>

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
