// OpenSCAD 2021.01 — medidas em milímetros.

// Parâmetros numéricos
key_width = 70;          // Largura de cada chaveiro.
key_height = 25;         // Altura de cada chaveiro.
hole_diameter = 4.5;     // Diâmetro do furo.
hole_edge_margin = 3.5;  // Distância entre o furo e a borda esquerda.
name_margin = 3;         // Distância mínima do nome ao furo e às bordas.
max_font_size = 8;       // Tamanho máximo da letra.
columns = 2;            // Número de colunas.
gap = 3;                // Espaçamento horizontal e vertical entre peças.
mark_diameter = 0.6;     // Diâmetro das marcas de registro.
mark_offset = 3;        // Deslocamento das marcas em cada eixo, fora do lote.
clearance = 0;          // Folga apenas para encaixes; não há encaixes nesta peça.
facets = 96;            // Resolução dos círculos.
zero = 0;               // Constante para coordenadas e índices.
one = 1;                // Constante para contagem e intervalos.
two = 2;                // Constante para metades e diâmetros.

// Seleção da camada e conteúdo
layer = "cut";          // "cut": contornos e furos; "engrave": nomes.
font_name = "Liberation Sans:style=Bold";
names = ["ANA", "JOÃO", "CONCEIÇÃO", "PEDRO"];

$fn = facets;

// Dimensões calculadas, sem compensação de kerf
count = len(names);
rows = ceil(count / columns);

batch_width = columns * key_width + (columns - one) * gap;
batch_height = rows * key_height + (rows - one) * gap;

hole_radius = hole_diameter / two;
hole_x = hole_edge_margin + hole_radius;
hole_y = key_height / two;

name_left = hole_x + hole_radius + name_margin;
name_right = key_width - name_margin;
name_width = name_right - name_left;
name_x = (name_left + name_right) / two;
name_y = key_height / two;

function font_size(name) =
    min(max_font_size, name_width / len(name));

function piece_x(index) =
    (index % columns) * (key_width + gap);

function piece_y(index) =
    floor(index / columns) * (key_height + gap);

module key_cut() {
    difference() {
        square([key_width, key_height]);
        translate([hole_x, hole_y])
            circle(d = hole_diameter);
    }
}

module key_engrave(name) {
    translate([name_x, name_y])
        text(
            text = name,
            size = font_size(name),
            font = font_name,
            halign = "center",
            valign = "center"
        );
}

module registration_marks() {
    translate([-mark_offset, -mark_offset])
        circle(d = mark_diameter);

    translate([
        batch_width + mark_offset,
        batch_height + mark_offset
    ])
        circle(d = mark_diameter);
}

// Medidas finais
echo(quantidade_chaveiros = count);
echo(chaveiro_mm = [key_width, key_height]);
echo(diametro_furo_mm = hole_diameter);
echo(largura_livre_nome_mm = name_width);
echo(lote_sem_marcas_mm = [batch_width, batch_height]);
echo(lote_incluindo_marcas_mm = [
    batch_width + two * mark_offset + mark_diameter,
    batch_height + two * mark_offset + mark_diameter
]);

for (i = [zero : count - one]) {
    echo(
        nome = names[i],
        quantidade_letras = len(names[i]),
        tamanho_letra_mm = font_size(names[i])
    );
}

// Geometria exclusivamente 2D
if (layer == "cut" || layer == "engrave") {
    for (i = [zero : count - one]) {
        translate([piece_x(i), piece_y(i)]) {
            if (layer == "cut")
                key_cut();
            else
                key_engrave(names[i]);
        }
    }

    // Um único par de marcas por camada, nos cantos do lote.
    registration_marks();
}
