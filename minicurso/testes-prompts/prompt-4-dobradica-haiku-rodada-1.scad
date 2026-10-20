// Tira de MDF 3 mm com dobradica viva (fendas finas paralelas)
// OpenSCAD 2021.01, sem bibliotecas, so 2D no topo, tudo em mm

// ---------- Parametros ----------
// camada a exportar: cut = corte, engrave = gravacao
layer = "cut"; // [cut, engrave]
registration = true; // marcas de registro nas duas camadas: true = desenha, false = nao desenha
$fn = 64; // lados dos circulos e dos arcos dos cantos, adimensional
length = 80; // comprimento da tira, mm, no sentido da dobra
width = 50; // largura da tira, mm, no sentido das fendas
slot_length = 15; // comprimento de cada fenda, mm
slot_gap = 3; // material inteiro entre duas fendas da mesma fileira, mm
row_spacing = 2.5; // distancia entre fileiras de fendas, centro a centro, mm
rigid_end = 10; // trecho rigido em cada ponta, sem fendas, mm
edge_margin = 4; // faixa sem fenda junto as bordas laterais, mm
slot_width = 0.1; // largura do retangulo de cada fenda, mm
corner_radius = 3; // raio dos cantos da tira, mm
slot_phase = edge_margin; // y da primeira fenda da fileira par (ancora do padrao), mm
min_slot = 1; // menor trecho de fenda cortada pela margem que ainda fica, mm
reg_diameter = 0.6; // diametro das marcas de registro, mm
reg_offset = 3; // distancia de cada marca ao canto da area das pecas, mm
reg_fn = 16; // lados dos circulos das marcas de registro, adimensional

// ---------- Calculados (nao editar) ----------
hinge_length = length - 2*rigid_end; // trecho com fendas, mm
row_count = floor(hinge_length / row_spacing); // fileiras que cabem no trecho, adimensional
first_row_x = rigid_end + (hinge_length - (row_count - 1)*row_spacing) / 2; // x da primeira fileira, mm
period = slot_length + slot_gap; // passo das fendas dentro da fileira, mm
max_k = ceil(width / period) + 1; // faixa de indices de fenda testados, adimensional

// fileira i: x da fileira; fileiras impares deslocadas em meio periodo
function row_x(i) = first_row_x + i*row_spacing;
function row_phase(i) = (i % 2 == 0) ? slot_phase : slot_phase + period/2;

// fendas de uma fileira como [inicio, fim] em y; cortadas pela margem e descartadas se sobrar menos que min_slot
function row_slots(phase) = [
    for (k = [-max_k : max_k])
        let(
            s = phase + k*period,
            a = max(s, edge_margin),
            b = min(s + slot_length, width - edge_margin)
        )
        if (b - a >= min_slot) [a, b]
];

// ---------- Modulos 2D ----------
module outline() {
    // contorno arredondado: offset(r) faz os cantos (sem minkowski)
    offset(r = corner_radius)
        translate([corner_radius, corner_radius])
            square([length - 2*corner_radius, width - 2*corner_radius]);
}

module slot(x, a, b) {
    translate([x - slot_width/2, a])
        square([slot_width, b - a]);
}

module slots() {
    for (i = [0 : row_count - 1])
        for (s = row_slots(row_phase(i)))
            slot(row_x(i), s[0], s[1]);
}

module registration_marks() {
    translate([-reg_offset, -reg_offset])
        circle(d = reg_diameter, $fn = reg_fn);
    translate([length + reg_offset, width + reg_offset])
        circle(d = reg_diameter, $fn = reg_fn);
}

// ---------- Geometria do topo (so 2D) ----------
// camada cut: contorno menos todas as fendas
if (layer == "cut") {
    difference() {
        outline();
        slots();
    }
}

// camada engrave: nada a gravar nesta peca, so as marcas de registro

// marcas de registro: nas duas camadas
if (registration) {
    registration_marks();
}

// ---------- Conferencia (echo) ----------
echo(str("peca: largura = ", length, " mm, altura = ", width, " mm"));
if (registration) {
    echo(str("conjunto com marcas: largura = ", length + 2*reg_offset + reg_diameter, " mm, altura = ", width + 2*reg_offset + reg_diameter, " mm"));
}
echo(str("fileiras = ", row_count));
for (i = [0 : row_count - 1])
    echo(str("fileira ", i, ": ", len(row_slots(row_phase(i))), " fendas, x = ", row_x(i), " mm"));
echo(str("total de fendas = ", len([for (i = [0 : row_count - 1]) for (s = row_slots(row_phase(i))) 1])));
