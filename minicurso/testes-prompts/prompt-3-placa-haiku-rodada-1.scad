// Placa retangular de cantos arredondados, com furos e texto gravado
// OpenSCAD 2021.01: so linguagem basica, sem bibliotecas, tudo em mm

// ---- Parametros ----
width = 120;                       // largura da placa, mm
height = 50;                       // altura da placa, mm
corner_radius = 3;                 // raio dos cantos arredondados, mm
margin = 6;                        // margem entre os textos e a borda, mm
holes = 2;                         // [0, 2, 4] quantidade de furos: 0 = nenhum, 2 = dois cantos de cima, 4 = quatro cantos
hole_diameter = 4;                 // diametro dos furos, mm
hole_margin = 4;                   // distancia da borda da placa ate a borda do furo, mm
title = "CASA DA ANA";             // primeira linha de texto
title_size = 9;                    // altura desejada das letras do titulo, mm
subtitle = "Artesanato em couro";  // segunda linha de texto
subtitle_size = 5.5;               // altura desejada das letras do subtitulo, mm
line_gap = 5;                      // espaco entre as duas linhas de texto, mm
char_width_ratio = 0.9;            // largura media de um caractere em multiplos do tamanho, sem unidade
bold = true;                       // negrito na fonte: true = sim, false = nao
border = false;                    // moldura gravada: true = liga, false = desliga
border_width = 0.8;                // largura do filete da moldura, mm
border_inset = 3.5;                // distancia da borda da placa ate o filete, mm
layer = "cut";                     // [cut, engrave] camada: cut = corte, engrave = gravacao
registration = true;               // marcas de registro nas duas camadas: true = desenha
reg_diameter = 0.6;                // diametro das marcas de registro, mm
reg_offset = 3;                    // distancia das marcas ao canto da placa em X e em Y, mm
reg_fn = 16;                       // lados dos circulos das marcas de registro, sem unidade
$fn = 64;                          // lados dos circulos e dos arcos, sem unidade

// ---- Valores derivados (nao editar) ----
font_name = bold ? "Liberation Sans:style=Bold" : "Liberation Sans";
free_width = width - 2 * margin;   // largura livre para cada linha, mm
title_fit_size = free_width / (len(title) * char_width_ratio);
subtitle_fit_size = free_width / (len(subtitle) * char_width_ratio);
title_final_size = min(title_size, title_fit_size);
subtitle_final_size = min(subtitle_size, subtitle_fit_size);
hole_radius = hole_diameter / 2;
hole_left_x = hole_margin + hole_radius;
hole_right_x = width - hole_margin - hole_radius;
hole_bottom_y = hole_margin + hole_radius;
hole_top_y = height - hole_margin - hole_radius;
reg_extra = reg_offset + reg_diameter / 2;   // quanto o quadro com as marcas passa da placa em cada lado, mm
frame_width = width + (registration ? 2 * reg_extra : 0);
frame_height = height + (registration ? 2 * reg_extra : 0);

// ---- Geometria 2D ----
module rounded_plate() {
    translate([corner_radius, corner_radius])
        offset(r = corner_radius)
            square([width - 2 * corner_radius, height - 2 * corner_radius]);
}

module hole_at(x, y) {
    translate([x, y]) circle(d = hole_diameter);
}

module holes_2d() {
    if (holes > 0) {
        hole_at(hole_left_x, hole_top_y);
        hole_at(hole_right_x, hole_top_y);
    }
    if (holes > 2) {
        hole_at(hole_left_x, hole_bottom_y);
        hole_at(hole_right_x, hole_bottom_y);
    }
}

module registration_marks() {
    translate([-reg_offset, -reg_offset])
        circle(d = reg_diameter, $fn = reg_fn);
    translate([width + reg_offset, height + reg_offset])
        circle(d = reg_diameter, $fn = reg_fn);
}

module border_frame() {
    inner_inset = border_inset + border_width;
    difference() {
        translate([border_inset, border_inset])
            square([width - 2 * border_inset, height - 2 * border_inset]);
        translate([inner_inset, inner_inset])
            square([width - 2 * inner_inset, height - 2 * inner_inset]);
    }
}

module title_text() {
    translate([width / 2, height / 2 + line_gap / 2])
        text(title, size = title_final_size, font = font_name,
             halign = "center", valign = "bottom");
}

module subtitle_text() {
    translate([width / 2, height / 2 - line_gap / 2])
        text(subtitle, size = subtitle_final_size, font = font_name,
             halign = "center", valign = "top");
}

module cut_geometry() {
    difference() {
        rounded_plate();
        holes_2d();
    }
}

module engrave_geometry() {
    title_text();
    subtitle_text();
    if (border) border_frame();
}

// ---- Saida: so 2D no nivel mais alto ----
if (registration) registration_marks();
if (layer == "cut") cut_geometry();
if (layer == "engrave") engrave_geometry();

// ---- Conferencia no console ----
echo("camada", layer);
echo("placa largura x altura, mm", width, height);
echo("quadro com marcas largura x altura, mm", frame_width, frame_height);
echo("largura livre, mm", free_width);
echo("titulo: tamanho limite pela largura", title_fit_size, "tamanho final", title_final_size);
echo("subtitulo: tamanho limite pela largura", subtitle_fit_size, "tamanho final", subtitle_final_size);
echo("furos", holes, "X esquerda e direita, mm", hole_left_x, hole_right_x);
