// Placa retangular com cantos arredondados, furos de fixacao e texto gravado
// OpenSCAD 2021.01 - tudo em mm - so geometria 2D no topo do arquivo

// ---------- PARAMETROS ----------
// camada exportada: cut = corte (contorno e furos); engrave = gravacao (textos e moldura)
layer = "cut"; // [cut, engrave]

width = 120;            // largura da placa (mm)
height = 50;            // altura da placa (mm)
corner_radius = 3;      // raio dos cantos arredondados (mm)
margin = 6;             // margem entre os textos e a borda da placa (mm)

holes = 2;              // furos: 0 = nenhum, 2 = cantos de cima, 4 = quatro cantos
hole_diameter = 4;      // diametro dos furos de fixacao (mm)
hole_margin = 4;        // distancia da borda da placa ate a borda do furo (mm)

title = "CASA DA ANA";              // primeira linha (texto)
title_size = 9;                     // tamanho desejado da primeira linha (mm, size do OpenSCAD)
subtitle = "Artesanato em couro";   // segunda linha (texto)
subtitle_size = 5.5;                // tamanho desejado da segunda linha (mm, size do OpenSCAD)
line_gap = 5;                       // espaco livre entre a base do titulo e o topo do subtitulo (mm)
bold = true;                        // true = negrito (Liberation Sans Bold); false = normal

border = false;         // true = liga a moldura gravada
border_width = 0.8;     // espessura do filete da moldura (mm)
border_inset = 2.5;     // recuo da face externa da moldura ate a borda da placa (mm)

registration = true;    // true = marcas de registro nas duas camadas
reg_diameter = 0.6;     // diametro das marcas de registro (mm)
reg_offset = 3;         // distancia de cada marca ao canto da placa, em X e em Y (mm)
reg_fn = 16;            // segmentos dos circulos das marcas (segmentos)

$fn = 64;               // segmentos dos circulos (segmentos)

// ---------- CALCULOS DERIVADOS ----------
free_width = width - 2 * margin;                                       // largura livre para cada linha de texto (mm)
title_final_size = min(title_size, free_width / len(title));          // tamanho final da linha 1 (mm)
subtitle_final_size = min(subtitle_size, free_width / len(subtitle));  // tamanho final da linha 2 (mm)
font = bold ? "Liberation Sans:style=Bold" : "Liberation Sans";        // fonte dos textos

title_baseline_y = height / 2 + line_gap / 2;   // base do titulo em Y (mm), logo acima do centro
subtitle_top_y = height / 2 - line_gap / 2;     // topo do subtitulo em Y (mm), logo abaixo do centro

hole_x_left = hole_margin + hole_diameter / 2;              // centro dos furos da esquerda em X (mm)
hole_x_right = width - hole_margin - hole_diameter / 2;     // centro dos furos da direita em X (mm)
hole_y_bottom = hole_margin + hole_diameter / 2;            // centro dos furos de baixo em Y (mm)
hole_y_top = height - hole_margin - hole_diameter / 2;      // centro dos furos de cima em Y (mm)
top_holes_on = holes > 0;                                   // furos nos cantos de cima (true ou false)
bottom_holes_on = holes > 2;                                // furos nos cantos de baixo (true ou false)
top_hole_centers = top_holes_on ? [[hole_x_left, hole_y_top], [hole_x_right, hole_y_top]] : [];
bottom_hole_centers = bottom_holes_on ? [[hole_x_left, hole_y_bottom], [hole_x_right, hole_y_bottom]] : [];

border_inner_inset = border_inset + border_width;   // recuo da face interna da moldura (mm)

frame_margin = registration ? reg_offset + reg_diameter / 2 : 0;   // folga do quadro com as marcas (mm)
frame_width = width + 2 * frame_margin;             // largura total do quadro com marcas (mm)
frame_height = height + 2 * frame_margin;           // altura total do quadro com marcas (mm)

// ---------- MODULOS ----------
// contorno arredondado com offset (sem minkowski): offset interno e depois externo
module plate_outline() {
    offset(r = corner_radius)
        offset(delta = -corner_radius)
            square([width, height]);
}

// moldura gravada: retangulo com filete de border_width, recuado border_inset da borda
module border_frame() {
    difference() {
        translate([border_inset, border_inset])
            square([width - 2 * border_inset, height - 2 * border_inset]);
        translate([border_inner_inset, border_inner_inset])
            square([width - 2 * border_inner_inset, height - 2 * border_inner_inset]);
    }
}

// marcas de registro: uma abaixo a esquerda e outra acima a direita, fora da placa
module registration_marks() {
    if (registration) {
        translate([-reg_offset, -reg_offset])
            circle(d = reg_diameter, $fn = reg_fn);
        translate([width + reg_offset, height + reg_offset])
            circle(d = reg_diameter, $fn = reg_fn);
    }
}

// linha 1: titulo centralizado na horizontal, base logo acima do centro
module title_text() {
    translate([width / 2, title_baseline_y])
        text(title, size = title_final_size, font = font, halign = "center", valign = "baseline");
}

// linha 2: subtitulo centralizado na horizontal, topo logo abaixo do centro
module subtitle_text() {
    translate([width / 2, subtitle_top_y])
        text(subtitle, size = subtitle_final_size, font = font, halign = "center", valign = "top");
}

// camada cut: contorno menos os furos, mais as marcas de registro
module cut_layer() {
    difference() {
        plate_outline();
        for (p = top_hole_centers) translate(p) circle(d = hole_diameter);
        for (p = bottom_hole_centers) translate(p) circle(d = hole_diameter);
    }
    registration_marks();
}

// camada engrave: textos, moldura (se border) e marcas de registro
module engrave_layer() {
    title_text();
    subtitle_text();
    if (border) border_frame();
    registration_marks();
}

// ---------- CONFERENCIA (console) ----------
echo("camada =", layer);
echo("largura total da peca (mm) =", width);
echo("altura total da peca (mm) =", height);
echo("largura total do quadro com marcas (mm) =", frame_width);
echo("altura total do quadro com marcas (mm) =", frame_height);
echo("largura livre (mm) =", free_width);
echo("tamanho final linha 1 - titulo (mm) =", title_final_size);
echo("tamanho final linha 2 - subtitulo (mm) =", subtitle_final_size);
echo("base do titulo em Y (mm) =", title_baseline_y);
echo("topo do subtitulo em Y (mm) =", subtitle_top_y);

// ---------- SAIDA ----------
if (layer == "cut") cut_layer();
if (layer == "engrave") engrave_layer();
