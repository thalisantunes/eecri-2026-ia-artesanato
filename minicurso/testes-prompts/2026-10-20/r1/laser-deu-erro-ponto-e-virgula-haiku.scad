// Chaveiro com nome - MDF 3 mm
tag_w = 70;          // largura da peça (mm)
tag_h = 25;          // altura da peça (mm)
corner_r = 4;        // raio dos cantos (mm)
hole_d = 4.5;        // diâmetro do furo da argola (mm)
hole_edge = 3.5;     // borda do furo até a borda esquerda da peça (mm)
gap = 3;             // distância mínima do texto ao furo e às bordas (mm)
clearance = 0;       // folga (mm), só para encaixes; não há encaixe neste chaveiro
name = "MARIA";      // nome gravado
font_size = 8;       // altura máxima da letra (mm)
char_w = 0.7;        // largura média estimada de cada letra, em múltiplo de size
mark_d = 0.6;        // diâmetro das marcas de registro (mm)
mark_off = 3;        // distância das marcas ao canto (mm)
layer = "cut";       // "cut" ou "engrave"
$fn = 64;

hole_x = hole_edge + hole_d / 2;
hole_y = tag_h / 2;
text_x0 = hole_x + hole_d / 2 + gap;
text_w = tag_w - gap - text_x0;
text_h_max = tag_h - 2 * gap;
fit_size = min(font_size, text_h_max, text_w / (len(name) * char_w));
text_cx = text_x0 + text_w / 2;

module outline() {
    offset(r = corner_r) offset(delta = -corner_r) square([tag_w, tag_h]);
}

module marks() {
    translate([-mark_off, -mark_off]) circle(d = mark_d);
    translate([tag_w + mark_off, tag_h + mark_off]) circle(d = mark_d);
}

if (layer == "cut") {
    difference() {
        outline();
        translate([hole_x, hole_y]) circle(d = hole_d);
    }
    marks();
} else {
    translate([text_cx, hole_y])
        text(name, size = fit_size, font = "Liberation Sans:style=Bold",
             halign = "center", valign = "center");
    marks();
}

echo(str("Peça: ", tag_w, " x ", tag_h, " mm, cantos R", corner_r, " mm"));
echo(str("Furo: d = ", hole_d, " mm, centro em x = ", hole_x, " mm, y = ", hole_y, " mm"));
echo(str("Texto: ", name, " em size ", fit_size, " mm, centro em x = ", text_cx, " mm"));
echo(str("Área do texto: x de ", text_x0, " a ", tag_w - gap, " mm"));
echo(str("Marcas: d = ", mark_d, " mm, a ", mark_off, " mm fora dos cantos"));
echo(str("Camada gerada: ", layer));
