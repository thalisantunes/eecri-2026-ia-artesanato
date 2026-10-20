// Tira de MDF com dobradica viva - somente camada de corte
// Resultado do teste cego do Prompt 4 da apostila (Claude Sonnet, 13/10/2026), sem edicao.
// OpenSCAD 2021.01 | unidade: mm | topo do arquivo: geometria 2D
// Eixo X = sentido da dobra (comprimento). Eixo Y = sentido das fendas (largura).
// A tira e o retangulo length x width, com um canto em (0, 0), menos todas as fendas.
//
// Valores esperados com os valores iniciais (conferir no console):
//   n_rows = 25, x0 = 10, period = 18, inner_w = 42, n_even = 2, y0 = 8.5
//   fileira par = 2 fendas, fileira impar = 3 fendas, total = 62 fendas
//   tamanho total = 80 x 50 mm

// ---------------------------------------------------------------------------
// Parametros
// ---------------------------------------------------------------------------

// camada exportada: esta peca so tem corte (sem gravacao e sem marcas de registro)
layer = "cut"; // [cut]

length      = 80;   // comprimento da tira, no sentido da dobra (eixo X), em mm
width       = 50;   // largura da tira, no sentido das fendas (eixo Y), em mm
slot_length = 15;   // comprimento de cada fenda (eixo Y), em mm
slot_gap    = 3;    // ponte de material inteiro entre duas fendas da mesma fileira, em mm
row_spacing = 2.5;  // distancia entre fileiras de fendas, centro a centro (eixo X), em mm
rigid_end   = 10;   // trecho rigido em cada ponta, sem fendas, em mm
edge_margin = 4;    // borda sem fenda nas fileiras pares (usada para contar as fendas), em mm
slot_width  = 0.1;  // largura desenhada de cada fenda (eixo X), em mm
overshoot   = 1;    // quanto as fendas das pontas passam da borda nas fileiras impares, em mm

/* [Hidden] */

// ---------------------------------------------------------------------------
// Medidas derivadas (receita)
// ---------------------------------------------------------------------------

n_rows  = floor((length - 2 * rigid_end) / row_spacing) + 1;           // numero de fileiras de fendas (quantidade)
x0      = (length - (n_rows - 1) * row_spacing) / 2;                   // posicao X da primeira fileira, em mm
x_last  = x0 + (n_rows - 1) * row_spacing;                             // posicao X da ultima fileira, em mm
period  = slot_length + slot_gap;                                      // passo das fendas ao longo de Y (fenda + ponte), em mm
inner_w = width - 2 * edge_margin;                                     // largura entre as bordas das fileiras pares, em mm
n_even  = floor((inner_w + slot_gap) / period);                        // fendas inteiras por fileira par (quantidade)
y0      = edge_margin + (inner_w - (n_even * period - slot_gap)) / 2;  // posicao Y do inicio da primeira fenda par, em mm
n_odd   = n_even + 1;                                                  // fendas por fileira impar (quantidade)

n_even_rows   = ceil(n_rows / 2);                           // fileiras pares (quantidade)
n_odd_rows    = n_rows - n_even_rows;                       // fileiras impares (quantidade)
n_slots_total = n_even_rows * n_even + n_odd_rows * n_odd;  // total de fendas (quantidade)

// ---------------------------------------------------------------------------
// Fendas
// ---------------------------------------------------------------------------

// fenda fina: slot_width no eixo X (centrada em x), de y_from ate y_to no eixo Y
module slot(x, y_from, y_to) {
    translate([x - slot_width / 2, y_from])
        square([slot_width, y_to - y_from]);
}

// fileira par: fendas inteiras; a borda da tira fica intacta
module even_row(x) {
    for (k = [0 : n_even - 1]) {
        a = y0 + k * period;
        slot(x, a, a + slot_length);
    }
}

// fileira impar: deslocada meio periodo, com uma fenda a mais.
// A primeira comeca em y = -overshoot e a ultima termina em y = width + overshoot,
// entao a fileira abre as duas bordas da tira. As pontas passam da borda mas sao
// subtraidas, entao o tamanho final continua length x width.
module odd_row(x) {
    for (k = [0 : n_even]) {
        a0     = y0 - period / 2 + k * period;
        y_from = (k == 0)      ? -overshoot        : a0;
        y_to   = (k == n_even) ? width + overshoot : a0 + slot_length;
        slot(x, y_from, y_to);
    }
}

// ---------------------------------------------------------------------------
// Saida 2D (camada de corte)
// ---------------------------------------------------------------------------

if (layer == "cut") {
    difference() {
        square([length, width]);                // contorno da tira, canto na origem
        for (r = [0 : n_rows - 1]) {
            x = x0 + r * row_spacing;           // posicao X da fileira r
            if (r % 2 == 0) even_row(x);
            else odd_row(x);
        }
    }
}

// ---------------------------------------------------------------------------
// Conferencia (console)
// ---------------------------------------------------------------------------

echo(total_length_x_mm = length, total_width_y_mm = width);
echo(n_rows = n_rows, n_even = n_even);
echo(slots_per_even_row = n_even, slots_per_odd_row = n_odd);
echo(even_rows = n_even_rows, odd_rows = n_odd_rows, slots_total = n_slots_total);
echo(x0_mm = x0, x_last_mm = x_last, period_mm = period, inner_w_mm = inner_w, y0_mm = y0);
