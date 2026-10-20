// Caixa de MDF com encaixe finger joint - 2D para laser (OpenSCAD 2021.01)

// ===== Parametros (todos os numeros ficam aqui) =====

// Camada exportada: cut = corte (contornos e furos), engrave = gravacao (texto)
layer = "cut"; // [cut, engrave]

// Marcas de registro nas duas camadas: true = desenha, false = omite
registration = true;

// Medidas EXTERNAS da caixa
length = 80;         // comprimento em X (mm)
width = 60;          // largura em Y (mm)
height = 40;         // altura das paredes em Z (mm)

// Material
thickness = 3;       // espessura real do MDF, medida com paquimetro (mm)

// Encaixe finger joint
finger_width = 10;   // largura-alvo de cada dedo (mm)
clearance = 0.1;     // folga total entre dedo e fenda, usada so nos encaixes (mm)

// Tampa e disposicao no desenho
with_lid = true;     // true inclui tampa lisa; false deixa a caixa aberta
spacing = 4;         // espaco entre todas as pecas no desenho (mm)

// Texto gravado no centro da tampa (so vale se with_lid for true)
label = "CAIXA";     // texto gravado
font_size = 8;       // tamanho do texto (mm)
bold = true;         // true = negrito

// Marcas de registro
reg_diameter = 0.6;  // diametro de cada marca de registro (mm)
reg_offset = 3;      // distancia de cada marca ao canto da area das pecas (mm)
reg_fn = 16;         // resolucao dos circulos das marcas (pontos)

// ===== Valores calculados (nao editar) =====

// Fonte do texto
font = bold ? "Liberation Sans:style=Bold" : "Liberation Sans";

// Divisao da altura em dedos
n = 2 * round((height / finger_width - 1) / 2) + 1; // numero de faixas na altura, sempre impar
fh = height / n;                                    // altura nominal de cada faixa (mm)
half_clearance = clearance / 2;                     // metade da folga (mm)
finger_w = fh - half_clearance;                     // largura do dedo (mm)
slot_w = fh + half_clearance;                       // largura da fenda (mm)

// Posicoes no desenho, origem no canto inferior esquerdo da area das pecas
lid_x = length + spacing;                                 // coluna da direita: tampa e parede de tras (mm)
row2_y = width + spacing;                                 // linha das paredes frente e tras (mm)
row3_y = row2_y + height + spacing;                       // linha das paredes laterais (mm)
total_w = max(2 * length + spacing, 2 * width + spacing); // largura total do desenho (mm)
total_h = width + 2 * height + 2 * spacing;               // altura total do desenho (mm)

// ===== Modulos =====

// Base vertical da faixa k (0 = inferior) com altura h_band, centrada na faixa nominal (mm)
function band_bottom(k, h_band) = (2 * k + 1) * fh / 2 - h_band / 2;

// Parede com dedos: corpo central liso e dedos nas duas pontas (largura = thickness).
// fingers_parity = paridade das faixas com material nas pontas (0 = pares, 1 = impares).
module finger_wall(wall_length, fingers_parity) {
    translate([thickness, 0]) square([wall_length - 2 * thickness, height]);
    for (k = [0 : n - 1]) if (k % 2 == fingers_parity) {
        translate([0, band_bottom(k, finger_w)]) square([thickness, finger_w]);
        translate([wall_length - thickness, band_bottom(k, finger_w)]) square([thickness, finger_w]);
    }
}

// ===== Saida 2D (nivel mais alto: so geometria 2D) =====

// Camada cut: fundo, tampa e paredes (contornos e furos)
if (layer == "cut") {
    // Fundo liso, colado por baixo das paredes
    square([length, width]);
    // Tampa lisa (opcional)
    if (with_lid) translate([lid_x, 0]) square([length, width]);
    // Frente e tras (length x height): material nas faixas pares
    translate([0, row2_y]) finger_wall(length, 0);
    translate([lid_x, row2_y]) finger_wall(length, 0);
    // Laterais (width x height): material nas faixas impares
    translate([0, row3_y]) finger_wall(width, 1);
    translate([width + spacing, row3_y]) finger_wall(width, 1);
}

// Camada engrave: so o texto no centro da tampa
if (layer == "engrave" && with_lid) {
    translate([lid_x + length / 2, width / 2])
        text(label, size = font_size, font = font, halign = "center", valign = "center");
}

// Marcas de registro: iguais nas duas camadas, mesmo quadro
if (registration) {
    translate([-reg_offset, -reg_offset]) circle(d = reg_diameter, $fn = reg_fn);
    translate([total_w + reg_offset, total_h + reg_offset]) circle(d = reg_diameter, $fn = reg_fn);
}

// Conferencia no console (mm)
echo(n = n, finger_w = finger_w, slot_w = slot_w, clearance = clearance);
echo(total_w = total_w, total_h = total_h, box_length = length, box_width = width, box_height = height);
