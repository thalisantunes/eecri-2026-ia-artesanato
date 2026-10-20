// Chaveiro retangular com cantos arredondados, furo para argola e nome gravado
// OpenSCAD 2021.01, sem bibliotecas, unidades em mm, so 2D no topo

// ---------- Parametros ----------
// camada a gerar: cut = corte (contorno e furo), engrave = gravacao (texto)
layer = "cut"; // [cut, engrave]
// true = desenha as marcas de registro nas duas camadas (booleano)
registration = true;

width = 70;          // largura da peca, mm
height = 25;         // altura da peca, mm
corner_radius = 4;   // raio dos cantos arredondados, mm
hole_diameter = 4.5; // diametro do furo da argola, mm
hole_margin = 3.5;   // distancia da borda esquerda da peca ate a borda do furo, mm
label = "MARIA";     // texto gravado (string, sem unidade)
font_size = 8;       // tamanho desejado das letras (size do OpenSCAD), mm
bold = true;         // true = negrito (booleano)
text_margin = 3;     // folga entre o texto e o furo ou a borda direita, mm

reg_diameter = 0.6;  // diametro das marcas de registro, mm
reg_offset = 3;      // distancia das marcas ate o canto da area das pecas, em X e em Y, mm
reg_fn = 16;         // numero de lados das marcas de registro, sem unidade
$fn = 64;            // numero de lados dos circulos e arcos, sem unidade

// ---------- Calculos ----------
font = bold ? "Liberation Sans:style=Bold" : "Liberation Sans"; // fonte do texto (string)

hole_cx = hole_margin + hole_diameter / 2; // centro X do furo, mm
hole_cy = height / 2;                      // centro Y do furo (centralizado na altura), mm

text_x0 = hole_margin + hole_diameter + text_margin; // inicio da area livre do texto, mm
text_x1 = width - text_margin;                       // fim da area livre do texto, mm
text_w = text_x1 - text_x0;                          // largura da area livre do texto, mm
text_cx = text_x0 + text_w / 2;                      // centro X da area do texto, mm
text_size = min(font_size, text_w / len(label));     // tamanho final do texto, mm

reg_r = reg_diameter / 2;                       // raio das marcas de registro, mm
set_width = width + 2 * (reg_offset + reg_r);   // largura do conjunto com marcas, mm
set_height = height + 2 * (reg_offset + reg_r); // altura do conjunto com marcas, mm

// ---------- Conferencia (console) ----------
echo(piece_width = width, piece_height = height);
echo(text_area_width = text_w, text_size = text_size);
echo(set_width = set_width, set_height = set_height);

// ---------- Geometria (so 2D no topo) ----------
// contorno com cantos arredondados (offset, sem minkowski)
module outline() {
    offset(r = corner_radius)
        offset(delta = -corner_radius)
            square([width, height]);
}

// marcas de registro: canto inferior esquerdo e canto superior direito da area das pecas
module registration_marks() {
    translate([-reg_offset, -reg_offset])
        circle(d = reg_diameter, $fn = reg_fn);
    translate([width + reg_offset, height + reg_offset])
        circle(d = reg_diameter, $fn = reg_fn);
}

// camada de corte: contorno MENOS o furo
if (layer == "cut") {
    difference() {
        outline();
        translate([hole_cx, hole_cy])
            circle(d = hole_diameter);
    }
}

// camada de gravacao: so o texto, centralizado na altura e na area livre a direita do furo
if (layer == "engrave") {
    translate([text_cx, hole_cy])
        text(label, size = text_size, font = font, halign = "center", valign = "center");
}

// marcas de registro: fora do if de camada, entao saem nas duas camadas
if (registration) {
    registration_marks();
}
