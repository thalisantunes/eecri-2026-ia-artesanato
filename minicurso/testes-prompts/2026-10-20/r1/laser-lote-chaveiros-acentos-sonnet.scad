// ===== Chaveiros em lote - laser (OpenSCAD 2021.01) =====
// Camada: "cut" = so contornos e furos; "engrave" = so texto
layer = "cut";

// --- Peca (mm) ---
key_w = 70;            // largura do chaveiro
key_h = 25;            // altura do chaveiro
hole_d = 4.5;          // diametro do furo
hole_edge = 3.5;       // distancia da borda esquerda ate a borda do furo
text_margin = 3;       // distancia minima do texto ao furo e as bordas

// --- Lote ---
cols = 2;              // colunas da grade
gap = 3;               // espaco entre chaveiros
names = ["ANA", "JOÃO", "CONCEIÇÃO", "PEDRO"];  // um chaveiro por nome

// --- Texto ---
font_name = "Liberation Sans:style=Bold";  // fonte
max_text_size = 9;     // tamanho maximo da letra (altura de maiuscula, mm)
cap_per_size = 1;      // altura da maiuscula / size do OpenSCAD (aprox.)
em_per_size = 1.45;    // largura do em / size (aprox., Liberation Sans)
fit_safety = 0.95;     // fracao da faixa livre que o texto pode ocupar
adv_default = 0.722;   // avanco padrao de uma letra (em)
adv_table = [          // avancos de maiusculas (em), Liberation Sans Bold
  ["I", 0.278], ["J", 0.556], ["E", 0.667], ["P", 0.667],
  ["S", 0.667], ["V", 0.667], ["X", 0.667], ["Y", 0.667],
  ["F", 0.611], ["L", 0.611], ["T", 0.611], ["Z", 0.611],
  ["O", 0.778], ["Q", 0.778], ["G", 0.778], ["M", 0.833],
  ["W", 0.944], [" ", 0.278]
];

// --- Marcas de registro ---
reg_d = 0.6;           // diametro das marcas
reg_off = 3;           // distancia (X e Y) para fora dos cantos do lote

// --- Encaixes ---
clearance = 0.2;       // unica folga permitida, so em encaixes (nao usada aqui)

// --- Resolucao dos circulos ---
$fn = 64;

// ===== Calculos =====
n = len(names);
rows = ceil(n / cols);
batch_w = cols * key_w + (cols - 1) * gap;
batch_h = rows * key_h + (rows - 1) * gap;
hole_cx = hole_edge + hole_d / 2;
text_x_min = hole_cx + hole_d / 2 + text_margin;
text_x_max = key_w - text_margin;
text_avail = text_x_max - text_x_min;
text_cx = (text_x_min + text_x_max) / 2;

function cw(c) =
  let (m = [for (e = adv_table) if (e[0] == c) e[1]])
  len(m) > 0 ? m[0] : adv_default;

function name_em(s, i = 0) = i >= len(s) ? 0 : cw(s[i]) + name_em(s, i + 1);

function text_size(s) =
  min(max_text_size, fit_safety * text_avail / (name_em(s) * em_per_size));

// ===== Modulos =====
module key_cut() {
  difference() {
    square([key_w, key_h]);
    translate([hole_cx, key_h / 2]) circle(d = hole_d);
  }
}

module key_text(s) {
  sz = text_size(s);
  translate([text_cx, key_h / 2 - cap_per_size * sz / 2])
    text(s, size = sz, font = font_name, halign = "center", valign = "baseline");
}

module marks() {
  translate([-reg_off, -reg_off]) circle(d = reg_d);
  translate([batch_w + reg_off, batch_h + reg_off]) circle(d = reg_d);
}

module slot(i) {
  c = i % cols;
  r = floor(i / cols);
  translate([c * (key_w + gap), (rows - 1 - r) * (key_h + gap)]) children();
}

// ===== Saida =====
if (layer == "cut") {
  for (i = [0 : n - 1]) slot(i) key_cut();
  marks();
} else if (layer == "engrave") {
  for (i = [0 : n - 1]) slot(i) key_text(names[i]);
  marks();
} else {
  echo("ERRO: layer deve ser \"cut\" ou \"engrave\"");
}

// ===== Medidas =====
echo("chaveiros:", n);
echo("grade (colunas x linhas):", cols, rows);
echo("lote sem marcas (L x A mm):", batch_w, batch_h);
echo("lote com marcas (L x A mm):", batch_w + 2 * reg_off, batch_h + 2 * reg_off);
echo("faixa livre para texto (mm):", text_avail);
for (i = [0 : n - 1]) echo("nome / tamanho da letra:", names[i], text_size(names[i]));
