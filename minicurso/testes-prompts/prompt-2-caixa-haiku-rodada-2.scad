// Caixa de MDF com encaixe finger joint para corte e gravacao a laser
// OpenSCAD 2021.01 - so geometria 2D no topo - unidades em mm

// Camada exportada: cut = contornos de corte; engrave = gravacao (texto)
layer = "cut"; // [cut, engrave]

// Marcas de registro nas duas camadas
registration = true; // true = com marcas de registro; false = sem marcas

// Dimensoes externas da caixa
length = 80; // comprimento externo da caixa (eixo X), mm
width = 60; // largura externa da caixa (eixo Y), mm
height = 40; // altura externa das paredes, mm

// Material e encaixes
thickness = 3; // espessura real do MDF (medir com paquimetro), mm
finger_width = 8; // largura-alvo de cada dedo, mm
clearance = 0.1; // folga total entre dedo e fenda, mm
with_lid = true; // true = inclui tampa lisa; false = caixa aberta
spacing = 4; // espaco entre as pecas no desenho, mm

// Texto gravado no centro da tampa
label = "CAIXA"; // texto da tampa (so vale se with_lid for true)
font_size = 8; // tamanho das letras (size do OpenSCAD), mm
bold = true; // true = negrito (Liberation Sans Bold); false = normal

// Constantes de desenho
circle_fn = 64; // numero de segmentos dos circulos (sem unidade)
reg_diameter = 0.6; // diametro das marcas de registro, mm
reg_fn = 16; // numero de segmentos das marcas de registro (sem unidade)
reg_offset = 3; // distancia das marcas ao canto da area das pecas, mm

$fn = circle_fn;

// Calculados a partir dos parametros acima (nao editar)
font = bold ? "Liberation Sans:style=Bold" : "Liberation Sans"; // fonte do texto
n = 2 * round((height / finger_width - 1) / 2) + 1; // numero impar de dedos na altura (sem unidade)
fh = height / n; // largura nominal de cada faixa, mm
half_clearance = clearance / 2; // metade da folga, mm
quarter_clearance = half_clearance / 2; // um quarto da folga (recuo de cada lado da faixa), mm
finger_h = fh - half_clearance; // largura do dedo, mm
slot_h = fh + half_clearance; // largura da fenda, mm

// Posicoes das pecas no desenho (origem no canto inferior esquerdo)
lid_x = length + spacing; // posicao X da tampa, mm
back_x = length + spacing; // posicao X do fundo de tras, mm
row2_y = width + spacing; // posicao Y da segunda linha (frente e tras), mm
row3_y = row2_y + height + spacing; // posicao Y da terceira linha (laterais), mm
right_x = width + spacing; // posicao X da lateral direita, mm
lid_cx = lid_x + length / 2; // centro X da tampa, mm
lid_cy = width / 2; // centro Y da tampa, mm

// Area ocupada pelas pecas (a mesma nas duas camadas)
parts_w = max(2 * length + spacing, 2 * width + spacing); // largura total das pecas, mm
parts_h = row3_y + height; // altura total das pecas, mm
mark1_x = -reg_offset; // centro X da marca inferior esquerda, mm
mark1_y = -reg_offset; // centro Y da marca inferior esquerda, mm
mark2_x = parts_w + reg_offset; // centro X da marca superior direita, mm
mark2_y = parts_h + reg_offset; // centro Y da marca superior direita, mm

// Parede com dedos nas duas pontas
// wall_length = comprimento da parede, mm
// is_side = true para lateral (faixas pares vazadas); false para frente/tras (faixas impares vazadas)
module wall(wall_length, is_side) {
    first_slot = is_side ? 0 : 1; // primeira faixa vazada (sem unidade)
    difference() {
        square([wall_length, height]);
        for (k = [first_slot : 2 : n - 1]) {
            // fenda da faixa k na ponta esquerda (profundidade = thickness)
            translate([-thickness, k * fh - quarter_clearance])
                square([2 * thickness, slot_h]);
            // fenda da faixa k na ponta direita (profundidade = thickness)
            translate([wall_length - thickness, k * fh - quarter_clearance])
                square([2 * thickness, slot_h]);
        }
    }
}

// Conferencia no console (aparece nas duas exportacoes)
echo("camada exportada =", layer);
echo("n (dedos na altura) =", n);
echo("largura do dedo (mm) =", finger_h);
echo("largura da fenda (mm) =", slot_h);
echo("folga (mm) =", slot_h - finger_h);
echo("largura total das pecas (mm) =", parts_w);
echo("altura total das pecas (mm) =", parts_h);
if (registration) {
    echo("com marcas, largura (mm) =", parts_w + 2 * reg_offset + reg_diameter);
    echo("com marcas, altura (mm) =", parts_h + 2 * reg_offset + reg_diameter);
}

// Camada cut: contornos de corte de todas as pecas
if (layer == "cut") {
    // fundo liso (colado por baixo das paredes)
    square([length, width]);
    // tampa lisa (so se with_lid for true)
    if (with_lid) translate([lid_x, 0]) square([length, width]);
    // frente e tras (comprimento x altura), com dedos nos cantos
    translate([0, row2_y]) wall(length, false);
    translate([back_x, row2_y]) wall(length, false);
    // laterais (largura x altura), com dedos nos cantos
    translate([0, row3_y]) wall(width, true);
    translate([right_x, row3_y]) wall(width, true);
}

// Camada engrave: so o texto no centro da tampa (se with_lid for true)
if (layer == "engrave" && with_lid) {
    translate([lid_cx, lid_cy])
        text(label, size = font_size, font = font, halign = "center", valign = "center");
}

// Marcas de registro: iguais nas duas camadas
if (registration) {
    translate([mark1_x, mark1_y]) circle(d = reg_diameter, $fn = reg_fn);
    translate([mark2_x, mark2_y]) circle(d = reg_diameter, $fn = reg_fn);
}
