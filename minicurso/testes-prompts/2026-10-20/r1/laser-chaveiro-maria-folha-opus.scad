// ================= PARAMETROS (mm) =================
layer         = "cut";    // "cut" = contorno + furo; "engrave" = texto
piece_w       = 70;       // largura da peca
piece_h       = 25;       // altura da peca
corner_r      = 4;        // raio dos cantos
material_t    = 3;        // espessura do MDF (so informativo, arquivo e 2D)
hole_d        = 4.5;      // diametro do furo da argola
hole_edge     = 3.5;      // da borda do furo ate a borda esquerda da peca
name          = "MARIA";  // nome gravado
font          = "Liberation Sans:style=Bold"; // fonte
text_gap_hole = 3;        // distancia minima entre o texto e o furo
text_margin   = 3;        // distancia minima entre o texto e as bordas
text_size_max = 12;       // tamanho maximo da letra (altura da maiuscula, aprox.)
char_w_factor = 1.10;     // largura estimada por letra / tamanho (conservador p/ maiusculas Bold)
clearance     = 0;        // folga de encaixe: esta peca nao tem encaixe, sem uso
mark_d        = 0.6;      // diametro das marcas de registro
mark_offset   = 3;        // distancia das marcas para fora dos cantos (em X e em Y)
$fn           = 96;       // resolucao dos arcos

// ================= VALORES DERIVADOS =================
hole_cx     = hole_edge + hole_d / 2;               // centro do furo em X
hole_cy     = piece_h / 2;                          // centro do furo em Y
text_x0     = hole_cx + hole_d / 2 + text_gap_hole; // inicio da area do texto
text_x1     = piece_w - text_margin;                // fim da area do texto
text_area_w = text_x1 - text_x0;                    // largura disponivel
text_area_h = piece_h - 2 * text_margin;            // altura disponivel
text_size   = min(text_size_max,
                  text_area_w / (len(name) * char_w_factor),
                  text_area_h);                     // letra reduzida se o nome for comprido
text_cx     = (text_x0 + text_x1) / 2;              // centro da area do texto
text_w_est  = len(name) * char_w_factor * text_size; // largura estimada (teto)

assert(layer == "cut" || layer == "engrave", "layer deve ser \"cut\" ou \"engrave\"");
assert(text_area_w > 0, "nao sobra espaco para o texto");

// ================= MEDIDAS =================
echo(str("Peca: ", piece_w, " x ", piece_h, " mm, raio ", corner_r, " mm, MDF ", material_t, " mm"));
echo(str("Furo: d=", hole_d, " mm, centro (", hole_cx, ", ", hole_cy, "), borda a ", hole_edge, " mm da esquerda"));
echo(str("Area do texto: X ", text_x0, " a ", text_x1, " (", text_area_w, " mm) x ", text_area_h, " mm"));
echo(str("Texto \"", name, "\": tamanho ", text_size, " mm, largura estimada <= ", text_w_est, " mm"));
echo(str("Marcas: d=", mark_d, " em (", -mark_offset, ", ", -mark_offset, ") e (",
         piece_w + mark_offset, ", ", piece_h + mark_offset, ")"));
echo(str("Camada: ", layer));

// ================= MODULOS =================
module rounded_rect(w, h, r) {
    hull()
        for (x = [r, w - r], y = [r, h - r])
            translate([x, y]) circle(r = r);
}

module registration_marks() {
    translate([-mark_offset, -mark_offset]) circle(d = mark_d);
    translate([piece_w + mark_offset, piece_h + mark_offset]) circle(d = mark_d);
}

// ================= SAIDA =================
if (layer == "cut") {
    difference() {
        rounded_rect(piece_w, piece_h, corner_r);
        translate([hole_cx, hole_cy]) circle(d = hole_d);
    }
    registration_marks();
} else {
    translate([text_cx, piece_h / 2])
        text(name, size = text_size, font = font,
             halign = "center", valign = "center");
    registration_marks();
}
