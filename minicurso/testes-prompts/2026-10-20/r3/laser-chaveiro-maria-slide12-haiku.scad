// ===== Parametros (mm, salvo indicacao) =====
layer = "cut";            // "cut" = so contornos e furos; "engrave" = so texto gravado
$fn = 96;                 // resolucao dos arcos e circulos (adimensional)

// Peca
PIECE_W = 70;             // largura da peca (mm)
PIECE_H = 25;             // altura da peca (mm)
CORNER_R = 4;             // raio dos cantos (mm)

// Furo da argola
HOLE_D = 4.5;             // diametro do furo (mm)
HOLE_EDGE = 3.5;          // distancia da borda esquerda da peca ate a borda do furo (mm)

// Nome gravado
NAME = "MARIA";           // texto a gravar
FONT = "Liberation Sans:style=Bold";
TEXT_MAX_SIZE = 8;        // tamanho maximo da letra (mm)
GAP_HOLE = 3;             // distancia minima entre o furo e o texto (mm)
GAP_EDGE = 3;             // distancia minima entre o texto e as bordas (mm)

// Marcas de referencia
MARK_D = 0.6;             // diametro dos circulos de referencia (mm)
MARK_OFFSET = 3;          // deslocamento do centro de cada circulo em relacao ao canto (mm)

// Folga de encaixe (so para encaixes; esta peca nao tem encaixe)
clearance = 0;            // mm

// ===== Derivados (calculados a partir dos parametros) =====
hole_cx = HOLE_EDGE + HOLE_D / 2;                      // centro do furo em X (mm) = 5.75
hole_cy = PIECE_H / 2;                                 // centro do furo em Y (mm) = 12.5
hole_right = HOLE_EDGE + HOLE_D;                       // borda direita do furo (mm) = 8
name_x0 = hole_right + GAP_HOLE;                       // inicio da area do texto (mm) = 11
name_x1 = PIECE_W - GAP_EDGE;                          // fim da area do texto (mm) = 67
free_w = name_x1 - name_x0;                            // largura livre para o nome (mm) = 56
letter_size = min(TEXT_MAX_SIZE, free_w / len(NAME)); // tamanho da letra (mm) = 8

// ===== Medidas finais =====
echo("Peca (mm)", PIECE_W, PIECE_H);
echo("Furo centro X, Y e diametro (mm)", hole_cx, hole_cy, HOLE_D);
echo("Largura livre para o nome (mm)", free_w);
echo("Tamanho da letra (mm)", letter_size);
echo("Area do texto X0 e X1 (mm)", name_x0, name_x1);

// ===== Modulos 2D =====
module outline() {
    // retangulo 70 x 25 com cantos arredondados r = 4
    offset(r = CORNER_R)
        translate([CORNER_R, CORNER_R])
            square([PIECE_W - 2 * CORNER_R, PIECE_H - 2 * CORNER_R]);
}

module marks() {
    // circulo de referencia no canto inferior esquerdo (fora da peca)
    translate([-MARK_OFFSET, -MARK_OFFSET])
        circle(d = MARK_D);
    // circulo de referencia no canto superior direito (fora da peca)
    translate([PIECE_W + MARK_OFFSET, PIECE_H + MARK_OFFSET])
        circle(d = MARK_D);
}

module keychain_cut() {
    difference() {
        outline();
        translate([hole_cx, hole_cy])
            circle(d = HOLE_D);
    }
}

module name_engrave() {
    translate([name_x0, PIECE_H / 2])
        text(NAME, size = letter_size, font = FONT,
             halign = "left", valign = "center");
}

// ===== Saida por camada =====
if (layer == "cut") {
    union() {
        keychain_cut();
        marks();
    }
} else if (layer == "engrave") {
    union() {
        name_engrave();
        marks();
    }
} else {
    echo("layer invalido: use \"cut\" ou \"engrave\"");
}
