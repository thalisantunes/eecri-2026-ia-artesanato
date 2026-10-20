// Caixa de MDF com encaixes tipo finger joint e tampa lisa opcional.
// Saida somente plana (bidimensional), em milimetros. Exportar duas vezes: layer = "cut" e layer = "engrave".
// Origem do desenho: canto inferior esquerdo da area ocupada pelas pecas.
// Disposicao, de cima para baixo: fundo e tampa; frente e tras; as duas laterais.
// Premissas: as marcas de registro ficam a reg_offset em X e em Y do canto da area ocupada
// (medido ate o centro do circulo); as bordas externas das pecas nao mudam com a folga,
// entao os dedos das pontas (frente e tras) ficam um pouco mais largos que o nominal.

/* [Camadas e marcas de registro] */

// camada exportada: cut = contornos e furos, engrave = texto gravado (sem unidade)
layer = "cut"; // [cut, engrave]
registration = true; // desenha as duas marcas de registro nas duas camadas (sem unidade; true ou false)
reg_diameter = 0.6;  // diametro de cada marca de registro (mm)
reg_offset = 3;      // distancia da marca ao canto da area das pecas, em X e em Y (mm)
reg_fn = 16;         // valor de $fn dos circulos da marca de registro (sem unidade)
$fn = 64;            // segmentos dos demais circulos (sem unidade)

/* [Caixa] */

length = 80;     // comprimento externo da caixa, em X (mm)
width = 60;      // largura externa da caixa, em Y (mm)
height = 40;     // altura externa das paredes (mm)
thickness = 3;   // espessura real do MDF, medida com paquimetro (mm)
with_lid = true; // true inclui a tampa lisa; false deixa a caixa aberta (sem unidade)
spacing = 4;     // espaco entre as pecas no desenho (mm)

/* [Encaixes] */

finger_width = 10; // largura-alvo de cada dedo (mm)
clearance = 0.1;   // folga total entre dedo e fenda, so na largura ao longo da altura (mm)

/* [Texto] */

label = "CAIXA"; // texto gravado no centro da tampa, so vale se with_lid for true (sem unidade)
font_size = 8;   // tamanho do texto (mm)
bold = true;     // true = negrito, false = normal (sem unidade)

/* [Hidden] */

// ---- valores derivados (nao editar) ----

font = bold ? "Liberation Sans:style=Bold" : "Liberation Sans"; // fonte do texto (sem unidade)

// encaixes: faixas numeradas de baixo para cima a partir de zero
n = 2 * round((height / finger_width - 1) / 2) + 1; // numero de dedos ao longo da altura, sempre impar (sem unidade)
fh = height / n;                // largura nominal de cada faixa (mm)
finger_w = fh - clearance / 2;  // largura do dedo (mm)
slot_w = fh + clearance / 2;    // largura da fenda (mm)
slot_extra = (slot_w - fh) / 2; // quanto a fenda passa da faixa, de cada lado (mm)

// disposicao das pecas
first_row_w = with_lid ? 2 * length + spacing : length; // largura da primeira linha: fundo e tampa (mm)
second_row_w = 2 * length + spacing;                    // largura da segunda linha: frente e tras (mm)
third_row_w = 2 * width + spacing;                      // largura da terceira linha: duas laterais (mm)
total_w = max(first_row_w, second_row_w, third_row_w);  // largura total do desenho (mm)
third_row_y = 0;                                        // posicao Y da terceira linha, base do desenho (mm)
second_row_y = third_row_y + height + spacing;          // posicao Y da segunda linha (mm)
first_row_y = second_row_y + height + spacing;          // posicao Y da primeira linha, topo do desenho (mm)
total_h = first_row_y + width;                          // altura total do desenho (mm)
lid_x = length + spacing;                               // posicao X da tampa (mm)

// texto e conferencias
text_cx = lid_x + length / 2;      // centro da tampa em X (mm)
text_cy = first_row_y + width / 2; // centro da tampa em Y (mm)
text_fits = len(label) * font_size <= length - 2 * thickness
            && font_size <= width - 2 * thickness; // estimativa aproximada (cada caractere ocupa cerca de font_size) de que o texto cabe na area interna da tampa (sem unidade)
frame_w = registration ? total_w + 2 * reg_offset + reg_diameter : total_w; // largura do quadro, com as marcas (mm)
frame_h = registration ? total_h + 2 * reg_offset + reg_diameter : total_h; // altura do quadro, com as marcas (mm)
piece_count = 1 + 2 + 2 + (with_lid ? 1 : 0); // quantidade de pecas no corte (sem unidade)

// ---- conferencia no console ----
echo(str("n = ", n, " dedos; faixa fh = ", fh, " mm; largura do dedo = ", finger_w, " mm; largura da fenda = ", slot_w, " mm; folga = ", clearance, " mm"));
echo(str("pecas = ", piece_count, "; fundo e tampa = ", length, " x ", width, " mm; frente e tras = ", length, " x ", height, " mm; laterais = ", width, " x ", height, " mm"));
echo(str("desenho total = ", total_w, " x ", total_h, " mm; com marcas de registro = ", frame_w, " x ", frame_h, " mm"));
echo(str("interno da caixa = ", length - 2 * thickness, " x ", width - 2 * thickness, " x ", height, " mm; externo montado = ", length, " x ", width, " x ", height + thickness + (with_lid ? thickness : 0), " mm"));
if (layer != "cut" && layer != "engrave") echo("AVISO: layer deve ser cut ou engrave");
if (2 * thickness >= min(length, width)) echo("AVISO: thickness grande demais para length e width");
if (with_lid && !text_fits) echo("AVISO: o texto pode nao caber na area interna da tampa; reduza font_size ou encurte label");

// ---- modulos ----

// Parede com zona de encaixe nas duas pontas; wall_len e o comprimento da peca (mm).
// void_parity: um para frente e tras (fendas nas faixas impares), zero para as laterais (fendas nas faixas pares).
// A fenda e centrada na faixa e fica mais larga que ela; a profundidade da fenda (thickness)
// e as bordas externas da peca nao mudam.
module wall(wall_len, void_parity) {
    difference() {
        square([wall_len, height]);
        for (i = [0 : n - 1]) {
            if (i % 2 == void_parity) {
                translate([-thickness, i * fh - slot_extra]) square([2 * thickness, slot_w]);
                translate([wall_len - thickness, i * fh - slot_extra]) square([2 * thickness, slot_w]);
            }
        }
    }
}

// Duas marcas de registro: uma abaixo e a esquerda, outra acima e a direita da area das pecas.
module registration_marks() {
    translate([-reg_offset, -reg_offset]) circle(d = reg_diameter, $fn = reg_fn);
    translate([total_w + reg_offset, total_h + reg_offset]) circle(d = reg_diameter, $fn = reg_fn);
}

// Camada de corte: todos os contornos da caixa.
module cut_layer() {
    // primeira linha: fundo liso e tampa lisa
    translate([0, first_row_y]) square([length, width]);
    if (with_lid) translate([lid_x, first_row_y]) square([length, width]);
    // segunda linha: frente e tras (comprimento x altura)
    translate([0, second_row_y]) wall(length, 1);
    translate([length + spacing, second_row_y]) wall(length, 1);
    // terceira linha: as duas laterais (largura x altura)
    translate([0, third_row_y]) wall(width, 0);
    translate([width + spacing, third_row_y]) wall(width, 0);
}

// Camada de gravacao: so o texto no centro da tampa.
module engrave_layer() {
    if (with_lid)
        translate([text_cx, text_cy])
            text(label, size = font_size, font = font, halign = "center", valign = "center");
}

// ---- saida plana: a camada escolhida e as marcas de registro ----
if (layer == "cut") cut_layer();
if (layer == "engrave") engrave_layer();
if (registration) registration_marks();
