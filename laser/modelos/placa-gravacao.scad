// =====================================================================
// placa-gravacao.scad
// Placa retangular com título e subtítulo gravados, contorno de corte,
// furos opcionais e amostras de preenchimento para testar a gravação.
// Unidades em milímetros. OpenSCAD 2021.01.
//
// O QUE É
//   Camada "cut": contorno da placa (cantos arredondados) e furos.
//   Camada "engrave": título, subtítulo e amostras de preenchimento.
//   Os dois textos diminuem sozinhos se não couberem na largura livre
//   (o aviso aparece no console). O subtítulo nunca passa do tamanho
//   do título.
//   As amostras são quadrados cheios numerados. Para testar velocidade,
//   potência ou intervalo de linha, ponha cada amostra em uma camada do
//   software, com ajustes diferentes. O número fica sem gravar (vazado),
//   só para identificar.
//
// PARÂMETROS (mude aqui no topo ou com -D na linha de comando)
//   title, subtitle            textos gravados
//   title_size, subtitle_size  tamanhos desejados, em mm
//   width, height              tamanho da placa, em mm
//   corner_radius              raio dos cantos, em mm
//   margin                     margem entre os textos e a borda, em mm
//   holes                      0 = sem furos, 2 = cantos de cima, 4 = quatro cantos
//   hole_diameter              diâmetro dos furos, em mm
//   hole_margin                distância da borda da placa até a borda do furo, em mm
//   patches                    quantidade de amostras de preenchimento (0 = nenhuma)
//   patch_size                 lado de cada amostra, em mm
//   layer                      "cut" = contorno e furos; "engrave" = textos e amostras
//   registration               true = desenha duas marcas de registro (círculos de 0,6 mm)
//                              idênticas nas duas camadas, a 3 mm da peça. Servem para alinhar
//                              as camadas à mão se o software importar cada arquivo por conta
//                              própria. Padrão: false
//
// COMO EXPORTAR (um SVG por camada)
//   openscad -D 'layer="cut"'     -o placa-cut.svg     placa-gravacao.scad
//   openscad -D 'layer="engrave"' -o placa-engrave.svg placa-gravacao.scad
//   Outra placa: openscad -D 'title="Café do Zé"' -D 'subtitle="desde 1998"' \
//                          -D 'layer="engrave"' -o cafe-engrave.svg placa-gravacao.scad
//
// KERF
//   Não há compensação de kerf na geometria. Configure o offset de kerf
//   na camada de corte do software. Use teste-kerf.scad para medir.
// =====================================================================

/* [Texto] */
// Texto principal
title = "I EECri 2026";
// Texto secundário
subtitle = "Nova Porteirinha - MG";
// Tamanho desejado do título, em mm
title_size = 9;
// Tamanho desejado do subtítulo, em mm
subtitle_size = 5;

/* [Placa] */
// Largura da placa, em mm
width = 100;
// Altura da placa, em mm
height = 60;
// Raio dos cantos, em mm
corner_radius = 3;
// Margem entre os textos e a borda, em mm
margin = 6;

/* [Furos] */
// 0 = sem furos, 2 = cantos de cima, 4 = quatro cantos
holes = 0; // [0, 2, 4]
// Diâmetro dos furos, em mm
hole_diameter = 4;
// Distância da borda da placa até a borda do furo, em mm
hole_margin = 4;

/* [Amostras de preenchimento] */
// Quantidade de amostras (0 = nenhuma)
patches = 3;
// Lado de cada amostra, em mm
patch_size = 12;

/* [Camada] */
// cut = contorno e furos; engrave = textos e amostras
layer = "cut"; // [cut, engrave]
// Duas marcas de registro idênticas nas duas camadas, fora da peça
registration = false;

/* [Hidden] */
// ---------------------------------------------------------------------
// Largura do texto (não precisa mexer). Mesma tabela do chaveiro-tag.scad.
// Avanços do Liberation Sans, iguais aos do Arial, em milésimos de em,
// para os caracteres ASCII 32 a 126. No OpenSCAD 2021.01 o em do text()
// vale 1,3567 x size (medido). Acentos usam a largura da letra base.
// ---------------------------------------------------------------------
em_per_size = 1.3567;
adv_regular = [
    278, 278, 355, 556, 556, 889, 667, 191, 333, 333, 389, 584, 278, 333, 278, 278,
    556, 556, 556, 556, 556, 556, 556, 556, 556, 556, 278, 278, 584, 584, 584, 556,
    1015, 667, 667, 722, 722, 667, 611, 778, 722, 278, 500, 667, 556, 833, 722, 778,
    667, 778, 722, 667, 611, 722, 667, 944, 667, 667, 611, 278, 278, 278, 469, 556,
    333, 556, 556, 500, 556, 556, 278, 556, 556, 222, 222, 500, 222, 833, 556, 556,
    556, 556, 333, 500, 278, 556, 500, 722, 500, 500, 500, 334, 260, 334, 584];
adv_bold = [
    278, 333, 474, 556, 556, 889, 722, 238, 333, 333, 389, 584, 278, 333, 278, 278,
    556, 556, 556, 556, 556, 556, 556, 556, 556, 556, 333, 333, 584, 584, 584, 611,
    975, 722, 722, 722, 722, 667, 611, 778, 722, 278, 556, 722, 611, 833, 722, 778,
    667, 778, 722, 667, 611, 722, 667, 944, 667, 667, 611, 333, 278, 333, 584, 556,
    333, 556, 611, 556, 611, 556, 333, 611, 611, 278, 278, 556, 278, 889, 611, 611,
    611, 611, 389, 556, 333, 611, 556, 778, 556, 556, 500, 389, 280, 389, 584];
accented      = "áàâãäåéèêëíìîïóòôõöúùûüçñÁÀÂÃÄÅÉÈÊËÍÌÎÏÓÒÔÕÖÚÙÛÜÇÑ";
accented_base = "aaaaaaeeeeiiiiooooouuuucnAAAAAAEEEEIIIIOOOOOUUUUCN";

function ascii_adv(code, bold) = (bold ? adv_bold : adv_regular)[code - 32];
function char_adv(c, bold) =
    let(code = ord(c))
    (code >= 32 && code <= 126) ? ascii_adv(code, bold)
    : let(i = search(c, accented))
      (len(i) > 0) ? ascii_adv(ord(accented_base[i[0]]), bold) : 1000;
function str_adv(s, bold, i = 0) =
    (i >= len(s)) ? 0 : char_adv(s[i], bold) + str_adv(s, bold, i + 1);

// Altura da letra maiúscula, em relação ao size (medido: 0,9555)
cap_ratio = 0.9555;

// Tamanho que cabe: o menor entre o desejado e o que enche a largura livre
function fit_size(s, wanted, avail_w, bold) =
    len(s) == 0 ? wanted
    : min(wanted, avail_w * 0.98 / (em_per_size * str_adv(s, bold) / 1000));

// ---------------------------------------------------------------------
// Medidas derivadas
// ---------------------------------------------------------------------
hole_r  = hole_diameter / 2;
hole_c  = hole_margin + hole_r;          // distância do centro do furo às bordas
patches_on = patches > 0;
patch_gap  = 8;
// largura livre do texto: sai dos furos, se houver
text_x0 = max(margin, holes > 0 ? hole_margin + hole_diameter + 3 : 0);
text_w  = width - 2 * text_x0;
// faixa vertical livre para os textos (acima das amostras)
area_y0 = patches_on ? margin + patch_size + 4 : margin;
area_y1 = height - margin;

t_size = fit_size(title, title_size, text_w, true);
// o subtítulo nunca fica maior que o título
s_size = min(fit_size(subtitle, subtitle_size, text_w, false), len(title) > 0 ? t_size : subtitle_size);
t_cap  = cap_ratio * t_size;
s_cap  = cap_ratio * s_size;
line_gap = 0.45 * t_size;
has_t = len(title) > 0;
has_s = len(subtitle) > 0;
block_h = (has_t ? t_cap : 0) + (has_t && has_s ? line_gap : 0) + (has_s ? s_cap : 0);
block_y0 = area_y0 + (area_y1 - area_y0 - block_h) / 2;   // base do bloco de texto
// linha de base de cada texto (subtítulo embaixo, título em cima)
s_base = block_y0;
t_base = block_y0 + (has_s ? s_cap + line_gap : 0);

// Marcas de registro: dois círculos de 0,6 mm, iguais nas duas camadas, nos cantos
// opostos da caixa (x0, y0, x1, y1) que contém toda a geometria, a `gap` mm de
// distância. As duas camadas passam a ter a mesma caixa, então o software as
// posiciona igual, e as marcas servem para conferir ou alinhar à mão.
module registration_marks(x0, y0, x1, y1, gap = 3) {
    for (p = [[x0 - gap, y0 - gap], [x1 + gap, y1 + gap]])
        translate(p) circle(d = 0.6, $fn = 16);
}

module rounded_plate() {
    translate([corner_radius, corner_radius])
        offset(r = corner_radius, $fn = 48)
            square([width - 2 * corner_radius, height - 2 * corner_radius]);
}

// centros dos furos
function hole_centers() =
    holes == 2 ? [[hole_c, height - hole_c], [width - hole_c, height - hole_c]]
    : holes == 4 ? [[hole_c, hole_c], [width - hole_c, hole_c],
                    [hole_c, height - hole_c], [width - hole_c, height - hole_c]]
    : [];

module cut_layer() {
    difference() {
        rounded_plate();
        for (c = hole_centers()) translate(c) circle(d = hole_diameter, $fn = 48);
    }
}

module engrave_layer() {
    if (has_t)
        translate([width / 2, t_base])
            text(title, size = t_size, font = "Liberation Sans:style=Bold",
                 halign = "center", valign = "baseline", $fn = 32);
    if (has_s)
        translate([width / 2, s_base])
            text(subtitle, size = s_size, font = "Liberation Sans",
                 halign = "center", valign = "baseline", $fn = 32);
    // amostras de preenchimento, centralizadas na parte de baixo
    if (patches_on) {
        total = patches * patch_size + (patches - 1) * patch_gap;
        for (i = [0 : patches - 1])
            translate([(width - total) / 2 + i * (patch_size + patch_gap), margin])
                difference() {
                    square(patch_size);
                    // número vazado no meio da amostra
                    translate([patch_size / 2, patch_size / 2 - cap_ratio * patch_size * 0.5 / 2])
                        text(str(i + 1), size = patch_size * 0.5,
                             font = "Liberation Sans:style=Bold",
                             halign = "center", valign = "baseline", $fn = 24);
                }
    }
}

assert(layer == "cut" || layer == "engrave", "layer deve ser \"cut\" ou \"engrave\"");
assert(holes == 0 || holes == 2 || holes == 4, "holes deve ser 0, 2 ou 4");
assert(2 * corner_radius <= min(width, height), "corner_radius grande demais para a placa");
assert(holes == 0 || hole_margin >= 2, "hole_margin menor que 2 mm: o furo pode rasgar a borda");
assert(!patches_on || patches * patch_size + (patches - 1) * patch_gap <= width - 2 * margin,
       "as amostras não cabem na largura da placa: reduza patches ou patch_size");
assert(area_y1 - area_y0 >= block_h,
       "os textos não cabem na altura da placa: aumente height ou reduza os tamanhos");
assert(layer == "cut" || has_t || has_s || patches_on, "não há nada para gravar");

if (t_size < title_size - 0.01)
    echo(str("AVISO: o título foi reduzido de ", title_size, " para ", round(t_size * 10) / 10, " mm para caber"));
if (s_size < subtitle_size - 0.01)
    echo(str("AVISO: o subtítulo foi reduzido de ", subtitle_size, " para ", round(s_size * 10) / 10, " mm para caber"));

if (layer == "cut") cut_layer();
else engrave_layer();
if (registration) registration_marks(0, 0, width, height);
