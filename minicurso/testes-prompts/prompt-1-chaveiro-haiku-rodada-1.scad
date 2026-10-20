// Chaveiro retangular com furo para argola e nome gravado - MDF 3 mm
// Peca plana. Todas as medidas em mm.

// Camada a gerar: "cut" = corte (contorno e furo), "engrave" = gravacao (texto)
layer = "cut"; // [cut, engrave]

// Marcas de registro nas duas camadas (true/false, sem unidade)
registration = true;

// Peca
width = 70;              // largura da peca, mm
height = 25;             // altura da peca, mm
corner_radius = 4;       // raio dos cantos arredondados, mm

// Furo da argola
hole_diameter = 4.5;     // diametro do furo da argola, mm
hole_margin = 3.5;       // distancia da borda esquerda da peca ate a borda esquerda do furo, mm

// Texto gravado
label = "MARIA";         // texto gravado (texto, sem unidade)
font_size = 8;           // altura desejada das letras, mm
bold = true;             // negrito (true/false, sem unidade)
text_margin = 3;         // folga entre o texto e as bordas ou o furo, mm
char_width_factor = 0.9; // largura media de cada letra em relacao ao tamanho (sem unidade)

// Marcas de registro
reg_diameter = 0.6;      // diametro das marcas de registro, mm
reg_offset = 3;          // distancia das marcas aos cantos da area das pecas, mm
reg_fn = 16;             // numero de lados das marcas de registro (sem unidade)

// Suavidade das curvas
circle_fn = 64;          // numero de lados de circulos e arcos (sem unidade)
$fn = circle_fn;

// Fonte (negrito quando bold for true)
font = bold ? "Liberation Sans:style=Bold" : "Liberation Sans";

// ---- Calculos derivados ----

// Furo centralizado na altura
hole_cx = hole_margin + hole_diameter / 2; // centro X do furo, mm
hole_cy = height / 2;                      // centro Y do furo, mm

// Area livre a direita do furo, onde o texto entra
text_x0 = hole_margin + hole_diameter + text_margin; // inicio da area de texto, mm
text_x1 = width - text_margin;                       // fim da area de texto, mm
text_w = text_x1 - text_x0;                          // largura da area de texto, mm
text_cx = (text_x0 + text_x1) / 2;                   // centro X da area de texto, mm
text_cy = height / 2;                                // centro Y do texto, mm

// Tamanho final do texto: reduz se o nome for longo
text_size = min(font_size, text_w / (len(label) * char_width_factor)); // tamanho final, mm
text_est_w = len(label) * char_width_factor * text_size;               // largura estimada do texto, mm

// Tamanho do quadro com as marcas (para conferir o conjunto)
frame_w = registration ? width + 2 * reg_offset + reg_diameter : width;  // largura do quadro, mm
frame_h = registration ? height + 2 * reg_offset + reg_diameter : height; // altura do quadro, mm

// ---- Modulos ----

// Retangulo com cantos arredondados (offset, sem minkowski)
module rounded_rect(w, h, radius) {
    offset(r = radius) translate([radius, radius]) square([w - 2 * radius, h - 2 * radius]);
}

// Marca de registro de diametro reg_diameter, centro em (x, y)
module reg_mark(x, y) {
    translate([x, y]) circle(d = reg_diameter, $fn = reg_fn);
}

// Duas marcas: uma 3 mm abaixo e a esquerda do canto inferior esquerdo, outra 3 mm acima e a direita do canto superior direito
module marks() {
    if (registration) {
        reg_mark(-reg_offset, -reg_offset);
        reg_mark(width + reg_offset, height + reg_offset);
    }
}

// ---- Geometria de topo (apenas 2D) ----

if (layer == "cut") {
    // contorno com cantos arredondados menos o furo da argola
    difference() {
        rounded_rect(width, height, corner_radius);
        translate([hole_cx, hole_cy]) circle(d = hole_diameter);
    }
    marks();
} else if (layer == "engrave") {
    // nome centralizado na area livre a direita do furo
    translate([text_cx, text_cy]) text(label, size = text_size, font = font, halign = "center", valign = "center");
    marks();
}

// ---- Conferencia no console ----
echo("camada", layer);
echo("peca largura (mm)", width);
echo("peca altura (mm)", height);
echo("quadro com marcas largura (mm)", frame_w);
echo("quadro com marcas altura (mm)", frame_h);
echo("furo centro X (mm)", hole_cx, "furo centro Y (mm)", hole_cy);
echo("area do texto text_w (mm)", text_w);
echo("tamanho final do texto (mm)", text_size);
echo("largura estimada do texto (mm)", text_est_w);
