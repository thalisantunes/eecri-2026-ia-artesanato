// ===== Parametros (todos em mm, exceto contagens e $fn) =====

layer = "cut";                  // "cut" = so contornos e furos; "engrave" = so o texto gravado
piece_w = 70;                   // largura do chaveiro
piece_h = 25;                   // altura do chaveiro
hole_d = 4.5;                   // diametro do furo
hole_edge = 3.5;                // distancia da borda esquerda ate a borda do furo
hole_cy = piece_h / 2;          // centro do furo na altura (centralizado)
margin = 3;                     // distancia minima do nome ao furo e as bordas
gap = 3;                        // espaco entre chaveiros no lote
cols = 2;                       // colunas da grade
reg_d = 0.6;                    // diametro das marcas de registro
reg_off = 3;                    // deslocamento de cada marca em X e em Y a partir do canto do lote
text_size = 8;                  // tamanho nominal do texto
text_width_safety = 1.1;        // folga sobre a largura estimada do texto
hole_fn = 96;                   // suavidade do furo
reg_fn = 48;                    // suavidade das marcas de registro
font_name = "Liberation Sans:style=Bold";

names = ["ANA", "JOÃO", "CONCEIÇÃO", "PEDRO"];
n = len(names);

// Largura de avanco (Arial Bold, por 1000 em) das maiusculas e do espaco
ch_set = "ABCDEFGHIJKLMNOPQRSTUVWXYZ ";
ch_adv = [722,722,722,722,667,611,778,722,278,556,722,611,833,722,778,667,778,722,667,611,722,667,944,667,667,611,278];
adv_default = 722;              // acentos (Ç, Ã) e caracteres fora da tabela

// ===== Derivados =====

hole_r = hole_d / 2;
hole_cx = hole_edge + hole_r;
text_x0 = hole_edge + hole_d + margin;
text_x1 = piece_w - margin;
text_max_w = text_x1 - text_x0;
text_max_h = piece_h - 2 * margin;
cols_used = min(cols, n);
rows = ceil(n / cols);
lot_w = cols_used * piece_w + (cols_used - 1) * gap;
lot_h = rows * piece_h + (rows - 1) * gap;

// ===== Funcoes de medida do texto =====

function char_adv(c) = len(search(c, ch_set)) > 0 ? ch_adv[search(c, ch_set)[0]] : adv_default;
function text_adv(s, i = 0) = i >= len(s) ? 0 : char_adv(s[i]) + text_adv(s, i + 1);
function est_w(s) = text_adv(s) / 1000 * text_size * text_width_safety;
function fit(s) = min(1, text_max_w / est_w(s), text_max_h / text_size);
function slot(i) = [(i % cols) * (piece_w + gap), floor(i / cols) * (piece_h + gap)];

// ===== Modulos 2D =====

module keychain_outline() {
  difference() {
    square([piece_w, piece_h]);
    translate([hole_cx, hole_cy]) circle(d = hole_d, $fn = hole_fn);
  }
}

module name_text(s) {
  translate([text_x0, hole_cy])
    text(s, size = text_size * fit(s), font = font_name, halign = "left", valign = "center");
}

module reg_marks() {
  translate([-reg_off, -reg_off]) circle(d = reg_d, $fn = reg_fn);
  translate([lot_w + reg_off, lot_h + reg_off]) circle(d = reg_d, $fn = reg_fn);
}

// ===== Saida =====

if (layer == "cut") {
  union() {
    for (i = [0 : n - 1]) translate(slot(i)) keychain_outline();
    reg_marks();
  }
} else if (layer == "engrave") {
  union() {
    for (i = [0 : n - 1]) translate(slot(i)) name_text(names[i]);
    reg_marks();
  }
} else {
  echo("layer invalido: use cut ou engrave");
}

// ===== Medidas finais =====

echo(str("Chaveiros no lote: ", n));
echo(str("Chaveiro: ", piece_w, " x ", piece_h, " mm"));
echo(str("Furo: diametro ", hole_d, " mm, centro em x=", hole_cx, " y=", hole_cy, " mm"));
echo(str("Area do nome: x de ", text_x0, " a ", text_x1, " mm (largura ", text_max_w, " mm)"));
echo(str("Lote: ", lot_w, " x ", lot_h, " mm (", cols_used, " colunas x ", rows, " linhas, espaco ", gap, " mm)"));
echo(str("Marcas de registro: centros em [", -reg_off, ", ", -reg_off, "] e [", lot_w + reg_off, ", ", lot_h + reg_off, "] mm, diametro ", reg_d, " mm"));
for (i = [0 : n - 1])
  echo(str("Nome ", names[i], ": tamanho ", text_size * fit(names[i]), " mm, largura estimada ", est_w(names[i]) * fit(names[i]), " mm"));
