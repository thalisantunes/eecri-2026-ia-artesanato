// --- Parametros numericos (todos em milimetros) ---
$fn = 64; // Resolucao das curvas em segmentos
width = 70; // Largura total do chaveiro em mm
height = 25; // Altura total do chaveiro em mm
material_thickness = 3; // Espessura do material MDF em mm
corner_radius = 4; // Raio dos cantos arredondados em mm
hole_diam = 4.5; // Diametro do furo para a argola em mm
hole_margin_left = 3.5; // Distancia da borda do furo a borda esquerda em mm
text_margin = 3; // Margem minima do texto ao furo e as bordas em mm
max_font_size = 8; // Tamanho maximo permitido para a letra em mm
reg_diam = 0.6; // Diametro dos circulos de alinhamento nos cantos em mm
reg_offset = 3; // Distancia dos circulos de alinhamento para fora da peca em mm
clearance = 0; // Folga exclusiva para encaixes em mm
half = 2; // Divisor para calculo de metade e centralizacao

// --- Configuracao de camada e texto ---
layer = "cut"; // Selecao de camada: "cut" para corte ou "engrave" para gravacao
label_text = "MARIA"; // Nome a ser gravado no chaveiro
font_name = "Liberation Sans:style=Bold"; // Fonte configurada para a gravacao

// --- Calculos geometricos e de posicionamento ---
hole_radius = hole_diam / half; // Raio do furo da argola em mm
hole_x = hole_margin_left + hole_radius; // Coordenada X do centro do furo em mm
hole_y = height / half; // Coordenada Y do centro do furo em mm

text_start_x = hole_margin_left + hole_diam + text_margin; // Limite esquerdo da area do texto em mm
text_end_x = width - text_margin; // Limite direito da area do texto em mm
free_width = text_end_x - text_start_x; // Largura livre disponivel para o nome em mm
num_letters = len(label_text); // Numero de letras do nome
font_size = min(max_font_size, free_width / num_letters); // Tamanho final calculado para a letra em mm
text_x = text_start_x + (free_width / half); // Coordenada X central da area livre do texto em mm
text_y = height / half; // Coordenada Y central do texto em mm

reg_min_x = -reg_offset; // Coordenada X do circulo inferior esquerdo em mm
reg_min_y = -reg_offset; // Coordenada Y do circulo inferior esquerdo em mm
reg_max_x = width + reg_offset; // Coordenada X do circulo superior direito em mm
reg_max_y = height + reg_offset; // Coordenada Y do circulo superior direito em mm

// --- Exibicao das medidas finais ---
echo(largura_final = width, altura_final = height, espessura_mdf = material_thickness);
echo(raio_canto = corner_radius, diametro_furo = hole_diam, centro_furo_x = hole_x, centro_furo_y = hole_y);
echo(largura_livre = free_width, tamanho_letra = font_size);

// --- Modulos 2D ---
module registration_marks() {
    translate([reg_min_x, reg_min_y])
        circle(d = reg_diam);
    translate([reg_max_x, reg_max_y])
        circle(d = reg_diam);
}

module keychain_body() {
    hull() {
        translate([corner_radius, corner_radius])
            circle(r = corner_radius);
        translate([width - corner_radius, corner_radius])
            circle(r = corner_radius);
        translate([width - corner_radius, height - corner_radius])
            circle(r = corner_radius);
        translate([corner_radius, height - corner_radius])
            circle(r = corner_radius);
    }
}

// --- Geracao da camada selecionada ---
if (layer == "cut") {
    difference() {
        keychain_body();
        translate([hole_x, hole_y])
            circle(d = hole_diam);
    }
    registration_marks();
} else if (layer == "engrave") {
    translate([text_x, text_y])
        text(
            text = label_text,
            size = font_size,
            font = font_name,
            halign = "center",
            valign = "center"
        );
    registration_marks();
}
