// OpenSCAD 2021.01 — dimensões em milímetros.
layer = "cut";                          // "cut" ou "engrave"
piece_width = 70;                        // Largura final
piece_height = 25;                       // Altura final
corner_radius = 4;                       // Raio dos cantos
hole_diameter = 4.5;                     // Diâmetro do furo
hole_edge_distance = 3.5;                // Distância da borda esquerda ao furo
minimum_margin = 3;                     // Margem mínima do nome
maximum_font_size = 8;                  // Tamanho máximo da letra
material_thickness = 3;                 // MDF; informação de fabricação
clearance = 0;                          // Folga exclusiva de encaixes; não utilizada
registration_diameter = 0.6;            // Diâmetro das marcas de registro
registration_offset = 3;                // Deslocamento externo em cada eixo
curve_segments = 96;                    // Resolução das curvas
zero = 0;                              // Origem das coordenadas
two = 2;                               // Divisor para centros e diâmetros

name = "MARIA";
font_name = "Liberation Sans:style=Bold";

$fn = curve_segments;

hole_radius = hole_diameter / two;
hole_x = hole_edge_distance + hole_radius;
hole_y = piece_height / two;

name_x = hole_x + hole_radius + minimum_margin;
free_width = piece_width - minimum_margin - name_x;
font_size = min(maximum_font_size, free_width / len(name));

echo("Dimensões finais da peça (mm):",
     piece_width, piece_height);
echo("Raio dos cantos (mm):", corner_radius);
echo("Diâmetro do furo (mm):", hole_diameter);
echo("Centro do furo (mm):", [hole_x, hole_y]);
echo("Espessura do MDF (mm):", material_thickness);
echo("Largura livre para o nome (mm):", free_width);
echo("Tamanho da letra (mm):", font_size);

module piece_outline() {
    translate([corner_radius, corner_radius])
        offset(r = corner_radius)
            square([
                piece_width - two * corner_radius,
                piece_height - two * corner_radius
            ]);
}

module registration_marks() {
    translate([-registration_offset, -registration_offset])
        circle(d = registration_diameter);

    translate([
        piece_width + registration_offset,
        piece_height + registration_offset
    ])
        circle(d = registration_diameter);
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
            name,
            size = font_size,
            font = font_name,
            halign = "left",
            valign = "center"
        );
}

assert(
    layer == "cut" || layer == "engrave",
    "layer deve ser \"cut\" ou \"engrave\"."
);

if (layer == "cut") {
    cut_layer();
    registration_marks();
} else if (layer == "engrave") {
    engrave_layer();
    registration_marks();
}
