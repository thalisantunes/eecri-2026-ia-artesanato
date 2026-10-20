// =====================================================================
// caixa-finger-joint.scad
// Caixa aberta em cima (5 painéis) com encaixes tipo finger joint (dedos),
// mais tampa simples opcional. Painéis lado a lado em 2D, prontos para
// cortar. Unidades em milímetros. OpenSCAD 2021.01.
//
// COMO OS DEDOS FECHAM (leia antes de mexer)
//   length, width e height são as medidas EXTERNAS da caixa.
//   Todo painel nasce como um retângulo inteiro e perde entalhes (vazios)
//   nas arestas em que encaixa. Onde um painel tem dedo, o vizinho tem
//   vazio, na mesma posição e com o mesmo comprimento.
//   - Arestas verticais (frente/trás com esquerda/direita): os dedos
//     alternam de cima para baixo. Frente e trás ficam com o dedo mais
//     alto; esquerda e direita ficam com o vazio mais alto.
//   - Arestas da base: os dedos alternam entre os cantos. A base é dona
//     dos quatro cantos (cubo de espessura x espessura x espessura), então
//     as paredes ganham um entalhe quadrado no canto de baixo. Assim dois
//     painéis nunca disputam o mesmo canto. No lado da frente e de trás
//     o primeiro segmento é dedo da base; nos lados esquerdo e direito é
//     dedo da parede. Isso mantém cada canto da base preso ao resto.
//   - O número de dedos de cada aresta é ajustado para ser ímpar e as
//     larguras ficam iguais. finger_width é o alvo, não o valor exato.
//   Conferido em 3D: com clearance = 0 os cinco painéis não se
//   sobrepõem e preenchem a casca da caixa sem sobra.
//
// PARÂMETROS (mude aqui no topo ou com -D na linha de comando)
//   length, width, height   medidas externas da caixa, em mm
//   thickness               espessura da chapa, em mm (medida com paquímetro)
//   finger_width            largura alvo dos dedos, em mm (2 a 3 vezes a espessura)
//   clearance               folga total entre dedo e vazio, em mm (0 = encaixe
//                           nominal). Não é o kerf: o kerf se compensa no software
//   with_lid                true = inclui tampa simples (tampa + miolo)
//   part_labels             true = grava o nome de cada painel (camada engrave)
//   spacing                 espaço entre os painéis na chapa, em mm
//   layer                   "cut" = contornos; "engrave" = nomes dos painéis
//   registration            true = desenha duas marcas de registro (círculos de 0,6 mm)
//                           idênticas nas duas camadas, a 3 mm da peça. Servem para alinhar
//                           as camadas à mão se o software importar cada arquivo por conta
//                           própria. Padrão: false
//
// PAINÉIS
//   BASE      length x width      FRENTE e ATRÁS   length x height
//   ESQ. e DIR.  width x height   TAMPA  length x width
//   MIOLO (só com tampa): cole no centro da face de baixo da TAMPA. Ele
//   entra na abertura da caixa e trava a tampa. Folga do miolo = clearance.
//   Grave os nomes do lado de dentro dos painéis (ou use part_labels=false).
//
// COMO EXPORTAR (um SVG por camada)
//   openscad -D 'layer="cut"'     -o caixa-cut.svg     caixa-finger-joint.scad
//   openscad -D 'layer="engrave"' -o caixa-engrave.svg caixa-finger-joint.scad
//   Caixa maior: -D 'length=120' -D 'width=80' -D 'height=60' -D 'thickness=2.9'
//
// KERF
//   Não há compensação de kerf na geometria. Configure o offset de kerf
//   na camada de corte do software (use teste-kerf.scad para medir) e
//   confira o encaixe cortando uma caixa pequena antes da final.
// =====================================================================

/* [Medidas externas da caixa] */
// Comprimento (eixo X), em mm
length = 80;
// Largura (eixo Y), em mm
width = 60;
// Altura (eixo Z), em mm
height = 40;

/* [Material e encaixe] */
// Espessura da chapa, em mm (medida com paquímetro)
thickness = 3;
// Largura alvo dos dedos, em mm
finger_width = 9;
// Folga total entre dedo e vazio, em mm
clearance = 0.1;

/* [Extras] */
// Incluir tampa simples (tampa + miolo)
with_lid = false;
// Gravar o nome de cada painel
part_labels = true;
// Espaço entre os painéis na chapa, em mm
spacing = 5;

/* [Camada] */
// cut = contornos; engrave = nomes dos painéis
layer = "cut"; // [cut, engrave]
// Duas marcas de registro idênticas nas duas camadas, fora da peça
registration = false;

/* [Hidden] */
// ---------------------------------------------------------------------
// Dedos
// ---------------------------------------------------------------------

// Quantidade ímpar de segmentos mais próxima de edge_length / finger
function odd_count(edge_length, finger) =
    let(n = max(1, round(edge_length / finger)))
    (n % 2 == 1) ? n : ((edge_length / finger > n) ? n + 1 : max(1, n - 1));

// Desenha os ENTALHES (vazios) de uma aresta de comprimento edge_length,
// ao longo de +X, com profundidade `depth` para dentro (+Y).
// O segmento 0 é dedo se starts_with_finger, senão é vazio; depois alterna.
// O painel vizinho usa o mesmo edge_length e starts_with_finger invertido.
// clear alarga cada vazio em clear/4 de cada lado (folga total = clear).
module edge_fingers(edge_length, depth, finger, starts_with_finger, clear) {
    n   = odd_count(edge_length, finger);
    seg = edge_length / n;
    for (i = [0 : n - 1])
        if ((i % 2 == 0) != starts_with_finger)
            translate([i * seg - clear / 4, 0])
                square([seg + clear / 2, depth]);
}

// Aresta horizontal de baixo, entre os cantos (de x = t até x = len - t)
module bottom_edge_notches(len, starts_with_finger) {
    translate([thickness, 0])
        edge_fingers(len - 2 * thickness, thickness, finger_width, starts_with_finger, clearance);
}

// Arestas verticais de uma parede, da borda de cima até o canto da base.
// O lado esquerdo fica em x = 0, o direito em x = len; ambos contam de cima para baixo.
module vertical_edge_notches(len, starts_with_finger) {
    h = height - thickness;
    // esquerda: (s, d) -> (x = d, y = height - s)
    translate([0, height]) rotate(-90)
        edge_fingers(h, thickness, finger_width, starts_with_finger, clearance);
    // direita: (s, d) -> (x = len - d, y = height - s)
    translate([len, height]) rotate(-90) mirror([0, 1])
        edge_fingers(h, thickness, finger_width, starts_with_finger, clearance);
}

// Entalhes quadrados nos dois cantos de baixo (cubos que pertencem à base)
module bottom_corner_notches(len) {
    square([thickness, thickness]);
    translate([len - thickness, 0]) square([thickness, thickness]);
}

// ---------------------------------------------------------------------
// Painéis (cada um no seu próprio plano; x = horizontal, y = vertical)
// ---------------------------------------------------------------------

// Frente e trás: length x height. Dedo mais alto na quina vertical;
// na aresta de baixo o primeiro segmento é vazio (a base fica com ele).
module wall_long() {
    difference() {
        square([length, height]);
        bottom_corner_notches(length);
        bottom_edge_notches(length, false);
        vertical_edge_notches(length, true);
    }
}

// Esquerda e direita: width x height. Vazio mais alto na quina vertical;
// na aresta de baixo o primeiro segmento é dedo da parede.
module wall_short() {
    difference() {
        square([width, height]);
        bottom_corner_notches(width);
        bottom_edge_notches(width, true);
        vertical_edge_notches(width, false);
    }
}

// Base: length x width. Dona dos quatro cantos; vazios onde as paredes têm dedo.
module base_panel() {
    n_x = length - 2 * thickness;
    n_y = width - 2 * thickness;
    difference() {
        square([length, width]);
        // arestas da frente (y = 0) e de trás (y = width): começam com dedo da base
        translate([thickness, 0])
            edge_fingers(n_x, thickness, finger_width, true, clearance);
        translate([thickness, width]) mirror([0, 1])
            edge_fingers(n_x, thickness, finger_width, true, clearance);
        // arestas da esquerda (x = 0) e da direita (x = length): começam com vazio
        translate([0, thickness]) rotate(90) mirror([0, 1])
            edge_fingers(n_y, thickness, finger_width, false, clearance);
        translate([length, thickness]) mirror([1, 0]) rotate(90) mirror([0, 1])
            edge_fingers(n_y, thickness, finger_width, false, clearance);
    }
}

// Tampa simples: placa do tamanho da caixa + miolo que entra na abertura
module lid_top()  { square([length, width]); }
module lid_plug() { square([length - 2 * thickness - clearance, width - 2 * thickness - clearance]); }

// ---------------------------------------------------------------------
// Disposição na chapa: linha 1 = base, esquerda, direita;
// linha 2 = frente, trás; linha 3 (só com tampa) = tampa, miolo.
// ---------------------------------------------------------------------
row1_h  = max(width, height);
x_left  = length + spacing;
x_right = x_left + width + spacing;
y_row2  = row1_h + spacing;
x_back  = length + spacing;
y_row3  = y_row2 + height + spacing;
// tamanho do conjunto de painéis na chapa (marcas de registro ficam fora dele)
layout_w = max(x_right + width, 2 * length + spacing,
               with_lid ? length + spacing + (length - 2 * thickness - clearance) : 0);
layout_h = with_lid ? y_row3 + width : y_row2 + height;

// Marcas de registro: dois círculos de 0,6 mm, iguais nas duas camadas, nos cantos
// opostos da caixa (x0, y0, x1, y1) que contém toda a geometria, a `gap` mm de
// distância. As duas camadas passam a ter a mesma caixa, então o software as
// posiciona igual, e as marcas servem para conferir ou alinhar à mão.
module registration_marks(x0, y0, x1, y1, gap = 3) {
    for (p = [[x0 - gap, y0 - gap], [x1 + gap, y1 + gap]])
        translate(p) circle(d = 0.6, $fn = 16);
}

// Nome centralizado no painel; menor se o painel for pequeno
module label_at(txt, w, h) {
    s = min(4, h / 4, w / (len(txt) * 1.2 + 1));
    translate([w / 2, h / 2 - 0.9555 * s / 2])
        text(txt, size = s, font = "Liberation Sans:style=Bold",
             halign = "center", valign = "baseline", $fn = 24);
}

module cut_layer() {
    base_panel();
    translate([x_left, 0])  wall_short();
    translate([x_right, 0]) wall_short();
    translate([0, y_row2])      wall_long();
    translate([x_back, y_row2]) wall_long();
    if (with_lid) {
        translate([0, y_row3]) lid_top();
        translate([length + spacing, y_row3]) lid_plug();
    }
}

module engrave_layer() {
    label_at("BASE", length, width);
    translate([x_left, 0])  label_at("ESQ.", width, height);
    translate([x_right, 0]) label_at("DIR.", width, height);
    translate([0, y_row2])      label_at("FRENTE", length, height);
    translate([x_back, y_row2]) label_at("ATRÁS", length, height);
    if (with_lid) {
        translate([0, y_row3]) label_at("TAMPA", length, width);
        translate([length + spacing, y_row3])
            label_at("MIOLO", length - 2 * thickness - clearance, width - 2 * thickness - clearance);
    }
}

assert(layer == "cut" || layer == "engrave", "layer deve ser \"cut\" ou \"engrave\"");
assert(layer == "cut" || part_labels, "layer engrave com part_labels=false não tem nada para gravar");
assert(thickness > 0 && finger_width > 0, "thickness e finger_width precisam ser positivos");
assert(clearance >= 0 && clearance < thickness, "clearance deve estar entre 0 e a espessura");
assert(length > 4 * thickness && width > 4 * thickness,
       "length e width precisam ser maiores que 4 vezes a espessura");
assert(height > 2 * thickness, "height precisa ser maior que 2 vezes a espessura");

if (layer == "cut") cut_layer();
else engrave_layer();
if (registration) registration_marks(0, 0, layout_w, layout_h);
