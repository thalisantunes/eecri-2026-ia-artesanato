// =====================================================================
// Lote de chaveiros com nome - laser (OpenSCAD 2021.01, só 2D, mm)
// =====================================================================

// ---------- Parâmetros (todos os números ficam aqui) ----------
layer      = "cut";        // "cut" = contornos e furos | "engrave" = texto
names      = ["ANA", "JOÃO", "CONCEIÇÃO", "PEDRO"]; // um chaveiro por nome
tag_w      = 70;           // largura de cada chaveiro
tag_h      = 25;           // altura de cada chaveiro
hole_d     = 4.5;          // diâmetro do furo da argola
hole_edge  = 3.5;          // distância da borda do furo à borda esquerda
text_gap   = 3;            // distância mínima do nome ao furo e às bordas
max_letter = 8;            // tamanho máximo da letra
cols       = 2;            // colunas da grade
gap        = 3;            // espaço entre chaveiros vizinhos
font       = "Liberation Sans:style=Bold"; // fonte do nome
mark_d     = 0.6;          // diâmetro das marcas de registro
mark_off   = 3;            // afastamento das marcas para fora do canto (em X e em Y)
clearance  = 0;            // folga de encaixe (não usada: esta peça não tem encaixes)
half       = 0.5;          // fator para achar o meio de uma medida
$fn        = 64;           // resolução dos círculos

// ---------- Derivados ----------
hole_cx = hole_edge + hole_d * half;     // centro do furo (X)
hole_cy = tag_h * half;                  // furo centralizado na altura

free_x0 = hole_edge + hole_d + text_gap; // início da área livre para o nome
free_x1 = tag_w - text_gap;              // fim da área livre para o nome
free_w  = free_x1 - free_x0;             // largura livre para o nome
free_h  = tag_h - 2 * text_gap;          // altura livre para o nome
text_cx = free_x0 + free_w * half;       // centro da área do nome (X)
text_cy = tag_h * half;                  // centro da área do nome (Y)

n        = len(names);
used_cols = min(cols, n);
rows     = ceil(n / cols);
lot_w    = used_cols * tag_w + (used_cols - 1) * gap;
lot_h    = rows * tag_h + (rows - 1) * gap;

function letter_size(s) = min(max_letter, free_w / len(s));
function tag_pos(i) = [ (i % cols) * (tag_w + gap),
                        (rows - 1 - floor(i / cols)) * (tag_h + gap) ];

assert(layer == "cut" || layer == "engrave", "layer deve ser \"cut\" ou \"engrave\"");

// ---------- Medidas ----------
echo(str("Chaveiro: ", tag_w, " x ", tag_h, " mm"));
echo(str("Furo: d=", hole_d, " mm, centro em (", hole_cx, ", ", hole_cy, ")"));
echo(str("Área livre do nome: ", free_w, " x ", free_h, " mm (x de ", free_x0, " a ", free_x1, ")"));
for (i = [0 : n - 1])
    echo(str("Nome '", names[i], "': ", len(names[i]), " letras, letra = ", letter_size(names[i]), " mm"));
echo(str("Quantidade de chaveiros: ", n, " (", used_cols, " colunas x ", rows, " linhas)"));
echo(str("Lote: ", lot_w, " x ", lot_h, " mm"));
echo(str("Marcas de registro: d=", mark_d, " mm em (", -mark_off, ", ", -mark_off, ") e (",
         lot_w + mark_off, ", ", lot_h + mark_off, ")"));

// ---------- Módulos ----------
module tag_cut() {
    difference() {
        square([tag_w, tag_h]);
        translate([hole_cx, hole_cy]) circle(d = hole_d);
    }
}

module tag_engrave(s) {
    translate([text_cx, text_cy])
        text(s, size = letter_size(s), font = font,
             halign = "center", valign = "center");
}

module registration_marks() {
    translate([-mark_off, -mark_off])               circle(d = mark_d);
    translate([lot_w + mark_off, lot_h + mark_off]) circle(d = mark_d);
}

// ---------- Saída ----------
for (i = [0 : n - 1])
    translate(tag_pos(i)) {
        if (layer == "cut")     tag_cut();
        if (layer == "engrave") tag_engrave(names[i]);
    }

registration_marks();
