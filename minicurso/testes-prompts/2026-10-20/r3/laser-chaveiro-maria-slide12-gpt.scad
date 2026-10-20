// OpenSCAD 2021.01 — dimensões em milímetros.

// Todos os valores numéricos.
piece_width = 70;          // Largura final da peça.
piece_height = 25;         // Altura final da peça.
corner_radius = 4;         // Raio dos cantos.
hole_diameter = 4.5;       // Diâmetro do furo.
hole_edge_distance = 3.5;  // Distância da borda esquerda à borda do furo.
name_margin = 3;          // Distância mínima do nome ao furo e às bordas.
max_letter_size = 8;       // Tamanho máximo da letra.
material_thickness = 3;   // Espessura do MDF; apenas informativa.
clearance = 0;            // Folga exclusiva para encaixes; não usada nesta peça.
mark_diameter = 0.6;      // Diâmetro das marcas de registro.
mark_distance = 3;        // Deslocamento dos centros para fora de cada canto.
zero = 0;                 // Origem das coordenadas.
two = 2;                  // Divisor para raios e centralização.
$fn = 96;                 // Resolução dos círculos e cantos.

// Seleção da camada e conteúdo.
layer = "cut";            // "cut" ou "engrave".
name_string = "MARIA";
font_name = "Liberation Sans:style=Bold";

// Dimensões calculadas, sem compensação de kerf.
hole_x = hole_edge_distance + hole_diameter / two;
hole_y = piece_height / two;
name_x = hole_x + hole_diameter / two + name_margin;
free_width = piece_width - name_margin - name_x;
letter_size = min(max_letter_size, free_width / len(name_string));

echo("Dimensões finais da peça (mm):",
     piece_width, piece_height);
echo("Raio dos cantos (mm):", corner_radius);
echo("Diâmetro do furo (mm):", hole_diameter);
echo("Centro do furo (mm):", [hole_x, hole_y]);
echo("Espessura do MDF (mm):", material_thickness);
echo("Largura livre para o nome (mm):", free_width);
echo("Tamanho da letra (mm):", letter_size);

module piece_outline() {
    translate([corner_radius, corner_radius])
        offset(r = corner_radius)
            square([
                piece_width - two * corner_radius,
                piece_height - two * corner_radius
            ]);
}

module registration_marks() {
    // Centros deslocados para fora em ambos os eixos.
    translate([-mark_distance, -mark_distance])
        circle(d = mark_diameter);

    translate([
        piece_width + mark_distance,
        piece_height + mark_distance
    ])
        circle(d = mark_diameter);
}

module cut_layer() {
    difference() {
        piece_outline();

        translate([hole_x, hole_y])
            circle(d = hole_diameter);
    }
}

module engrave_layer() {
    translate([name_x, piece_height / two])
        text(
            name_string,
            size = letter_size,
            font = font_name,
            halign = "left",
            valign = "center",
            spacing = two / two
        );
}

if (layer == "cut") {
    cut_layer();
    registration_marks();
} else if (layer == "engrave") {
    engrave_layer();
    registration_marks();
} else {
    echo("Camada inválida: escolha cut ou engrave.");
}
