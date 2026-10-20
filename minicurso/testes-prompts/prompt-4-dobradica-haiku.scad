// Tira de dobradica viva em MDF de 3 mm - OpenSCAD 2021.01
// Todas as dimensoes em mm. A compensacao de kerf fica no software de corte.

// camada de exportacao: esta peca tem so a camada de corte
layer = "cut"; // [cut]

// ---- parametros ----
length = 80;        // comprimento da tira no sentido da dobra (eixo X), mm
width = 50;         // largura da tira no sentido das fendas (eixo Y), mm
slot_length = 15;   // comprimento de cada fenda (eixo Y), mm
slot_gap = 3;       // ponte de material inteiro entre duas fendas da mesma fileira, mm
row_spacing = 2.5;  // distancia entre fileiras de fendas, centro a centro (eixo X), mm
rigid_end = 10;     // trecho rigido em cada ponta, sem fendas (eixo X), mm
edge_margin = 4;    // borda sem fenda nas fileiras pares (eixo Y), mm
slot_width = 0.1;   // largura desenhada de cada fenda (eixo X), mm
overshoot = 1;      // quanto as fendas das pontas passam da borda nas fileiras impares, mm

// ---- medidas auxiliares (calculadas, nao editar) ----
n_rows = floor((length - 2 * rigid_end) / row_spacing) + 1;      // numero de fileiras de fendas
x0 = (length - (n_rows - 1) * row_spacing) / 2;                  // X da primeira fileira, mm
period = slot_length + slot_gap;                                 // passo entre fendas da mesma fileira, mm
inner_w = width - 2 * edge_margin;                               // largura entre as bordas sem fenda, mm
n_even = floor((inner_w + slot_gap) / period);                   // fendas inteiras por fileira par
y0 = edge_margin + (inner_w - (n_even * period - slot_gap)) / 2; // Y da primeira fenda da fileira par, mm
total_slots = ceil(n_rows / 2) * n_even + floor(n_rows / 2) * (n_even + 1); // total de fendas

// ---- geometria 2D (somente corte) ----
if (layer == "cut") {
  difference() {
    square([length, width]); // tira inteira, canto em (0, 0)
    for (r = [0 : n_rows - 1]) {
      x_row = x0 + r * row_spacing; // X do centro da fileira r, mm
      if (r % 2 == 0) {
        // fileira par: n_even fendas inteiras, borda inteira
        for (k = [0 : n_even - 1]) {
          translate([x_row - slot_width / 2, y0 + k * period])
            square([slot_width, slot_length]);
        }
      } else {
        // fileira impar: n_even + 1 fendas; a primeira e a ultima abrem a borda
        for (k = [0 : n_even]) {
          a0 = y0 - period / 2 + k * period;                            // inicio nominal da fenda k, mm
          y_start = (k == 0) ? -overshoot : a0;                         // primeira fenda passa da borda inferior
          y_end = (k == n_even) ? width + overshoot : a0 + slot_length; // ultima passa da borda superior
          translate([x_row - slot_width / 2, y_start])
            square([slot_width, y_end - y_start]);
        }
      }
    }
  }
}

// ---- conferencia no console ----
// esperado com os valores iniciais: n_rows = 25, n_even = 2, 2 fendas (par) e 3 (impar), 62 fendas no total, 80 x 50 mm
echo(n_rows = n_rows, n_even = n_even);
echo(slots_even_row = n_even, slots_odd_row = n_even + 1, total_slots = total_slots);
echo(total_X_mm = length, total_Y_mm = width);
