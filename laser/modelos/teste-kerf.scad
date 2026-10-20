// =====================================================================
// teste-kerf.scad
// Pente de ranhuras e quadrado de 20 mm para medir o kerf da sua laser,
// no seu material. Unidades em milímetros. OpenSCAD 2021.01.
//
// O QUE É
//   kerf = largura do corte. A laser queima uma faixa de material em
//   volta da linha desenhada: as peças saem menores e os furos maiores
//   do que o desenho. Este teste mede essa largura.
//   Corte com o offset de kerf do software ZERADO. A geometria aqui é
//   exata, sem nenhuma compensação.
//
//   1. Quadrado: lado desenhado de 20 mm. Meça o lado por fora (X e Y).
//        kerf = 20 - medido
//   2. Dentes do pente (conferência; o quadrado já basta): largura desenhada =
//      tooth_width. Meça por fora só os dentes ao lado das ranhuras de 2,0 mm
//      ou mais (do 3º ao 6º, contando da esquerda).
//        kerf = tooth_width - medido
//   3. Ranhuras: largura nominal escrita embaixo de cada uma.
//        kerf = largura medida - nominal
//      Ranhuras estreitas não aceitam as pontas internas do paquímetro:
//      use lâminas de calibre, brocas ou pedaços de chapa de espessura
//      conhecida e veja qual ranhura aceita cada um.
//   O pente também serve de gabarito de encaixe: troque slot_widths por
//   valores em volta da espessura da chapa e veja qual ranhura segura a
//   chapa com leve pressão.
//
// PARÂMETROS (mude aqui no topo ou com -D na linha de comando)
//   slot_widths   larguras nominais das ranhuras, em mm
//   tooth_width   largura dos dentes entre as ranhuras e nas pontas, em mm
//   slot_depth    profundidade das ranhuras, em mm
//   base_height   faixa inteira embaixo das ranhuras, onde ficam os números
//   square_size   lado do quadrado de medida, em mm
//   square_gap    distância entre o pente e o quadrado, em mm
//   label_size    tamanho do texto, em mm
//   note          texto livre gravado abaixo do pente (ex.: "MDF 3 mm 70%")
//   layer         "cut" = contornos; "engrave" = números
//   registration  true = desenha duas marcas de registro (círculos de 0,6 mm)
//                 idênticas nas duas camadas, a 3 mm da peça. Servem para alinhar
//                 as camadas à mão se o software importar cada arquivo por conta
//                 própria. Padrão: false
//
// COMO EXPORTAR (um SVG por camada)
//   openscad -D 'layer="cut"'     -o teste-kerf-cut.svg     teste-kerf.scad
//   openscad -D 'layer="engrave"' -o teste-kerf-engrave.svg teste-kerf.scad
//
// EXEMPLO (ajuste de encaixe para chapa de 3 mm medida com paquímetro)
//   -D 'slot_widths=[2.8,2.9,3.0,3.1,3.2]'
// =====================================================================

/* [Pente] */
// Larguras nominais das ranhuras, em mm
slot_widths = [1.0, 1.5, 2.0, 2.5, 3.0];
// Largura dos dentes entre as ranhuras e nas pontas, em mm
tooth_width = 6;
// Profundidade das ranhuras, em mm
slot_depth = 15;
// Faixa inteira embaixo das ranhuras, onde ficam os números, em mm
base_height = 10;

/* [Quadrado] */
// Lado do quadrado de medida, em mm
square_size = 20;
// Distância entre o pente e o quadrado, em mm
square_gap = 10;

/* [Texto] */
// Tamanho do texto, em mm
label_size = 3;
// Texto livre gravado abaixo do pente
note = "";

/* [Camada] */
// cut = contornos; engrave = números
layer = "cut"; // [cut, engrave]
// Duas marcas de registro idênticas nas duas camadas, fora da peça
registration = false;

/* [Hidden] */
n_slots  = len(slot_widths);
cap      = 0.9555 * label_size;
comb_h   = base_height + slot_depth;

function sum_to(v, n, i = 0) = (i >= n) ? 0 : v[i] + sum_to(v, n, i + 1);
function pad2(n) = n < 10 ? str("0", n) : str(n);
// Número com vírgula decimal, sempre com ao menos 1 casa (1,0 / 2,5 / 2,95)
function fmt1(x) =
    let(c = round(abs(x) * 100), s = x < 0 ? "-" : "",
        ip = floor(c / 100), fp = c % 100)
    fp % 10 == 0 ? str(s, ip, ",", fp / 10) : str(s, ip, ",", pad2(fp));

comb_w = sum_to(slot_widths, n_slots) + (n_slots + 1) * tooth_width;
// caixa que contém pente, quadrado, números e nota (marcas de registro)
reg_x0 = 0;
reg_x1 = max(comb_w + square_gap + square_size, len(note) * 1.1 * label_size);
reg_y0 = -(2 + cap + 0.3 * label_size);
reg_y1 = max(comb_h, square_size);

// posição X da borda esquerda da ranhura i
function slot_x(i) = tooth_width + sum_to(slot_widths, i) + i * tooth_width;

// Marcas de registro: dois círculos de 0,6 mm, iguais nas duas camadas, nos cantos
// opostos da caixa (x0, y0, x1, y1) que contém toda a geometria, a `gap` mm de
// distância. As duas camadas passam a ter a mesma caixa, então o software as
// posiciona igual, e as marcas servem para conferir ou alinhar à mão.
module registration_marks(x0, y0, x1, y1, gap = 3) {
    for (p = [[x0 - gap, y0 - gap], [x1 + gap, y1 + gap]])
        translate(p) circle(d = 0.6, $fn = 16);
}

module label(txt, x, y, ha = "center", size = label_size) {
    translate([x, y - 0.9555 * size / 2])
        text(txt, size = size, font = "Liberation Sans:style=Bold",
             halign = ha, valign = "baseline", $fn = 24);
}

module cut_layer() {
    // pente: bloco com ranhuras abertas para cima
    difference() {
        square([comb_w, comb_h]);
        for (i = [0 : n_slots - 1])
            translate([slot_x(i), base_height]) square([slot_widths[i], slot_depth + 1]);
    }
    // quadrado de medida
    translate([comb_w + square_gap, 0]) square(square_size);
}

module engrave_layer() {
    for (i = [0 : n_slots - 1])
        label(fmt1(slot_widths[i]), slot_x(i) + slot_widths[i] / 2, base_height / 2);
    // o número fica no quadrado: ele cai da chapa, então o rótulo vai junto com ele
    label(str(square_size), comb_w + square_gap + square_size / 2, square_size / 2,
          "center", min(8, square_size / 3));
    if (len(note) > 0)
        label(note, 0, -2 - cap / 2, "left");
}

assert(layer == "cut" || layer == "engrave", "layer deve ser \"cut\" ou \"engrave\"");
assert(n_slots > 0, "slot_widths precisa ter pelo menos um valor");

if (layer == "cut") cut_layer();
else engrave_layer();
if (registration) registration_marks(reg_x0, reg_y0, reg_x1, reg_y1);
