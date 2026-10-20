// Chaveiro retangular com furo para argola e nome gravado (OpenSCAD 2021.01)
// Exportar duas vezes: layer = "cut" (contorno e furo) e layer = "engrave" (nome gravado).
// Origem: canto inferior esquerdo da peca em (0, 0). Unidade: milimetros.
// Marcas de registro: saem nas duas camadas, uma em (-reg_offset, -reg_offset) e outra em
// (width + reg_offset, height + reg_offset), medidas a partir dos cantos da area ocupada pela peca.

// ===================== PARAMETROS =====================

// camada exportada: cut = contorno e furo, engrave = nome gravado (sem unidade)
layer = "cut"; // [cut, engrave]
registration = true; // marcas de registro nas duas camadas: true = desenha (sem unidade)

width = 70; // largura da peca (mm)
height = 25; // altura da peca (mm)
corner_radius = 4; // raio dos cantos arredondados (mm)

hole_diameter = 4.5; // diametro do furo da argola (mm)
hole_margin = 3.5; // distancia da borda esquerda da peca ate a borda do furo (mm)

label = "MARIA"; // texto gravado (sem unidade)
font_size = 8; // altura desejada das letras (mm)
bold = true; // true = negrito, false = normal (sem unidade)
text_margin = 3; // folga entre o texto e as bordas ou o furo (mm)
char_width_ratio = 0.9; // largura media estimada de cada letra, como fracao do tamanho (sem unidade)

reg_diameter = 0.6; // diametro de cada marca de registro (mm)
reg_offset = 3; // afastamento das marcas, em x e em y, a partir dos cantos da area ocupada (mm)
reg_fn = 16; // valor de $fn das marcas de registro (sem unidade)

$fn = 64; // numero de segmentos dos circulos: furo e cantos arredondados (sem unidade)

// ===================== VALORES DERIVADOS (nao editar) =====================

font = bold ? "Liberation Sans:style=Bold" : "Liberation Sans";

center_y = height / 2; // altura do centro da peca (mm)
hole_cx = hole_margin + hole_diameter / 2; // x do centro do furo (mm)
text_x0 = hole_margin + hole_diameter + text_margin; // x onde comeca a area livre do texto (mm)
text_w = width - text_margin - text_x0; // largura da area livre do texto (mm)
text_cx = text_x0 + text_w / 2; // x do centro da area livre do texto (mm)
// atencao: char_width_ratio e so uma estimativa; letras largas (M, W) em nomes longos podem passar de text_w
final_text_size = min(font_size, text_w / (len(label) * char_width_ratio)); // tamanho final do texto (mm)
frame_w = registration ? width + 2 * reg_offset + reg_diameter : width; // largura total do arquivo exportado (mm)
frame_h = registration ? height + 2 * reg_offset + reg_diameter : height; // altura total do arquivo exportado (mm)

// ===================== VERIFICACOES E CONFERENCIA =====================

assert(layer == "cut" || layer == "engrave", "layer deve ser cut ou engrave");
assert(2 * corner_radius < min(width, height), "corner_radius deve ser menor que metade da menor dimensao da peca");
assert(text_w > 0, "sem area livre para o texto: reduza hole_margin, hole_diameter ou text_margin, ou aumente width");
assert(final_text_size <= height - 2 * text_margin, "texto alto demais: reduza font_size ou text_margin, ou aumente height");

echo(str("Camada exportada: ", layer));
echo(str("Peca: largura = ", width, " mm, altura = ", height, " mm"));
echo(str("Furo: centro em x = ", hole_cx, " mm, y = ", center_y, " mm, diametro = ", hole_diameter, " mm"));
echo(str("Area do texto: comeca em x = ", text_x0, " mm, text_w = ", text_w, " mm, centro em x = ", text_cx, " mm"));
echo(str("Texto: tamanho final = ", final_text_size, " mm (pedido = ", font_size, " mm), largura estimada = ", len(label) * char_width_ratio * final_text_size, " mm"));
echo(str("Marcas de registro em (", -reg_offset, ", ", -reg_offset, ") e (", width + reg_offset, ", ", height + reg_offset, ") mm"));
echo(str("Arquivo exportado: ", frame_w, " x ", frame_h, " mm (inclui as marcas se registration = true)"));

// ===================== GEOMETRIA (somente 2D) =====================

// contorno retangular com cantos arredondados, feito com offset
module outline() {
    offset(r = corner_radius)
        translate([corner_radius, corner_radius])
            square([width - 2 * corner_radius, height - 2 * corner_radius]);
}

// camada de corte: contorno menos o furo da argola
module cut_layer() {
    difference() {
        outline();
        translate([hole_cx, center_y])
            circle(d = hole_diameter);
    }
}

// camada de gravacao: so o texto, centralizado na altura e na area livre a direita do furo
module engrave_layer() {
    translate([text_cx, center_y])
        text(label, size = final_text_size, font = font, halign = "center", valign = "center");
}

// duas marcas de registro, iguais nas duas camadas
module registration_marks() {
    translate([-reg_offset, -reg_offset])
        circle(d = reg_diameter, $fn = reg_fn);
    translate([width + reg_offset, height + reg_offset])
        circle(d = reg_diameter, $fn = reg_fn);
}

// ===================== SAIDA =====================

if (layer == "cut") cut_layer();
if (layer == "engrave") engrave_layer();
if (registration) registration_marks();
