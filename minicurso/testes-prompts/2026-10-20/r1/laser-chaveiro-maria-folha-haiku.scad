// ===== Parâmetros (mm) =====
layer = "cut";              // "cut" = contorno com furo; "engrave" = só o texto
W = 70;                     // largura da peça
H = 25;                     // altura da peça
R = 4;                      // raio dos cantos
hole_d = 4.5;               // diâmetro do furo da argola
hole_edge = 3.5;            // distância da borda esquerda até a borda esquerda do furo
text_gap = 3;               // distância mínima do texto ao furo e às bordas
text_str = "MARIA";         // nome gravado
text_size = 11;             // tamanho do texto (diminua se o nome for comprido)
font = "Liberation Sans:style=Bold";
mark_d = 0.6;               // diâmetro dos círculos de referência
mark_off = 3;               // distância dos círculos de referência aos cantos
clearance = 0;              // folga: só para encaixes; não usada neste chaveiro
$fn = 64;                   // resolução dos arcos

// ===== Derivados =====
hole_x = hole_edge + hole_d / 2;          // 5.75
hole_y = H / 2;                           // 12.5
hole_right = hole_x + hole_d / 2;         // 8
text_x = hole_right + text_gap;           // 11
text_y = H / 2;                           // 12.5
text_max_x = W - text_gap;                // 67

// ===== Módulos 2D =====
module outline() {
    hull() {
        for (x = [R, W - R], y = [R, H - R])
            translate([x, y]) circle(r = R);
    }
}

module marks() {
    translate([-mark_off, -mark_off]) circle(d = mark_d);
    translate([W + mark_off, H + mark_off]) circle(d = mark_d);
}

module cut_layer() {
    union() {
        difference() {
            outline();
            translate([hole_x, hole_y]) circle(d = hole_d);
        }
        marks();
    }
}

module engrave_layer() {
    union() {
        translate([text_x, text_y])
            text(text_str, size = text_size, font = font,
                 halign = "left", valign = "center");
        marks();
    }
}

// ===== Saída =====
if (layer == "cut") cut_layer();
else if (layer == "engrave") engrave_layer();

// ===== Medidas finais =====
echo("Peca (W x H, raio):", W, H, R);
echo("Furo: centro x, y:", hole_x, hole_y, "diametro:", hole_d);
echo("Furo: borda esquerda x:", hole_x - hole_d / 2, "borda direita x:", hole_right);
echo("Texto: inicio x:", text_x, "folga furo-texto:", text_x - hole_right);
echo("Texto: limite direito x:", text_max_x, "tamanho:", text_size);
echo("Marcadores: centros:", [-mark_off, -mark_off], [W + mark_off, H + mark_off], "diametro:", mark_d);
echo("Camada ativa:", layer);
