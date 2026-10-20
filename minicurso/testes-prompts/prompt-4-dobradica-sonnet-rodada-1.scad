// Tira de MDF 3 mm com dobradica viva (fendas finas e paralelas)
// OpenSCAD 2021.01 | saida 2D | unidades em mm | sem compensacao de kerf
// Exportar duas vezes: layer cut (contorno e fendas) e layer engrave (so as marcas)
//
// Premissas desta peca:
// - a tira ocupa x de 0 a length e y de 0 a width; as fendas correm ao longo de y
//   e as fileiras se sucedem ao longo de x (sentido da dobra)
// - em cada fileira a primeira fenda comeca em y = edge_margin e as demais se
//   repetem a cada (slot_length + slot_gap); fileiras vizinhas deslocam meio periodo
// - fenda cortada pela margem lateral e encurtada; se sobrar menos que
//   min_slot_length ela e descartada
// - cada fenda fica inteira dentro da zona flexivel e as fileiras ficam centralizadas
//   nela, entao a ponta rigida real e maior ou igual a rigid_end (ver echo)
// - a peca nao tem gravacao: na camada engrave so existem as marcas de registro

// ---------------- Parametros ----------------

// camada exportada: cut = contorno e fendas, engrave = gravacao (sem unidade)
layer = "cut"; // [cut, engrave]
registration = true; // liga as marcas de registro nas duas camadas (booleano)

length = 80;         // comprimento da tira, no sentido da dobra (mm)
width = 50;          // largura da tira, no sentido das fendas (mm)
slot_length = 15;    // comprimento de cada fenda (mm)
slot_gap = 3;        // material inteiro entre duas fendas da mesma fileira (mm)
row_spacing = 2.5;   // distancia entre fileiras de fendas, centro a centro (mm)
rigid_end = 10;      // trecho rigido minimo em cada ponta, sem fendas (mm)
edge_margin = 4;     // faixa sem fenda junto as bordas laterais (mm)
slot_width = 0.1;    // largura do retangulo de cada fenda (mm)
corner_radius = 3;   // raio dos cantos da tira (mm)
min_slot_length = 1; // fenda encurtada pela margem some se ficar menor que isto (mm)

reg_diameter = 0.6;  // diametro das marcas de registro (mm)
reg_offset = 3;      // distancia das marcas aos cantos da area da peca, em x e em y (mm)
reg_fn = 16;         // segmentos do circulo das marcas de registro (adimensional)
$fn = 64;            // segmentos dos demais circulos e arcos (adimensional)

/* [Hidden] */

// ---------------- Valores calculados (nao editar) ----------------

period = slot_length + slot_gap;                  // periodo das fendas ao longo de y (mm)
half_period = period / 2;                         // deslocamento entre fileiras vizinhas (mm)
slot_y_min = edge_margin;                         // menor y permitido para uma fenda (mm)
slot_y_max = width - edge_margin;                 // maior y permitido para uma fenda (mm)
k_max = ceil((slot_y_max - slot_y_min) / period); // maior indice de fenda a testar (adimensional)
flex_length = length - 2 * rigid_end;             // zona flexivel entre as pontas rigidas (mm)
n_rows = max(0, floor((flex_length - slot_width) / row_spacing) + 1); // numero de fileiras (adimensional)
first_row_x = length / 2 - (n_rows - 1) * row_spacing / 2;            // x do centro da primeira fileira (mm)
last_row_x = first_row_x + (n_rows - 1) * row_spacing;                // x do centro da ultima fileira (mm)
frame_extra = registration ? 2 * reg_offset + reg_diameter : 0;       // acrescimo do quadro pelas marcas (mm)

// Segmentos [y_inicio, y_fim] das fendas de uma fileira, ja encurtados pela
// margem lateral e filtrados por min_slot_length; shift = 0 ou meio periodo
function row_slots(shift) = [
    for (k = [-1 : k_max])
        let (start = slot_y_min + shift + k * period,
             s = max(slot_y_min, start),
             e = min(slot_y_max, start + slot_length))
        if (e - s >= min_slot_length) [s, e]
];

slots_a = row_slots(0);                 // fileiras A (indices 0, 2, 4): sem deslocamento
slots_b = row_slots(half_period);       // fileiras B (indices 1, 3, 5): deslocadas meio periodo
rows_a = ceil(n_rows / 2);              // quantidade de fileiras A (adimensional)
rows_b = floor(n_rows / 2);             // quantidade de fileiras B (adimensional)
total_slots = rows_a * len(slots_a) + rows_b * len(slots_b); // total de fendas (adimensional)

// ---------------- Geometria ----------------

// contorno da tira: retangulo com cantos arredondados por offset
module outline() {
    offset(r = corner_radius)
        translate([corner_radius, corner_radius])
            square([length - 2 * corner_radius, width - 2 * corner_radius]);
}

// todas as fendas: uma fileira por posicao em x, fileiras B deslocadas em y
module slots() {
    for (r = [0 : n_rows - 1]) {
        shift = (r % 2) * half_period;
        for (seg = row_slots(shift))
            translate([first_row_x + r * row_spacing - slot_width / 2, seg[0]])
                square([slot_width, seg[1] - seg[0]]);
    }
}

// duas marcas de registro nos cantos opostos da area ocupada pela tira
module registration_marks() {
    translate([-reg_offset, -reg_offset])
        circle(d = reg_diameter, $fn = reg_fn);
    translate([length + reg_offset, width + reg_offset])
        circle(d = reg_diameter, $fn = reg_fn);
}

// ---------------- Saida ----------------

assert(layer == "cut" || layer == "engrave", "layer deve ser cut ou engrave");
assert(width > 2 * edge_margin, "width deve ser maior que 2 * edge_margin");
assert(n_rows >= 1, "nenhuma fileira cabe entre os trechos rigidos");

if (layer == "cut") {
    difference() {
        outline();
        slots();
    }
}

if (registration) registration_marks();

// ---------------- Conferencia ----------------

echo(str("camada exportada: ", layer));
echo(str("peca (tira): x = ", length, " mm, y = ", width, " mm"));
echo(str("quadro total com marcas: x = ", length + frame_extra, " mm, y = ", width + frame_extra, " mm"));
if (registration) echo(str("marcas de registro (centros): (", -reg_offset, ", ", -reg_offset, ") e (", length + reg_offset, ", ", width + reg_offset, ") mm"));
echo(str("fileiras: ", n_rows, " (A sem deslocamento: ", rows_a, "; B deslocadas meio periodo: ", rows_b, "); passo = ", row_spacing, " mm"));
echo(str("fendas por fileira: A = ", len(slots_a), ", B = ", len(slots_b), "; total = ", total_slots));
echo(str("periodo = ", period, " mm; x da primeira fileira = ", first_row_x, " mm; da ultima = ", last_row_x, " mm"));
echo(str("ponta rigida real = ", first_row_x - slot_width / 2, " mm (minimo pedido: ", rigid_end, " mm)"));
echo("fendas da fileira A [y_ini, y_fim] em mm:", slots_a);
echo("fendas da fileira B [y_ini, y_fim] em mm:", slots_b);
