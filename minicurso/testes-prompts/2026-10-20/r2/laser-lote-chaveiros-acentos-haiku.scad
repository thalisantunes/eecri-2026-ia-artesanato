// Chaveiro em lote - OpenSCAD 2021.01
// Tudo em mm. Só 2D. Sem bibliotecas.

// ===== Camada =====
layer = "cut";                  // "cut" = contornos e furos | "engrave" = nomes gravados

// ===== Chaveiro =====
piece_w = 70;                   // largura do chaveiro (mm)
piece_h = 25;                   // altura do chaveiro (mm)
hole_d = 4.5;                   // diâmetro do furo (mm)
hole_r = hole_d / 2;            // raio do furo (mm)
hole_edge = 3.5;                // distância da borda esquerda até a borda do furo (mm)
hole_cx = hole_edge + hole_r;   // centro X do furo = 5.75 mm
hole_cy = piece_h / 2;          // centro Y do furo, centralizado na altura = 12.5 mm

// ===== Nomes =====
font = "Liberation Sans:style=Bold";
names = ["ANA", "JOÃO", "CONCEIÇÃO", "PEDRO"];
name_margin = 3;                              // folga mínima do nome até o furo e até as bordas (mm)
max_letter_size = 8;                          // teto do tamanho da letra (mm)
name_x0 = hole_cx + hole_r + name_margin;     // início da área livre do nome = 11 mm
name_x1 = piece_w - name_margin;              // fim da área livre do nome = 67 mm
name_free_w = name_x1 - name_x0;              // largura livre do nome = 56 mm

// ===== Lote =====
cols = 2;                       // colunas da grade
gap = 3;                        // espaço entre chaveiros (mm)
reg_d = 0.6;                    // diâmetro das marcas de registro (mm)
reg_offset = 3;                 // distância das marcas aos cantos do lote (mm)
clearance = 0;                  // folga de encaixe (mm); não usada, o chaveiro não tem encaixe

// ===== Cálculos =====
n = len(names);                             // número de chaveiros
rows = ceil(n / cols);                      // linhas da grade
lot_w = cols * piece_w + (cols - 1) * gap;  // largura do lote = 143 mm
lot_h = rows * piece_h + (rows - 1) * gap;  // altura do lote = 53 mm

function letter_size(s) = min(max_letter_size, name_free_w / len(s));
function fmt(x) = round(x * 100) / 100;
function px(i) = (i % cols) * (piece_w + gap);
function py(i) = floor(i / cols) * (piece_h + gap);

// ===== Módulos 2D =====
module piece_outline() {
    difference() {
        square([piece_w, piece_h]);
        translate([hole_cx, hole_cy]) circle(d = hole_d, $fn = 96);
    }
}

module name_text(s) {
    translate([name_x0, hole_cy])
        text(s, size = letter_size(s), font = font, halign = "left", valign = "center");
}

module reg_marks() {
    translate([-reg_offset, -reg_offset]) circle(d = reg_d, $fn = 24);
    translate([lot_w + reg_offset, lot_h + reg_offset]) circle(d = reg_d, $fn = 24);
}

// ===== Saída por camada =====
if (layer == "cut") {
    for (i = [0 : n - 1]) translate([px(i), py(i)]) piece_outline();
    reg_marks();
} else if (layer == "engrave") {
    for (i = [0 : n - 1]) translate([px(i), py(i)]) name_text(names[i]);
    reg_marks();
}

// ===== Medidas =====
for (i = [0 : n - 1])
    echo(str("Nome ", names[i], ": tamanho da letra = ", fmt(letter_size(names[i])), " mm"));
echo(str("Chaveiros no lote: ", n));
echo(str("Tamanho do lote: ", lot_w, " x ", lot_h, " mm"));
echo(str("Chaveiro: ", piece_w, " x ", piece_h, " mm; furo d = ", hole_d, " mm em X = ", hole_cx, " Y = ", hole_cy));
echo(str("Area livre do nome: X de ", name_x0, " a ", name_x1, " mm (largura ", name_free_w, " mm)"));
echo(str("Camada: ", layer));
