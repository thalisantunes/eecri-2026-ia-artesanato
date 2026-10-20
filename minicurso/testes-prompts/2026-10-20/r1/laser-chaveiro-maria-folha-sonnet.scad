// Chaveiro com nome - corte e gravacao a laser - OpenSCAD 2021.01
// Tudo em milimetros. Somente 2D.

// ---------------- PARAMETROS ----------------
layer = "cut";            // "cut" = contornos e furos | "engrave" = texto

piece_w = 70;             // largura da peca
piece_h = 25;             // altura da peca
corner_r = 4;             // raio dos cantos
hole_d = 4.5;             // diametro do furo da argola
hole_edge_left = 3.5;     // distancia da borda do furo ate a borda esquerda da peca
mat_t = 3;                // espessura do MDF (informativo, nao usada na geometria 2D)
clearance = 0;            // unica folga permitida, so para encaixes (esta peca nao tem encaixe)

name = "MARIA";           // nome a gravar
font_name = "Liberation Sans:style=Bold"; // fonte
text_margin = 3;          // distancia minima do texto ao furo e as bordas
text_size_max = 11;       // tamanho maximo da letra (altura das maiusculas aprox.)
text_size_min = 3;        // abaixo disso o aviso de texto pequeno demais aparece
em_per_size = 1.37;       // calibracao: em da fonte por unidade de size do OpenSCAD
fit_safety = 0.97;        // margem de seguranca na estimativa de largura do texto

mark_d = 0.6;             // diametro dos circulos de registro
mark_offset = 3;          // distancia dos circulos aos cantos (em X e em Y)

fn_corner = 64;           // facetas dos cantos
fn_hole = 64;             // facetas do furo
fn_mark = 24;             // facetas dos circulos de registro

// ---------------- LARGURAS DA FONTE (1/1000 em, Liberation Sans Bold) ----------------
chars_tbl = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 ";
w_tbl = [
  722,722,722,722,667,611,778,722,278,556,722,611,833,
  722,778,667,778,722,667,611,722,667,944,667,667,611,
  556,611,556,611,556,333,611,611,278,278,556,278,889,
  611,611,611,611,389,556,333,611,556,778,556,556,500,
  556,556,556,556,556,556,556,556,556,556,
  278
];

function char_w(c) = (search(c, chars_tbl) == []) ? 600 : w_tbl[search(c, chars_tbl)[0]];
function sum_w(s, i = 0) = (i >= len(s)) ? 0 : char_w(s[i]) + sum_w(s, i + 1);

// ---------------- DERIVADOS ----------------
hole_cx = hole_edge_left + hole_d / 2;
hole_cy = piece_h / 2;

text_x0 = hole_edge_left + hole_d + text_margin;   // inicio da area do texto
text_x1 = piece_w - text_margin;                   // fim da area do texto
avail_w = text_x1 - text_x0;
avail_h = piece_h - 2 * text_margin;
text_cx = (text_x0 + text_x1) / 2;

units_em = sum_w(name) / 1000 * em_per_size;       // largura do nome por unidade de size
text_size = min(text_size_max, avail_h, avail_w * fit_safety / units_em);
est_text_w = units_em * text_size;

// ---------------- MODULOS 2D ----------------
module outline() {
  hull() {
    for (x = [corner_r, piece_w - corner_r], y = [corner_r, piece_h - corner_r])
      translate([x, y]) circle(r = corner_r, $fn = fn_corner);
  }
}

module marks() {
  translate([-mark_offset, -mark_offset]) circle(d = mark_d, $fn = fn_mark);
  translate([piece_w + mark_offset, piece_h + mark_offset]) circle(d = mark_d, $fn = fn_mark);
}

module cut_layer() {
  difference() {
    outline();
    translate([hole_cx, hole_cy]) circle(d = hole_d, $fn = fn_hole);
  }
}

module engrave_layer() {
  translate([text_cx, piece_h / 2])
    text(name, size = text_size, font = font_name, halign = "center", valign = "center");
}

// ---------------- SAIDA ----------------
if (layer == "cut") {
  cut_layer();
  marks();
} else if (layer == "engrave") {
  engrave_layer();
  marks();
} else {
  echo("ERRO: layer deve ser \"cut\" ou \"engrave\"");
}

// ---------------- MEDIDAS FINAIS ----------------
echo(layer = layer);
echo(peca = [piece_w, piece_h], raio_canto = corner_r, material_mm = mat_t);
echo(furo_diametro = hole_d, furo_centro = [hole_cx, hole_cy], borda_furo_a_borda_esq = hole_edge_left);
echo(area_texto_x = [text_x0, text_x1], largura_disponivel = avail_w, altura_disponivel = avail_h);
echo(texto = name, texto_size = text_size, largura_estimada = est_text_w);
echo(folga_texto_ao_furo = (text_cx - est_text_w / 2) - (hole_edge_left + hole_d),
     folga_texto_a_borda_direita = piece_w - (text_cx + est_text_w / 2));
echo(circulos_registro = [[-mark_offset, -mark_offset], [piece_w + mark_offset, piece_h + mark_offset]], diametro = mark_d);
if (text_size < text_size_min) echo("AVISO: texto menor que o minimo legivel, considere nome mais curto ou peca maior");
