// Lote de chaveiros com nomes: corte e gravacao numa mesma chapa
// OpenSCAD 2021.01, so linguagem basica, sem bibliotecas, tudo em mm

// ---------- Parametros ----------
// camada exportada: cut (corte) ou engrave (gravacao), texto
layer = "cut"; // [cut, engrave]
// marcas de registro: true ou false, booleano
registration = true;
// nomes dos chaveiros, um por chaveiro, lista de textos
labels = ["ANA", "BRUNO", "CARLA", "DANIEL", "ELISA", "FELIPE", "GABRIELA", "HUGO"];
// chaveiros por linha, quantidade
columns = 2;
// espaco entre chaveiros, em X e em Y, mm
tag_gap = 3;
// largura de um chaveiro, mm
tag_width = 70;
// altura de um chaveiro, mm
tag_height = 25;
// raio dos cantos do chaveiro, mm
corner_radius = 4;
// diametro do furo, mm
hole_diameter = 4.5;
// distancia da borda esquerda do chaveiro ate a borda esquerda do furo, mm
hole_margin = 3.5;
// tamanho das letras (size do OpenSCAD), mm
font_size = 8;
// negrito: true ou false, booleano
bold = true;
// folga do texto ate o furo e ate a borda direita, mm
text_margin = 3;
// diametro das marcas de registro, mm
registration_diameter = 0.6;
// distancia das marcas de registro aos cantos do lote, em X e em Y, mm
registration_offset = 3;
// segmentos dos circulos de registro, quantidade
registration_fn = 16;
// segmentos dos demais circulos, quantidade
$fn = 64;

// ---------- Calculos derivados (nao sao parametros) ----------
font = bold ? "Liberation Sans:style=Bold" : "Liberation Sans";
count = len(labels);
used_columns = min(columns, count);
rows = ceil(count / columns);
center_y = tag_height / 2;
hole_x = hole_margin + hole_diameter / 2;
text_x = hole_margin + hole_diameter + text_margin;
text_right = tag_width - text_margin;
text_area_width = text_right - text_x;
batch_width = used_columns * tag_width + (used_columns - 1) * tag_gap;
batch_height = rows * tag_height + (rows - 1) * tag_gap;

// ---------- Funcoes ----------
// posicao (canto inferior esquerdo) do chaveiro i; i = 0 e o canto superior esquerdo
function pos(i) = [
    (i % columns) * (tag_width + tag_gap),
    (rows - 1 - floor(i / columns)) * (tag_height + tag_gap)
];

// tamanho do texto de um nome: reduz so se o nome for longo
function label_size(name) = min(font_size, text_area_width / len(name));

// ---------- Modules ----------
// contorno de UM chaveiro, com o furo subtraido (camada cut)
// o offset so arredonda os cantos; nao compensa kerf
module keychain() {
    difference() {
        offset(r = corner_radius)
            offset(delta = -corner_radius)
                square([tag_width, tag_height]);
        translate([hole_x, center_y])
            circle(d = hole_diameter);
    }
}

// texto de UM nome, na area livre a direita do furo (camada engrave)
module name_text(name) {
    translate([text_x, center_y])
        text(name, size = label_size(name), font = font, halign = "left", valign = "center");
}

// marcas de registro: uma no canto inferior esquerdo do lote e outra no canto superior direito
module registration_marks() {
    translate([-registration_offset, -registration_offset])
        circle(d = registration_diameter, $fn = registration_fn);
    translate([batch_width + registration_offset, batch_height + registration_offset])
        circle(d = registration_diameter, $fn = registration_fn);
}

// ---------- Geracao (so 2D no nivel mais alto) ----------
if (layer == "cut") {
    for (i = [0 : count - 1])
        translate(pos(i)) keychain();
}

if (layer == "engrave") {
    for (i = [0 : count - 1])
        translate(pos(i)) name_text(labels[i]);
}

if (registration) {
    registration_marks();
}

// ---------- Conferencia (console) ----------
echo("lote de chaveiros", count = count, rows = rows, columns = used_columns);
echo("largura e altura do lote, mm", width = batch_width, height = batch_height);
echo("area livre do texto, mm", width = text_area_width);
for (n = labels)
    echo("nome", name = n, size = label_size(n));
