// =====================================================================
// teste-potencia-velocidade.scad
// Grade de quadrados para achar a combinação de potência x velocidade
// que corta (ou grava) o seu material. Unidades em milímetros.
// OpenSCAD 2021.01.
//
// O QUE É
//   Uma grade de quadrados de corte. Cada coluna é uma velocidade e cada
//   linha é uma potência: a velocidade aumenta para a direita e a
//   potência aumenta para cima. No software da laser, cada quadrado vai
//   para uma camada própria, com a velocidade e a potência do seu rótulo.
//   Os rótulos (números) são gravados ao lado da grade, na camada engrave.
//   Depois do corte, o quadrado que cai ou solta com um toque cortou.
//   A grade 5 x 5 usa 25 camadas. Se o software tiver menos, reduza as
//   listas (por exemplo 4 x 4, ou uma linha só).
//
// PARÂMETROS (mude aqui no topo ou com -D na linha de comando)
//   speeds       lista de velocidades das colunas, em mm/s
//   powers       lista de potências das linhas, em %
//   square_size  lado de cada quadrado, em mm
//   gap          espaço entre quadrados, em mm
//   label_size   tamanho do texto dos rótulos, em mm
//   label_gap    distância entre a grade e os rótulos, em mm
//   note         texto livre gravado abaixo da grade (ex.: "MDF 3 mm")
//   layer        "cut" = quadrados; "engrave" = rótulos e nota
//   registration true = desenha duas marcas de registro (círculos de 0,6 mm)
//                idênticas nas duas camadas, a 3 mm da peça. Servem para alinhar
//                as camadas à mão se o software importar cada arquivo por conta
//                própria. Padrão: false
//
// COMO EXPORTAR (um SVG por camada)
//   openscad -D 'layer="cut"'     -o teste-pv-cut.svg     teste-potencia-velocidade.scad
//   openscad -D 'layer="engrave"' -o teste-pv-engrave.svg teste-potencia-velocidade.scad
//
// EXEMPLOS
//   Varredura rápida de velocidade em uma potência só (1 linha, 5 camadas):
//     -D 'powers=[80]'
//   Rodada 2, grade fina em volta do ponto que cortou:
//     -D 'speeds=[16,18,20,22,24]' -D 'powers=[60,65,70,75,80]'
//   Identificar o cartão de teste:
//     -D 'note="MDF 3 mm"'
//
// KERF
//   Não há compensação na geometria. Deixe o offset de kerf em zero
//   neste teste.
// =====================================================================

/* [Valores dos rótulos] */
// Velocidades das colunas, em mm/s (da esquerda para a direita)
speeds = [10, 20, 30, 40, 50];
// Potências das linhas, em % (de baixo para cima)
powers = [40, 50, 60, 70, 80];

/* [Geometria] */
// Lado de cada quadrado, em mm
square_size = 10;
// Espaço entre quadrados, em mm
gap = 4;
// Tamanho do texto dos rótulos, em mm
label_size = 3;
// Distância entre a grade e os rótulos, em mm
label_gap = 2;
// Texto livre gravado abaixo da grade
note = "";

/* [Camada] */
// cut = quadrados; engrave = rótulos
layer = "cut"; // [cut, engrave]
// Duas marcas de registro idênticas nas duas camadas, fora da peça
registration = false;

/* [Hidden] */
pitch = square_size + gap;
cols  = len(speeds);
rows  = len(powers);
cap   = 0.9555 * label_size;     // altura de dígitos e maiúsculas
grid_top = (rows - 1) * pitch + square_size;
// caixa que contém quadrados, rótulos e nota, com folga para textos longos (marcas de registro)
reg_x0 = -(label_gap + 5 * label_size);
reg_x1 = max((cols - 1) * pitch + square_size + 2.5 * label_size, len(note) * 1.1 * label_size);
reg_y0 = -(label_gap + cap + 0.3 * label_size);
reg_y1 = grid_top + label_gap + cap + 0.3 * label_size;

// Número com vírgula decimal: inteiro se for inteiro, senão até 2 casas
function pad2(n) = n < 10 ? str("0", n) : str(n);
function fmt(x) =
    let(c = round(abs(x) * 100), s = x < 0 ? "-" : "",
        ip = floor(c / 100), fp = c % 100)
    fp == 0 ? str(s, ip)
    : (fp % 10 == 0 ? str(s, ip, ",", fp / 10) : str(s, ip, ",", pad2(fp)));

// Texto com o centro vertical dos dígitos em y
module label(txt, x, y, ha) {
    translate([x, y - cap / 2])
        text(txt, size = label_size, font = "Liberation Sans:style=Bold",
             halign = ha, valign = "baseline", $fn = 24);
}

// Marcas de registro: dois círculos de 0,6 mm, iguais nas duas camadas, nos cantos
// opostos da caixa (x0, y0, x1, y1) que contém toda a geometria, a `gap` mm de
// distância. As duas camadas passam a ter a mesma caixa, então o software as
// posiciona igual, e as marcas servem para conferir ou alinhar à mão.
module registration_marks(x0, y0, x1, y1, gap = 3) {
    for (p = [[x0 - gap, y0 - gap], [x1 + gap, y1 + gap]])
        translate(p) circle(d = 0.6, $fn = 16);
}

module cut_layer() {
    for (i = [0 : cols - 1], j = [0 : rows - 1])
        translate([i * pitch, j * pitch]) square(square_size);
}

module engrave_layer() {
    y_cols = grid_top + label_gap + cap / 2;
    // legenda das colunas, alinhada com os números de velocidade
    label("mm/s", -label_gap, y_cols, "right");
    for (i = [0 : cols - 1])
        label(fmt(speeds[i]), i * pitch + square_size / 2, y_cols, "center");
    // potência de cada linha
    for (j = [0 : rows - 1])
        label(str(fmt(powers[j]), "%"), -label_gap, j * pitch + square_size / 2, "right");
    if (len(note) > 0)
        label(note, 0, -label_gap - cap / 2, "left");
}

assert(layer == "cut" || layer == "engrave", "layer deve ser \"cut\" ou \"engrave\"");
assert(cols > 0 && rows > 0, "speeds e powers precisam ter pelo menos um valor");

if (layer == "cut") cut_layer();
else engrave_layer();
if (registration) registration_marks(reg_x0, reg_y0, reg_x1, reg_y1);
