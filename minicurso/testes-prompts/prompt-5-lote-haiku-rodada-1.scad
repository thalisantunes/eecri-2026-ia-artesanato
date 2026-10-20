// Lote de chaveiros com nomes - corte e gravacao a laser (OpenSCAD 2021.01)
// Unidades: tudo em mm

// ---------- PARAMETROS ----------

// camada exportada: cut = corte (contornos e furos), engrave = gravacao (nomes)
layer = "cut"; // [cut, engrave]

// marcas de registro nas duas camadas: true liga, false desliga
registration = true;

// nomes dos chaveiros, um por chaveiro (texto)
labels = ["ANA", "BRUNO", "CARLA", "DANIEL", "ELISA", "FELIPE", "GABRIELA", "HUGO"];

// quantidade de chaveiros por linha (un)
columns = 2;

// espaco entre chaveiros, na horizontal e na vertical (mm)
tag_gap = 3;

// largura do chaveiro (mm)
tag_width = 70;

// altura do chaveiro (mm)
tag_height = 25;

// raio dos cantos arredondados (mm)
corner_radius = 4;

// diametro do furo (mm)
hole_diameter = 4.5;

// distancia da borda esquerda do chaveiro ate a borda esquerda do furo (mm)
hole_margin = 3.5;

// tamanho maximo do texto (mm)
font_size = 8;

// negrito: true ou false
bold = true;

// fonte: Liberation Sans, em negrito quando bold for true
font = bold ? "Liberation Sans:style=Bold" : "Liberation Sans";

// espaco entre o furo e o texto, e entre o texto e a borda direita (mm)
text_margin = 3;

// largura media por caractere, em multiplos do tamanho do texto (adimensional)
char_width_factor = 0.9;

// lados dos circulos e dos cantos arredondados (un)
circle_fn = 64;

// diametro das marcas de registro (mm)
reg_diameter = 0.6;

// lados dos circulos das marcas de registro (un)
reg_fn = 16;

// distancia de cada marca de registro ate o canto do lote (mm)
reg_offset = 3;

// ---------- CALCULOS DERIVADOS ----------

// colunas realmente usadas (un)
used_columns = min(columns, len(labels));

// linhas da grade (un)
grid_rows = ceil(len(labels) / columns);

// inicio do texto, medido a partir da borda esquerda do chaveiro (mm)
text_start_x = hole_margin + hole_diameter + text_margin;

// largura da area livre do texto, do inicio ate a margem direita (mm)
text_area_width = tag_width - text_margin - text_start_x;

// largura total do lote (mm)
batch_width = used_columns * tag_width + (used_columns - 1) * tag_gap;

// altura total do lote (mm)
batch_height = grid_rows * tag_height + (grid_rows - 1) * tag_gap;

// centro da marca de registro inferior esquerda (mm)
reg_bl = [-reg_offset, -reg_offset];

// centro da marca de registro superior direita (mm)
reg_tr = [batch_width + reg_offset, batch_height + reg_offset];

// canto inferior esquerdo do chaveiro i na grade (mm); i = 0 fica no canto superior esquerdo
function pos(i) = [
    (i % columns) * (tag_width + tag_gap),
    (grid_rows - 1 - floor(i / columns)) * (tag_height + tag_gap)
];

// tamanho do texto de um nome: diminui se o nome for longo (mm)
function name_size(name) =
    min(font_size, text_area_width / (len(name) * char_width_factor));

// ---------- MODULOS ----------

// um chaveiro: contorno arredondado menos o furo (cortado)
module tag() {
    difference() {
        translate([corner_radius, corner_radius])
            offset(r = corner_radius, $fn = circle_fn)
                square([tag_width - 2 * corner_radius, tag_height - 2 * corner_radius]);
        translate([hole_margin + hole_diameter / 2, tag_height / 2])
            circle(d = hole_diameter, $fn = circle_fn);
    }
}

// texto de um nome: na area livre a direita do furo, centralizado na altura (gravado)
module tag_text(name) {
    translate([text_start_x, tag_height / 2])
        text(name, size = name_size(name), font = font, halign = "left", valign = "center");
}

// ---------- SAIDA ----------

// conferencia no console
echo("Camada:", layer, "| marcas de registro:", registration);
echo("Chaveiros:", len(labels), "| linhas:", grid_rows, "| colunas:", used_columns);
echo("Lote largura (mm):", batch_width, "| altura (mm):", batch_height);
echo("Area livre do texto (mm):", text_area_width);
for (i = [0 : len(labels) - 1])
    echo("Nome:", labels[i], "| tamanho do texto (mm):", name_size(labels[i]));

// chaveiros da camada escolhida
if (layer == "cut") {
    for (i = [0 : len(labels) - 1])
        translate(pos(i)) tag();
} else if (layer == "engrave") {
    for (i = [0 : len(labels) - 1])
        translate(pos(i)) tag_text(labels[i]);
}

// marcas de registro: uma vez no lote, aparecem nas duas camadas
if (registration) {
    translate(reg_bl) circle(d = reg_diameter, $fn = reg_fn);
    translate(reg_tr) circle(d = reg_diameter, $fn = reg_fn);
}
