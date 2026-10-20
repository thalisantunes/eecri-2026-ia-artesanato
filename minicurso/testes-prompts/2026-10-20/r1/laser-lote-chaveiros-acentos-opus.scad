// ================== PARAMETERS (all values in mm) ==================
layer = "cut";            // "cut" = contornos e furos; "engrave" = so o texto
names = ["ANA", "JOÃO", "CONCEIÇÃO", "PEDRO"]; // um chaveiro por nome

tag_w = 70;               // largura de cada chaveiro
tag_h = 25;               // altura de cada chaveiro
hole_d = 4.5;             // diametro do furo
hole_edge = 3.5;          // da borda esquerda ate a borda do furo
text_margin = 3;          // distancia minima do nome ao furo e as bordas

columns = 2;              // colunas da grade
gap = 3;                  // espaco entre chaveiros

font_name = "Liberation Sans:style=Bold"; // fonte
text_size_max = 9;        // tamanho maximo da letra
char_w_factor = 0.80;     // largura estimada de cada letra, em fracao do size (sem textmetrics)
text_h_factor = 1.25;     // altura estimada do nome com til e cedilha, em fracao do size

clearance = 0;            // folga de encaixe (sem uso: esta peca nao tem encaixe)

mark_d = 0.6;             // diametro das marcas de registro
mark_offset = 3;          // distancia das marcas para fora dos cantos do lote, em X e em Y

$fn = 64;                 // resolucao dos circulos

// ================== DERIVED VALUES ==================
assert(layer == "cut" || layer == "engrave", "layer deve ser \"cut\" ou \"engrave\"");

n       = len(names);
cols    = min(columns, n);
rows    = ceil(n / columns);
batch_w = cols * tag_w + (cols - 1) * gap;
batch_h = rows * tag_h + (rows - 1) * gap;

hole_x = hole_edge + hole_d / 2;
hole_y = tag_h / 2;

text_x0      = hole_edge + hole_d + text_margin;
text_x1      = tag_w - text_margin;
text_avail_w = text_x1 - text_x0;
text_avail_h = tag_h - 2 * text_margin;
text_cx      = (text_x0 + text_x1) / 2;
text_cy      = tag_h / 2;

function name_size(s) = min(text_size_max,
                             text_avail_w / (len(s) * char_w_factor),
                             text_avail_h / text_h_factor);

function name_est_w(s) = len(s) * char_w_factor * name_size(s);

// first name at top-left, row by row
function tag_pos(i) = [ (i % columns) * (tag_w + gap),
                        (rows - 1 - floor(i / columns)) * (tag_h + gap) ];

// ================== MODULES ==================
module tag_cut() {
    difference() {
        square([tag_w, tag_h]);
        translate([hole_x, hole_y]) circle(d = hole_d);
    }
}

module tag_engrave(s) {
    translate([text_cx, text_cy])
        text(s, size = name_size(s), font = font_name,
             halign = "center", valign = "center");
}

module registration_marks() {
    translate([-mark_offset, -mark_offset]) circle(d = mark_d);
    translate([batch_w + mark_offset, batch_h + mark_offset]) circle(d = mark_d);
}

// ================== OUTPUT ==================
for (i = [0 : n - 1])
    translate(tag_pos(i)) {
        if (layer == "cut")     tag_cut();
        if (layer == "engrave") tag_engrave(names[i]);
    }

registration_marks();

// ================== REPORT ==================
echo(str("Camada: ", layer));
echo(str("Chaveiros: ", n, " (", cols, " colunas x ", rows, " linhas)"));
echo(str("Chaveiro: ", tag_w, " x ", tag_h, " mm"));
echo(str("Furo: d=", hole_d, " mm, centro em (", hole_x, ", ", hole_y, ") de cada chaveiro"));
echo(str("Area do nome: ", text_avail_w, " x ", text_avail_h, " mm, de x=", text_x0, " a x=", text_x1));
echo(str("Lote (pecas): ", batch_w, " x ", batch_h, " mm"));
echo(str("Lote (centro a centro das marcas): ", batch_w + 2 * mark_offset, " x ", batch_h + 2 * mark_offset, " mm"));
echo(str("Marcas: d=", mark_d, " mm em (", -mark_offset, ", ", -mark_offset, ") e (",
         batch_w + mark_offset, ", ", batch_h + mark_offset, ")"));
for (i = [0 : n - 1])
    echo(str("Nome ", i + 1, ": ", names[i], " | size=", name_size(names[i]), " mm | largura estimada=", name_est_w(names[i]), " mm de ", text_avail_w));
