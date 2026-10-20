layer = "cut"; // Camada ativa: "cut" para corte ou "engrave" para gravacao
font_name = "Liberation Sans:style=Bold"; // Fonte exigida para gravacao
label_text = "MARIA"; // Texto a ser gravado na peca

piece_width = 70; // Largura total do chaveiro (mm)
piece_height = 25; // Altura total do chaveiro (mm)
corner_radius = 4; // Raio dos cantos arredondados do chaveiro (mm)
material_thickness = 3; // Espessura do material MDF (mm)
clearance = 0; // Folga exclusiva para encaixes (mm, sem encaixes nesta peca)

hole_diameter = 4.5; // Diametro do furo para a argola (mm)
hole_left_margin = 3.5; // Distancia da borda esquerda da peca a borda do furo (mm)

text_margin = 3; // Margem minima do texto para o furo e para as bordas (mm)
max_font_size = 8; // Tamanho maximo permitido para a letra (mm)
num_letters = 5; // Quantidade de letras do nome MARIA

reg_mark_diameter = 0.6; // Diametro dos circulos de registro (mm)
reg_mark_offset = 3; // Distancia dos circulos de registro para fora dos cantos (mm)

fator_dois = 2; // Fator divisor/multiplicador para raios, centros e margens duplas
 $fn = 64; // Resolucao dos arcos e circulos

// =====================================================================
// VARIAVEIS DERIVADAS (CALCULOS GEOMETRICOS)
// =====================================================================

hole_radius = hole_diameter / fator_dois;
hole_center_x = hole_left_margin + hole_radius;
hole_center_y = piece_height / fator_dois;
hole_right_edge = hole_left_margin + hole_diameter;

free_x_start = hole_right_edge + text_margin;
free_width = piece_width - hole_right_edge - (fator_dois * text_margin);
free_height = piece_height - (fator_dois * text_margin);

font_size = min(max_font_size, free_width / num_letters);

text_center_x = free_x_start + (free_width / fator_dois);
text_center_y = piece_height / fator_dois;

// =====================================================================
// SAIDA DE MEDIDAS NO CONSOLE (ECHO)
// =====================================================================

echo(
    largura_final_mm = piece_width,
    altura_final_mm = piece_height,
    raio_canto_mm = corner_radius,
    espessura_mdf_mm = material_thickness,
    clearance_mm = clearance
);
echo(
    diametro_furo_mm = hole_diameter,
    centro_furo_x_mm = hole_center_x,
    centro_furo_y_mm = hole_center_y
);
echo(
    largura_livre_mm = free_width,
    altura_livre_mm = free_height,
    tamanho_letra_mm = font_size
);

// =====================================================================
// MODULOS 2D
// =====================================================================

module registration_marks() {
    translate([-reg_mark_offset, -reg_mark_offset])
        circle(d = reg_mark_diameter);

    translate([piece_width + reg_mark_offset, piece_height + reg_mark_offset])
        circle(d = reg_mark_diameter);
}

module keychain_body() {
    hull() {
        translate([corner_radius, corner_radius])
            circle(r = corner_radius);

        translate([piece_width - corner_radius, corner_radius])
            circle(r = corner_radius);

        translate([corner_radius, piece_height - corner_radius])
            circle(r = corner_radius);

        translate([piece_width - corner_radius, piece_height - corner_radius])
            circle(r = corner_radius);
    }
}

module ring_hole() {
    translate([hole_center_x, hole_center_y])
        circle(d = hole_diameter);
}

module engraved_name() {
    translate([text_center_x, text_center_y])
        text(
            text = label_text,
            size = font_size,
            font = font_name,
            halign = "center",
            valign = "center"
        );
}

// =====================================================================
// GERACAO DAS CAMADAS
// =====================================================================

if (layer == "cut") {
    difference() {
        keychain_body();
        ring_hole();
    }
    registration_marks();
}

if (layer == "engrave") {
    engraved_name();
    registration_marks();
}
