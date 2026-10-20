// OpenSCAD 2021.01 — medidas em milímetros.
// Números e parâmetros concentrados no início.
width = 70;              // Largura final da peça.
height = 25;             // Altura final da peça.
corner_radius = 3;       // Raio dos cantos arredondados.
hole_diameter = 4.5;     // Diâmetro do furo da argola.
hole_x = 7;              // Centro do furo, medido da borda esquerda.
material_thickness = 3;  // Espessura informativa do MDF.
name_size = 9;           // Tamanho nominal do texto gravado.
name_x = 40;             // Centro horizontal do nome.
mark_diameter = 0.6;     // Diâmetro dos círculos de registro.
mark_offset = 3;         // Deslocamento externo em cada eixo.
clearance = 0;           // Reservada para encaixes; não utilizada.
zero = 0;                // Origem das coordenadas.
two = 2;                 // Divisor para calcular centros.
facets = 96;             // Resolução dos círculos.

layer = "cut";           // "cut" ou "engrave".
name = "MARIA";          // Nome gravado.
font_name = "Liberation Sans:style=Bold";

$fn = facets;

echo("Peça final, largura x altura (mm):", width, height);
echo("Raio dos cantos (mm):", corner_radius);
echo("Furo da argola, diâmetro (mm):", hole_diameter);
echo("Centro do furo (mm):", [hole_x, height / two]);
echo("Material: MDF; espessura (mm):", material_thickness);
echo("Registro, diâmetro (mm):", mark_diameter);
echo("Centros dos registros (mm):",
     [-mark_offset, -mark_offset],
     [width + mark_offset, height + mark_offset]);
echo("Camada:", layer);

// Contorno com dimensões externas exatas, sem compensação de kerf.
module rounded_outline() {
    hull() {
        for (x = [corner_radius, width - corner_radius])
            for (y = [corner_radius, height - corner_radius])
                translate([x, y])
                    circle(r = corner_radius);
    }
}

// Centros externos aos cantos da caixa envolvente,
// deslocados 3 mm em X e 3 mm em Y.
module registration_marks() {
    translate([-mark_offset, -mark_offset])
        circle(d = mark_diameter);

    translate([width + mark_offset, height + mark_offset])
        circle(d = mark_diameter);
}

module cut_geometry() {
    difference() {
        rounded_outline();
        translate([hole_x, height / two])
            circle(d = hole_diameter);
    }
}

module engraving() {
    translate([name_x, height / two])
        text(
            name,
            size = name_size,
            font = font_name,
            halign = "center",
            valign = "center"
        );
}

if (layer == "cut") {
    union() {
        cut_geometry();
        registration_marks();
    }
} else if (layer == "engrave") {
    union() {
        engraving();
        registration_marks();
    }
} else {
    echo("ERRO: layer deve ser \"cut\" ou \"engrave\".");
}
