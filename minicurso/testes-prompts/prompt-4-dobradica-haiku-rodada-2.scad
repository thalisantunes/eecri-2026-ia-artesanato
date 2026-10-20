// ------------------------------------------------------------
// Tira de MDF 3 mm com dobradica viva (fendas paralelas)
// OpenSCAD 2021.01 - so 2D no topo - unidades em mm
// ------------------------------------------------------------

// Camada: cut = contorno menos fendas, mais marcas; engrave = so marcas (texto, sem unidade)
layer = "cut"; // [cut, engrave]
// Marcas de registro nas duas camadas (booleano, sem unidade)
registration = true;

// Tira
length = 80; // comprimento da tira, mm, no sentido da dobra
width = 50; // largura da tira, mm, no sentido das fendas
corner_radius = 3; // raio dos cantos externos da tira, mm
rigid_end = 10; // mm rigidos em cada ponta, sem fendas, mm
edge_margin = 4; // mm sem fenda junto as bordas laterais, mm

// Fendas
slot_length = 15; // comprimento de cada fenda, mm
slot_gap = 3; // mm de material inteiro entre duas fendas da mesma fileira, mm
row_spacing = 2.5; // distancia entre fileiras de fendas, centro a centro, mm
slot_width = 0.1; // largura do retangulo de cada fenda, mm
min_slot_piece = 1; // menor trecho de fenda cortada pela margem que ainda existe, mm

// Resolucao dos circulos e marcas de registro
circle_fn = 64; // $fn dos circulos e dos cantos arredondados (sem unidade)
$fn = circle_fn; // resolucao padrao aplicada a offset() e circle() (sem unidade)
mark_diameter = 0.6; // diametro das marcas de registro, mm
mark_fn = 16; // $fn das marcas de registro (sem unidade)
mark_offset = 3; // distancia de cada marca ao canto da peca, em X e em Y, mm

// Valores derivados (calculados, nao editar)
slot_pitch = slot_length + slot_gap; // passo entre fendas da mesma fileira, mm
phase_even = 0; // deslocamento das fileiras pares, mm
phase_odd = slot_pitch / 2; // deslocamento das fileiras impares (meio periodo), mm
mark_radius = mark_diameter / 2; // raio das marcas de registro, mm
row_count = floor((length - 2 * rigid_end) / row_spacing); // numero de fileiras (sem unidade)
slot_candidates = floor(width / slot_pitch) + 2; // candidatos de fenda por fileira (sem unidade)
even_row_count = floor((row_count + 1) / 2); // fileiras pares (sem unidade)
odd_row_count = floor(row_count / 2); // fileiras impares (sem unidade)
slots_even = count_slots(0, phase_even); // fendas por fileira par (sem unidade)
slots_odd = count_slots(0, phase_odd); // fendas por fileira impar (sem unidade)
total_slots = even_row_count * slots_even + odd_row_count * slots_odd; // total de fendas (sem unidade)
total_width = length + 2 * (mark_offset + mark_radius); // largura do quadro com marcas, mm
total_height = width + 2 * (mark_offset + mark_radius); // altura do quadro com marcas, mm

// Funcoes das fendas (mm)
// inicio candidato da fenda k numa fileira com deslocamento phase
function cand_start(k, phase) = edge_margin + phase + (k - 1) * slot_pitch;
// trecho da fenda depois de cortar pelas margens laterais
function piece_start(k, phase) = max(cand_start(k, phase), edge_margin);
function piece_end(k, phase) = min(cand_start(k, phase) + slot_length, width - edge_margin);
// a fenda existe se sobrar pelo menos min_slot_piece
function piece_ok(k, phase) = (piece_end(k, phase) - piece_start(k, phase)) >= min_slot_piece;
// conta as fendas validas de uma fileira
function count_slots(k, phase) = (k > slot_candidates) ? 0 : ((piece_ok(k, phase) ? 1 : 0) + count_slots(k + 1, phase));
// fileira i: posicao X do centro e deslocamento
function row_x(i) = rigid_end + row_spacing / 2 + i * row_spacing;
function row_phase(i) = (i % 2 == 0) ? phase_even : phase_odd;

// Contorno arredondado (2D)
module outline() {
  offset(r = corner_radius)
    translate([corner_radius, corner_radius])
      square([length - 2 * corner_radius, width - 2 * corner_radius]);
}

// Todas as fendas (2D): retangulos finos paralelos ao lado de tamanho width
module slots() {
  for (i = [0 : row_count - 1]) {
    for (k = [0 : slot_candidates]) {
      if (piece_ok(k, row_phase(i)))
        translate([row_x(i) - slot_width / 2, piece_start(k, row_phase(i))])
          square([slot_width, piece_end(k, row_phase(i)) - piece_start(k, row_phase(i))]);
    }
  }
}

// Marcas de registro (2D)
module registration_marks() {
  // centro 3 mm abaixo e 3 mm a esquerda do canto inferior esquerdo da peca
  translate([-mark_offset, -mark_offset]) circle(d = mark_diameter, $fn = mark_fn);
  // centro 3 mm acima e 3 mm a direita do canto superior direito da peca
  translate([length + mark_offset, width + mark_offset]) circle(d = mark_diameter, $fn = mark_fn);
}

// Saida por camada (2D no topo)
if (layer == "cut") {
  // contorno arredondado menos todas as fendas, mais as marcas de registro
  union() {
    difference() {
      outline();
      slots();
    }
    if (registration) registration_marks();
  }
} else if (layer == "engrave") {
  // sem gravacao: so as marcas de registro
  if (registration) registration_marks();
}

// Conferencia no console
echo(str("camada = ", layer));
echo(str("fileiras = ", row_count));
echo(str("fendas por fileira (par) = ", slots_even));
echo(str("fendas por fileira (impar) = ", slots_odd));
echo(str("total de fendas = ", total_slots));
echo(str("largura da peca, mm = ", length));
echo(str("altura da peca, mm = ", width));
echo(str("largura total com marcas, mm = ", total_width));
echo(str("altura total com marcas, mm = ", total_height));
