// =====================================================================
// chaveiro-tag.scad
// Tag retangular de chaveiro: cantos arredondados, furo para argola e
// texto gravado (nome, frase). Unidades em milímetros. OpenSCAD 2021.01.
//
// O QUE É
//   Duas camadas: "cut" (contorno com furo) e "engrave" (texto).
//   Se o texto não couber na área livre da tag, o tamanho diminui sozinho
//   (o aviso aparece no console). A largura é calculada com as medidas da
//   fonte Liberation Sans, que vem junto com o OpenSCAD.
//
// PARÂMETROS (mude aqui no topo ou com -D na linha de comando)
//   label          texto gravado
//   font_size      tamanho desejado do texto, em mm
//   bold           true = negrito, mais legível quando gravado pequeno
//   width, height  tamanho da tag, em mm
//   corner_radius  raio dos cantos, em mm (0 = cantos retos)
//   hole_diameter  diâmetro do furo da argola, em mm (0 = sem furo)
//   hole_margin    distância da borda da tag até a borda do furo, em mm
//   text_margin    folga entre o texto e as bordas ou o furo, em mm
//   layer          "cut" = contorno e furo; "engrave" = texto
//   registration   true = desenha duas marcas de registro (círculos de 0,6 mm)
//                  idênticas nas duas camadas, a 3 mm da tag. Servem para alinhar
//                  as camadas à mão se o software importar cada arquivo por conta
//                  própria. Padrão: false
//
// COMO EXPORTAR (um SVG por camada)
//   openscad -D 'layer="cut"'     -o chaveiro-tag-cut.svg     chaveiro-tag.scad
//   openscad -D 'layer="engrave"' -o chaveiro-tag-engrave.svg chaveiro-tag.scad
//   Outro nome: openscad -D 'label="Maria"' -D 'layer="engrave"' \
//                        -o maria-engrave.svg chaveiro-tag.scad
//   Importe os dois SVGs e confira se o texto cai dentro do contorno
//   (veja a nota sobre registro das camadas em README.md). O exportar.sh também
//   gera um SVG combinado (corte em vermelho, gravação em azul).
//
// KERF
//   Não há compensação de kerf na geometria. Configure o offset de kerf
//   na camada de corte do software (LightBurn: "Kerf offset"; RDWorks:
//   compensação). Use teste-kerf.scad para medir o valor.
// =====================================================================

/* [Texto] */
// Texto gravado na tag
label = "EECri 2026";
// Tamanho desejado do texto, em mm (diminui sozinho se não couber)
font_size = 6;
// Negrito (mais legível quando gravado pequeno)
bold = true;

/* [Tag] */
// Largura da tag, em mm
width = 60;
// Altura da tag, em mm
height = 25;
// Raio dos cantos, em mm
corner_radius = 4;
// Diâmetro do furo da argola, em mm (0 = sem furo)
hole_diameter = 4;
// Distância da borda da tag até a borda do furo, em mm
hole_margin = 3;
// Folga entre o texto e as bordas ou o furo, em mm
text_margin = 3;

/* [Camada] */
// cut = contorno e furo; engrave = texto
layer = "cut"; // [cut, engrave]
// Duas marcas de registro idênticas nas duas camadas, fora da peça
registration = false;

/* [Hidden] */
// ---------------------------------------------------------------------
// Largura do texto (não precisa mexer).
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
// Descida máxima abaixo da linha de base (g, p, y), em relação ao size
desc_ratio = 0.29;

// ---------------------------------------------------------------------
// Marcas de registro: dois círculos de 0,6 mm, iguais nas duas camadas, nos
// cantos opostos da caixa (x0, y0, x1, y1) que contém toda a geometria, a `gap`
// mm de distância. Como as duas camadas passam a ter a mesma caixa, o software
// as posiciona igual, e as marcas servem para conferir ou alinhar à mão.
// ---------------------------------------------------------------------
module registration_marks(x0, y0, x1, y1, gap = 3) {
    for (p = [[x0 - gap, y0 - gap], [x1 + gap, y1 + gap]])
        translate(p) circle(d = 0.6, $fn = 16);
}

// ---------------------------------------------------------------------
// Peça. Recebe tudo por argumento para poder ser usada por chaveiros-lote.scad.
// ---------------------------------------------------------------------
module keychain_tag(label, width, height, corner_radius, hole_diameter, hole_margin,
                    font_size, bold, text_margin, layer) {
    has_hole = hole_diameter > 0;
    // Área livre do texto: da direita do furo até a margem direita
    text_x0 = has_hole ? hole_margin + hole_diameter + text_margin : text_margin;
    text_w  = width - text_x0 - text_margin;

    if (layer == "cut") {
        difference() {
            translate([corner_radius, corner_radius])
                offset(r = corner_radius, $fn = 48)
                    square([width - 2 * corner_radius, height - 2 * corner_radius]);
            if (has_hole)
                translate([hole_margin + hole_diameter / 2, height / 2])
                    circle(d = hole_diameter, $fn = 48);
        }
    } else if (layer == "engrave" && len(label) > 0) {
        unit_w  = em_per_size * str_adv(label, bold) / 1000;   // largura com size = 1
        size_w  = text_w * 0.98 / unit_w;
        size_h  = (height / 2 - text_margin) / (cap_ratio / 2 + desc_ratio);
        s       = min(font_size, size_w, size_h);
        if (s < font_size - 0.01)
            echo(str("AVISO: o texto \"", label, "\" foi reduzido de ", font_size,
                     " para ", round(s * 10) / 10, " mm para caber na tag"));
        if (s < 3)
            echo(str("AVISO: texto menor que 3 mm (", round(s * 10) / 10,
                     " mm) grava mal; aumente a tag ou encurte o texto"));
        translate([text_x0 + text_w / 2, height / 2 - cap_ratio * s / 2])
            text(label, size = s, font = bold ? "Liberation Sans:style=Bold" : "Liberation Sans",
                 halign = "center", valign = "baseline", $fn = 32);
    }
}

assert(layer == "cut" || layer == "engrave", "layer deve ser \"cut\" ou \"engrave\"");
assert(layer == "cut" || len(label) > 0, "label vazio: não há texto para gravar");
assert(2 * corner_radius <= min(width, height), "corner_radius grande demais para a tag");
assert(hole_diameter == 0 || hole_diameter + 2 * hole_margin <= height,
       "o furo não cabe na altura da tag");
assert(hole_diameter == 0 || hole_margin >= 2,
       "hole_margin menor que 2 mm: o furo pode rasgar a borda");

keychain_tag(label, width, height, corner_radius, hole_diameter, hole_margin,
             font_size, bold, text_margin, layer);
if (registration) registration_marks(0, 0, width, height);
