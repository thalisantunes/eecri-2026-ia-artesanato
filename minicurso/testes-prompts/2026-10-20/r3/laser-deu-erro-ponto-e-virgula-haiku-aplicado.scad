// Chaveiro com nome - MDF 3 mm
tag_w = 70;          // largura da peça (mm)
tag_h = 25;          // altura da peça (mm)
corner_r = 4;        // raio dos cantos (mm)
hole_d = 4.5;        // diâmetro do furo (mm)
hole_edge = 3.5;     // borda do furo até a borda esquerda (mm)
gap = 3;             // folga mínima do texto (mm)
name = "MARIA";      // nome gravado
font_size = 8;        // altura da letra (mm)
mark_d = 0.6;        // diâmetro das marcas de registro (mm)
mark_off = 3;        // distância das marcas ao canto (mm)
layer = "cut";       // "cut" ou "engrave"
$fn = 64;

hole_x = hole_edge + hole_d / 2;
hole_y = tag_h / 2;
text_x0 = hole_x + hole_d / 2 + gap;
text_w = tag_w - gap - text_x0;

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
    translate([text_x0 + text_w / 2, hole_y])
        text(name, size = font_size, font = "Liberation Sans:style=Bold",
             halign = "center", valign = "center");
    marks();
}

echo(str("Peça: ", tag_w, " x ", tag_h, " mm"));
echo(str("Furo: ", hole_d, " mm, letra: ", font_size, " mm"));
