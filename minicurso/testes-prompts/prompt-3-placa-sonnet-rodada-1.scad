// ============================================================================
// Placa retangular de cantos arredondados, furos opcionais e texto gravado
// Material: MDF ou acrilico, peca plana. Unidade: mm. Topo do arquivo: so 2D.
// Requer a fonte Liberation Sans instalada no computador que exporta.
// Exportar duas vezes, uma por camada:
//   openscad -D 'layer="cut"' -o cut.svg placa.scad
//   openscad -D 'layer="engrave"' -o engrave.svg placa.scad
//
// PREMISSAS (confira):
// - line_gap fica centrado no meio da placa: a base do titulo fica meio line_gap
//   acima do centro e o topo do subtitulo fica meio line_gap abaixo do centro
//   (a distancia entre as duas linhas e medida entre as letras).
// - O centro de cada marca de registro fica a registration_offset do canto da
//   area ocupada, tanto em x quanto em y.
// - border_inset e medido da borda da placa ate a borda externa do filete
//   (mesmo criterio de hole_margin).
// - O tamanho do texto no OpenSCAD equivale, aproximadamente, a altura das
//   letras maiusculas.
// ============================================================================

// ------------------------------- PARAMETROS ---------------------------------

// camada exportada: cut = contorno e furos, engrave = texto e moldura (texto)
layer = "cut"; // [cut, engrave]

// placa
width = 120;          // largura da placa (mm)
height = 50;          // altura da placa (mm)
corner_radius = 3;    // raio dos cantos arredondados (mm)

// furos de fixacao
holes = 2;            // furos: 0 = sem furos, 2 = cantos de cima, 4 = quatro cantos (quantidade)
hole_diameter = 4;    // diametro dos furos (mm)
hole_margin = 4;      // distancia da borda da placa ate a borda do furo (mm)

// texto gravado
margin = 6;                        // margem entre os textos e a borda da placa (mm)
title = "CASA DA ANA";             // primeira linha do texto (texto)
title_size = 9;                    // altura desejada das letras do titulo (mm)
subtitle = "Artesanato em couro";  // segunda linha do texto (texto)
subtitle_size = 5.5;               // altura desejada das letras do subtitulo (mm)
line_gap = 5;                      // espaco entre as duas linhas (mm)
bold = true;                       // true = negrito, false = normal (sim/nao)
char_width_factor = 0.9;           // largura media de cada letra, como fracao do tamanho da letra (adimensional)

// moldura gravada
border = false;       // true = grava a moldura retangular (sim/nao)
border_width = 0.8;   // largura do filete da moldura (mm)
border_inset = 3.5;   // distancia da borda da placa ate a borda externa do filete (mm)

// marcas de registro
registration = true;          // true = desenha as duas marcas nas duas camadas (sim/nao)
registration_diameter = 0.6;  // diametro das marcas de registro (mm)
registration_offset = 3;      // distancia, em x e em y, do canto da area ocupada ate o centro da marca (mm)
registration_fn = 16;         // numero de segmentos das marcas de registro (adimensional)

// resolucao
$fn = 64;             // numero de segmentos dos circulos, dos cantos e das curvas do texto (adimensional)

/* [Hidden] */

// ----------------------------- VALORES DERIVADOS ----------------------------

font = bold ? "Liberation Sans:style=Bold" : "Liberation Sans";

// area ocupada pelas pecas (aqui, apenas a placa) e centro das marcas de registro
area_min = [0, 0];
area_max = [width, height];
mark_a = area_min - [registration_offset, registration_offset];
mark_b = area_max + [registration_offset, registration_offset];

// furos: distancia da borda da placa ate o CENTRO do furo
hole_offset = hole_margin + hole_diameter / 2;
top_holes = holes >= 2;      // furos nos dois cantos de cima
bottom_holes = holes > 2;    // furos tambem nos dois cantos de baixo

// texto
center_x = width / 2;
center_y = height / 2;
free_width = width - 2 * margin;
title_final_size = min(title_size, free_width / (len(title) * char_width_factor));
subtitle_final_size = min(subtitle_size, free_width / (len(subtitle) * char_width_factor));
title_bottom_y = center_y + line_gap / 2;                  // base do titulo
subtitle_top_y = center_y - line_gap / 2;                  // topo do subtitulo
title_top_y = title_bottom_y + title_final_size;           // topo aproximado do titulo
subtitle_bottom_y = subtitle_top_y - subtitle_final_size;  // base aproximada do subtitulo

// --------------------------------- MODULOS ----------------------------------

// retangulo de cantos arredondados (arredondamento feito com offset)
module outline() {
    offset(r = corner_radius)
        translate([corner_radius, corner_radius])
            square([width - 2 * corner_radius, height - 2 * corner_radius]);
}

module hole_at(x, y) {
    translate([x, y]) circle(d = hole_diameter);
}

module holes_shape() {
    if (top_holes) {
        hole_at(hole_offset, height - hole_offset);
        hole_at(width - hole_offset, height - hole_offset);
    }
    if (bottom_holes) {
        hole_at(hole_offset, hole_offset);
        hole_at(width - hole_offset, hole_offset);
    }
}

// camada de corte: contorno menos os furos
module cut_layer() {
    difference() {
        outline();
        holes_shape();
    }
}

// filete retangular: anel entre o retangulo externo e o interno
module border_frame() {
    inner_inset = border_inset + border_width;
    difference() {
        translate([border_inset, border_inset])
            square([width - 2 * border_inset, height - 2 * border_inset]);
        translate([inner_inset, inner_inset])
            square([width - 2 * inner_inset, height - 2 * inner_inset]);
    }
}

// camada de gravacao: titulo, subtitulo e (opcional) moldura
module engrave_layer() {
    translate([center_x, title_bottom_y])
        text(title, size = title_final_size, font = font,
             halign = "center", valign = "bottom");
    translate([center_x, subtitle_top_y])
        text(subtitle, size = subtitle_final_size, font = font,
             halign = "center", valign = "top");
    if (border) border_frame();
}

// marcas de registro: iguais nas duas camadas
module registration_marks() {
    translate(mark_a) circle(d = registration_diameter, $fn = registration_fn);
    translate(mark_b) circle(d = registration_diameter, $fn = registration_fn);
}

// ----------------------------- CONFERENCIA (mm) -----------------------------

echo("--- conferencia (valores em mm) ---");
echo(layer = layer);
echo(total_width = width, total_height = height);
echo(free_width = free_width);
echo(title_final_size = title_final_size, subtitle_final_size = subtitle_final_size);
echo(title_width_estimate = len(title) * title_final_size * char_width_factor,
     subtitle_width_estimate = len(subtitle) * subtitle_final_size * char_width_factor);
echo(title_bottom_y = title_bottom_y, title_top_y = title_top_y);
echo(subtitle_top_y = subtitle_top_y, subtitle_bottom_y = subtitle_bottom_y);
echo(hole_center_from_edge = hole_offset);
echo(registration_mark_a = mark_a, registration_mark_b = mark_b);
echo(frame_width = mark_b[0] - mark_a[0], frame_height = mark_b[1] - mark_a[1]);

if (layer != "cut" && layer != "engrave")
    echo("AVISO: layer deve ser cut ou engrave");
if (holes < 0 || holes % 2 != 0)
    echo("AVISO: holes deve ser zero, dois ou quatro");
if (title_top_y > height - margin || subtitle_bottom_y < margin)
    echo("AVISO: o bloco de texto passa da margem vertical");

// ------------------------------ SAIDA (so 2D) -------------------------------

if (layer == "cut") cut_layer();
if (layer == "engrave") engrave_layer();
if (registration) registration_marks();
