// Chaveiro MARIA - MDF 3 mm - laser
// Unidades: mm. Somente 2D. Sem compensacao de kerf.

// ---- Camada: "cut" (contornos e furos) ou "engrave" (texto) ----
layer = "cut";

// ---- Peca ----
piece_w   = 70;     // largura (mm)
piece_h   = 25;     // altura (mm)
piece_t   = 3;      // espessura do MDF (mm), informativo
corner_r  = 4;      // raio dos cantos (mm)
clearance = 0;      // folga (mm), so para encaixes; esta peca nao tem encaixe

// ---- Furo da argola ----
hole_d = 4.5;           // diametro do furo (mm)
hole_x = 9;             // centro X do furo (mm, a partir da borda esquerda)
hole_y = piece_h / 2;   // centro Y do furo (mm)

// ---- Texto gravado ----
txt       = "MARIA";
font      = "Liberation Sans:style=Bold";
text_size = 7;                        // tamanho do texto (mm)
text_x0   = 15;                       // limite esquerdo da area do texto (mm)
text_x1   = 66;                       // limite direito da area do texto (mm)
text_cx   = (text_x0 + text_x1) / 2;  // centro X do texto (mm)
text_cy   = piece_h / 2;              // centro Y do texto (mm)

// ---- Marcas de registro ----
mark_d   = 0.6;   // diametro (mm)
mark_off = 3;     // distancia do canto da peca (mm)
mark_fn  = 24;    // facetas do circulo

// ---- Resolucao ----
fn_corner = 64;
fn_hole   = 64;

// ---- Modulos ----
module mark_at(p) {
  translate(p) circle(d = mark_d, $fn = mark_fn);
}

module rounded_rect(w, h, r) {
  hull()
    for (p = [[r, r], [w - r, r], [r, h - r], [w - r, h - r]])
      translate(p) circle(r = r, $fn = fn_corner);
}

module cut_layer() {
  difference() {
    rounded_rect(piece_w, piece_h, corner_r);
    translate([hole_x, hole_y]) circle(d = hole_d, $fn = fn_hole);
  }
  mark_at([-mark_off, -mark_off]);
  mark_at([piece_w + mark_off, piece_h + mark_off]);
}

module engrave_layer() {
  translate([text_cx, text_cy])
    text(txt, size = text_size, font = font, halign = "center", valign = "center");
  mark_at([-mark_off, -mark_off]);
  mark_at([piece_w + mark_off, piece_h + mark_off]);
}

// ---- Selecao de camada ----
if (layer == "cut") {
  cut_layer();
} else if (layer == "engrave") {
  engrave_layer();
} else {
  echo("ERRO: layer deve ser \"cut\" ou \"engrave\"");
}

// ---- Medidas finais ----
echo("layer", layer);
echo("Peca largura x altura x espessura (mm)", piece_w, piece_h, piece_t);
echo("Raio dos cantos (mm)", corner_r);
echo("Clearance (mm)", clearance);
echo("Furo diametro, centro X, centro Y (mm)", hole_d, hole_x, hole_y);
echo("Furo borda esquerda (mm)", hole_x - hole_d / 2);
echo("Furo borda direita (mm)", hole_x + hole_d / 2);
echo("Texto", txt, text_size, text_cx, text_cy);
echo("Marca diametro (mm)", mark_d);
echo("Marca inferior esquerda centro (mm)", -mark_off, -mark_off);
echo("Marca superior direita centro (mm)", piece_w + mark_off, piece_h + mark_off);
echo("Extensao X com marcas (mm)", -mark_off - mark_d / 2, piece_w + mark_off + mark_d / 2);
echo("Extensao Y com marcas (mm)", -mark_off - mark_d / 2, piece_h + mark_off + mark_d / 2);
