// =====================================================================
// chaveiros-lote.scad
// Lote de chaveiros (chaveiro-tag.scad) distribuídos em grade numa
// chapa de tamanho definido por você. Cada nome da lista vira uma tag.
// Unidades em milímetros. OpenSCAD 2021.01.
//
// PRECISA de chaveiro-tag.scad na mesma pasta (use <chaveiro-tag.scad>).
//
// O QUE É
//   Camada "cut": contorno e furo de cada tag. Camada "engrave": os nomes.
//   As tags entram em ordem de leitura, da esquerda para a direita e de
//   cima para baixo. O texto de cada tag diminui sozinho se o nome não
//   couber (aviso no console).
//   Se os nomes não couberem em uma chapa, o console avisa; exporte as
//   outras chapas com sheet=2, sheet=3...
//   Serve também para medir a vazão: com count maior que a lista, os
//   nomes se repetem até encher a chapa.
//
// PARÂMETROS (mude aqui no topo ou com -D na linha de comando)
//   labels         lista de nomes, um por tag
//   count          total de tags; 0 = uma por nome. Se maior que a lista, repete os nomes
//   sheet_width, sheet_height  tamanho da chapa, em mm (área útil do material)
//   sheet_margin   margem da chapa sem tags, em mm
//   tag_gap        espaço entre tags, em mm
//   sheet          número da chapa a gerar (1, 2, ...)
//   tag_width, tag_height, corner_radius, hole_diameter, hole_margin,
//   font_size, bold, text_margin   iguais aos de chaveiro-tag.scad
//   layer          "cut" = contornos e furos; "engrave" = nomes
//   registration   true = duas marcas de registro (círculos de 0,6 mm) idênticas
//                  nas duas camadas, fora da grade de tags. Padrão: false
//
// COMO EXPORTAR (um SVG por camada)
//   openscad -D 'layer="cut"'     -o lote-cut.svg     chaveiros-lote.scad
//   openscad -D 'layer="engrave"' -o lote-engrave.svg chaveiros-lote.scad
//   Seus nomes e uma chapa de 600 x 400:
//     openscad -D 'labels=["Ana","Bruno","Carla"]' -D 'sheet_width=600' \
//              -D 'sheet_height=400' -D 'layer="cut"' -o lote-cut.svg chaveiros-lote.scad
//   Chapa cheia para teste de vazão (nomes repetidos):
//     -D 'count=100' -D 'sheet_width=600' -D 'sheet_height=400'
//
// KERF
//   Não há compensação de kerf na geometria. Configure o offset de kerf
//   na camada de corte do software. Use teste-kerf.scad para medir.
// =====================================================================

use <chaveiro-tag.scad>

/* [Nomes] */
// Um nome por tag
labels = ["Ana", "João", "Maria", "Pedro", "Lúcia", "Carlos",
          "Fernanda", "Conceição", "Aparecida", "Beatriz", "Rafael", "Juliana",
          "Marcos", "Patrícia", "Eduardo", "Luciana", "Gabriel", "Mônica",
          "Renato", "Sandra", "Thiago", "Vanessa", "Wellington", "Zélia"];
// Total de tags (0 = uma por nome; maior que a lista repete os nomes)
count = 0;

/* [Chapa] */
// Largura da chapa, em mm
sheet_width = 300;
// Altura da chapa, em mm
sheet_height = 200;
// Margem da chapa sem tags, em mm
sheet_margin = 5;
// Espaço entre as tags, em mm
tag_gap = 4;
// Número da chapa a gerar quando os nomes não cabem em uma
sheet = 1;

/* [Chaveiro] */
tag_width = 60;
tag_height = 25;
corner_radius = 4;
hole_diameter = 4;
hole_margin = 3;
font_size = 6;
bold = true;
text_margin = 3;

/* [Camada] */
// cut = contornos e furos; engrave = nomes
layer = "cut"; // [cut, engrave]
// Duas marcas de registro idênticas nas duas camadas, fora da peça
registration = false;

/* [Hidden] */
cols     = floor((sheet_width  - 2 * sheet_margin + tag_gap) / (tag_width  + tag_gap));
rows     = floor((sheet_height - 2 * sheet_margin + tag_gap) / (tag_height + tag_gap));
capacity = cols * rows;
total    = count > 0 ? count : len(labels);
first    = (sheet - 1) * capacity;
last     = min(total, sheet * capacity) - 1;
sheets_needed = capacity > 0 ? ceil(total / capacity) : 0;
// caixa da grade inteira (as marcas ficam fora dela, a 3 mm, ou menos se a margem da chapa for menor)
grid_x0 = sheet_margin;
grid_x1 = sheet_margin + cols * tag_width + (cols - 1) * tag_gap;
grid_y1 = sheet_height - sheet_margin;
grid_y0 = grid_y1 - rows * tag_height - (rows - 1) * tag_gap;

assert(layer == "cut" || layer == "engrave", "layer deve ser \"cut\" ou \"engrave\"");
assert(len(labels) > 0, "labels precisa ter pelo menos um nome");
assert(capacity > 0, "a tag não cabe na chapa: aumente sheet_width/sheet_height ou reduza a tag");
assert(sheet >= 1 && first <= last, str("a chapa ", sheet, " não tem tags: há ", sheets_needed, " chapa(s)"));
assert(!registration || sheet_margin >= 2, "com registration, sheet_margin precisa ser de pelo menos 2 mm");

if (sheets_needed > 1)
    echo(str("AVISO: ", total, " tags não cabem em uma chapa (cabem ", capacity,
             " por chapa de ", sheet_width, " x ", sheet_height, " mm). Gerando a chapa ",
             sheet, " de ", sheets_needed, "; use sheet=2, sheet=3... para as outras"));

for (k = [first : last]) {
    pos = k - first;
    col = pos % cols;
    row = floor(pos / cols);
    translate([sheet_margin + col * (tag_width + tag_gap),
               sheet_height - sheet_margin - (row + 1) * tag_height - row * tag_gap])
        keychain_tag(labels[k % len(labels)], tag_width, tag_height, corner_radius,
                     hole_diameter, hole_margin, font_size, bold, text_margin, layer);
}

// registration_marks vem de chaveiro-tag.scad
if (registration)
    registration_marks(grid_x0, grid_y0, grid_x1, grid_y1, min(3, sheet_margin - 1));
