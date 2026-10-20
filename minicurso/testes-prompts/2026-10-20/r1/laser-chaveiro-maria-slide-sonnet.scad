// ===== Chaveiro MARIA - MDF 3 mm - laser =====
// Todas as medidas em milimetros. OpenSCAD 2021.01, so 2D, sem bibliotecas.

layer = "cut";            // "cut" = contornos e furos; "engrave" = texto gravado

part_w = 70;              // largura da peca
part_h = 25;              // altura da peca
corner_r = 4;             // raio dos cantos arredondados
hole_d = 4.5;             // diametro do furo da argola
hole_x = 6;               // centro do furo, distancia da borda esquerda
hole_y = 12.5;            // centro do furo, distancia da borda inferior (centralizado)
name = "MARIA";           // texto gravado
font = "Liberation Sans:style=Bold"; // fonte do texto
text_size = 10;           // altura nominal do texto
text_x = 39;              // centro horizontal do texto (area livre de 11 a 67)
text_y = 12.5;            // centro vertical do texto
mark_d = 0.6;             // diametro das marcas de registro
mark_offset = 3;          // distancia das marcas para fora dos cantos
clearance = 0;            // folga de encaixe (sem encaixes nesta peca; nao compensa kerf)
fn = 96;                  // resolucao dos circulos

module outline() {
    hull() {
        for (x = [corner_r, part_w - corner_r], y = [corner_r, part_h - corner_r])
            translate([x, y]) circle(r = corner_r, $fn = fn);
    }
}

module marks() {
    translate([-mark_offset, -mark_offset]) circle(d = mark_d, $fn = 32);
    translate([part_w + mark_offset, part_h + mark_offset]) circle(d = mark_d, $fn = 32);
}

module cut_layer() {
    difference() {
        outline();
        translate([hole_x, hole_y]) circle(d = hole_d, $fn = fn);
    }
}

module engrave_layer() {
    translate([text_x, text_y])
        text(name, size = text_size, font = font, halign = "center", valign = "center");
}

if (layer == "cut") {
    cut_layer();
    marks();
} else if (layer == "engrave") {
    engrave_layer();
    marks();
}

echo(layer = layer);
echo(peca_mm = [part_w, part_h], raio_canto = corner_r);
echo(furo_diametro = hole_d, furo_centro = [hole_x, hole_y], parede_furo_borda = hole_x - hole_d / 2);
echo(texto = name, tamanho = text_size, centro = [text_x, text_y]);
echo(marca_inferior_esquerda = [-mark_offset, -mark_offset], marca_superior_direita = [part_w + mark_offset, part_h + mark_offset], marca_diametro = mark_d);
echo(area_total_com_marcas = [part_w + 2 * mark_offset, part_h + 2 * mark_offset]);
