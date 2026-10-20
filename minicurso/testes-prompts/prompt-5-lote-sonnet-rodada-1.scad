// Lote de chaveiros com nomes - corte e gravacao a laser.
// OpenSCAD 2021.01 | unidades em mm | topo do arquivo somente em 2D.
// Exportar duas vezes: layer = "cut" e layer = "engrave" (as duas saem com o mesmo quadro).
// Origem: canto inferior esquerdo do lote em (0, 0), eixo y para cima.
// Sem compensacao de kerf e sem folga: nao ha encaixes, entao nao ha clearance.

// ---------------------------------------------------------------
// Parametros
// ---------------------------------------------------------------

// camada a exportar: cut = contornos e furos, engrave = nomes (sem unidade)
layer = "cut"; // [cut, engrave]
registration = true; // desenha as 2 marcas de registro nas duas camadas (sem unidade)

labels = ["ANA", "BRUNO", "CARLA", "DANIEL", "ELISA", "FELIPE", "GABRIELA", "HUGO"]; // um nome por chaveiro, do canto superior esquerdo em diante (texto)
columns = 2;  // quantos chaveiros por linha (chaveiros)
tag_gap = 3;  // espaco entre chaveiros, na horizontal e na vertical (mm)

tag_width = 70;       // largura do chaveiro (mm)
tag_height = 25;      // altura do chaveiro (mm)
corner_radius = 4;    // raio dos cantos arredondados (mm)
hole_diameter = 4.5;  // diametro do furo (mm)
hole_margin = 3.5;    // distancia da borda esquerda ate a borda do furo (mm)

font_size = 8;           // tamanho maximo do texto (mm)
bold = true;             // true = negrito, false = normal (sem unidade)
text_margin = 3;         // folga entre furo e texto e entre texto e borda direita (mm)
char_width_ratio = 0.9;  // largura estimada de um caractere, em fracao do tamanho do texto (sem unidade)

registration_diameter = 0.6;  // diametro de cada marca de registro (mm)
registration_distance = 3;    // distancia das marcas ao canto do lote, em x e em y (mm)
registration_fn = 16;         // numero de segmentos da marca de registro (sem unidade)

$fn = 64;  // numero de segmentos dos demais circulos e arcos (sem unidade)

font = bold ? "Liberation Sans:style=Bold" : "Liberation Sans";  // fonte do texto, derivada de bold (nome da fonte)

/* [Hidden] */

// valores calculados a partir dos parametros (nao editar)
tag_count = len(labels);                                                 // quantidade de chaveiros (chaveiros)
used_columns = min(columns, tag_count);                                  // colunas ocupadas na primeira linha (colunas)
rows = ceil(tag_count / columns);                                        // linhas da grade (linhas)
batch_width = used_columns * tag_width + (used_columns - 1) * tag_gap;   // largura do lote de chaveiros (mm)
batch_height = rows * tag_height + (rows - 1) * tag_gap;                 // altura do lote de chaveiros (mm)
text_x = hole_margin + hole_diameter + text_margin;                      // inicio do texto, medido da borda esquerda (mm)
text_area_width = tag_width - text_x - text_margin;                      // largura da area livre para o texto (mm)
frame_width = registration ? batch_width + 2 * registration_distance + registration_diameter : batch_width;     // largura total do arquivo, com as marcas (mm)
frame_height = registration ? batch_height + 2 * registration_distance + registration_diameter : batch_height;  // altura total do arquivo, com as marcas (mm)

// ---------------------------------------------------------------
// Funcoes
// ---------------------------------------------------------------

// posicao (canto inferior esquerdo) do chaveiro i na grade; o indice 0 fica no canto superior esquerdo
function pos(i) = [
    (i % columns) * (tag_width + tag_gap),
    (rows - 1 - floor(i / columns)) * (tag_height + tag_gap)
];

// tamanho do texto de um nome: reduz se o nome for longo, para caber na area livre
function fit_size(name) = min(font_size, text_area_width / (len(name) * char_width_ratio));

// ---------------------------------------------------------------
// Modulos
// ---------------------------------------------------------------

// UM chaveiro: contorno com cantos arredondados (offset) menos o furo; canto inferior esquerdo na origem
module tag_shape() {
    difference() {
        translate([corner_radius, corner_radius])
            offset(r = corner_radius)
                square([tag_width - 2 * corner_radius, tag_height - 2 * corner_radius]);
        translate([hole_margin + hole_diameter / 2, tag_height / 2])
            circle(d = hole_diameter);
    }
}

// texto de UM nome: comeca em text_x, alinhado a esquerda e centrado na altura do chaveiro
module tag_label(name) {
    translate([text_x, tag_height / 2])
        text(name, size = fit_size(name), font = font, halign = "left", valign = "center");
}

// marcas de registro: uma vez so, nos cantos do lote inteiro (nao em cada chaveiro)
module registration_marks() {
    translate([-registration_distance, -registration_distance])
        circle(d = registration_diameter, $fn = registration_fn);
    translate([batch_width + registration_distance, batch_height + registration_distance])
        circle(d = registration_diameter, $fn = registration_fn);
}

// ---------------------------------------------------------------
// Conferencia no console
// ---------------------------------------------------------------

echo(layer = layer, tag_count = tag_count, columns = used_columns, rows = rows);
echo(batch_width_mm = batch_width, batch_height_mm = batch_height);
echo(frame_width_mm = frame_width, frame_height_mm = frame_height);
echo(text_area_width_mm = text_area_width);
for (i = [0 : tag_count - 1])
    echo(label = labels[i], text_size_mm = fit_size(labels[i]));

// ---------------------------------------------------------------
// Saida 2D
// ---------------------------------------------------------------

for (i = [0 : tag_count - 1])
    translate(pos(i)) {
        if (layer == "cut") tag_shape();
        if (layer == "engrave") tag_label(labels[i]);
    }

if (registration) registration_marks();
