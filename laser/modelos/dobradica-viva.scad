// =====================================================================
// dobradica-viva.scad
// Tira com padrão de dobradiça viva (living hinge): fileiras de ranhuras
// alternadas que deixam a chapa dobrar sem quebrar. Unidades em
// milímetros. OpenSCAD 2021.01. Só camada "cut".
//
// COMO FUNCIONA
//   As ranhuras correm no sentido da largura (eixo Y) e a tira dobra ao
//   longo do comprimento (eixo X), em torno de um eixo paralelo às
//   ranhuras. Fileiras vizinhas ficam deslocadas meia ranhura: a ponte de
//   uma fileira cai no meio da ranhura da outra.
//
//   fileira par   (ranhuras inteiras, afastadas da borda por edge_margin):
//        <-- slot_length --><gap><-- slot_length -->
//   fileira ímpar (deslocada meia ranhura; as ranhuras das pontas
//   atravessam a borda da tira):
//   ====><-- slot_length --><gap><-- slot_length --><====
//
//   Como no FlexEdge do boxes.py, as fileiras ímpares abrem a borda: a borda
//   não vira um trilho rígido e a tira dobra em toda a largura. A tira não
//   se solta porque as fileiras pares mantêm a borda inteira. As pontas
//   rígidas (rigid_end) ficam sem ranhura.
//
// PARÂMETROS (mude aqui no topo ou com -D na linha de comando)
//   length       comprimento da tira, em mm (sentido da dobra)
//   width        largura da tira, em mm (sentido das ranhuras)
//   slot_length  comprimento de cada ranhura, em mm
//   slot_gap     ponte entre duas ranhuras da mesma fileira, em mm
//   row_spacing  distância entre fileiras (centro a centro), em mm
//   rigid_end    trecho rígido em cada ponta, sem ranhuras, em mm
//   edge_margin  borda sem ranhura, só nas fileiras pares, em mm
//   slot_width   largura desenhada da ranhura, em mm (veja o aviso)
//
// COMO EXPORTAR (só cut)
//   openscad -o dobradica-viva-cut.svg dobradica-viva.scad
//   Dobra mais fechada: -D 'row_spacing=2' -D 'slot_gap=3'
//
// AVISOS
//   - O OpenSCAD 2021.01 só exporta áreas, não linhas. Cada ranhura sai
//     como um retângulo muito fino (slot_width) e a laser percorre o
//     contorno dele: são duas passadas coladas na mesma linha. As ranhuras
//     das fileiras ímpares viram entalhes finos no contorno da tira.
//   - DESLIGUE o offset de kerf nesta camada. As ranhuras são mais finas
//     que o kerf e o software pode apagar o caminho.
//   - Ranhura mais longa e fileira mais próxima dobram mais; ponte maior
//     e fileira mais afastada seguram mais. Teste em retalho do seu
//     material: MDF quebra com facilidade, compensado de 3 mm costuma
//     dobrar melhor.
// =====================================================================

/* [Tira] */
// Comprimento da tira, em mm (sentido da dobra)
length = 100;
// Largura da tira, em mm (sentido das ranhuras)
width = 50;

/* [Padrão] */
// Comprimento de cada ranhura, em mm
slot_length = 20;
// Ponte entre duas ranhuras da mesma fileira, em mm
slot_gap = 4;
// Distância entre fileiras (centro a centro), em mm
row_spacing = 3;

/* [Avançado] */
// Trecho rígido em cada ponta, sem ranhuras, em mm
rigid_end = 10;
// Borda sem ranhura, só nas fileiras pares, em mm
edge_margin = 4;
// Largura desenhada da ranhura, em mm
slot_width = 0.1;

/* [Camada] */
// Só existe cut
layer = "cut"; // [cut]

/* [Hidden] */
period   = slot_length + slot_gap;
zone     = length - 2 * rigid_end;                    // trecho flexível (eixo X)
n_rows   = max(1, floor(zone / row_spacing) + 1);
x0       = (length - (n_rows - 1) * row_spacing) / 2; // primeira fileira, centrada
inner_w  = width - 2 * edge_margin;                   // faixa livre das fileiras pares (eixo Y)
n_even   = floor((inner_w + slot_gap) / period);      // ranhuras inteiras na fileira par
span     = n_even * period - slot_gap;
y0       = edge_margin + (inner_w - span) / 2;        // início da 1ª ranhura da fileira par
over     = 1;                                         // quanto a ranhura passa da borda, em mm

// Uma ranhura de a até b (eixo Y) na fileira de posição x
module slot(x, a, b) {
    translate([x - slot_width / 2, a]) square([slot_width, b - a]);
}

// Fileira par: ranhuras inteiras, longe da borda
module even_row(x) {
    for (k = [0 : n_even - 1])
        slot(x, y0 + k * period, y0 + k * period + slot_length);
}

// Fileira ímpar: deslocada meia ranhura, com uma ranhura a mais que a par.
// A primeira e a última passam da borda da tira (abrem a borda).
module odd_row(x) {
    for (k = [0 : n_even]) {
        a0 = y0 - period / 2 + k * period;
        slot(x, k == 0 ? -over : a0,
                k == n_even ? width + over : a0 + slot_length);
    }
}

module cut_layer() {
    difference() {
        square([length, width]);
        for (r = [0 : n_rows - 1]) {
            if (r % 2 == 0) even_row(x0 + r * row_spacing);
            else odd_row(x0 + r * row_spacing);
        }
    }
}

assert(layer == "cut", "dobradica-viva só tem a camada cut");
assert(zone > 0, "length precisa ser maior que 2 vezes rigid_end");
assert(slot_length > 0 && slot_gap > 0 && row_spacing > 0,
       "medidas inválidas: confira slot_length, slot_gap e row_spacing");
assert(n_even >= 1, "width pequena demais: cabe menos de uma ranhura inteira entre as bordas das fileiras pares");
assert(y0 + (slot_length - slot_gap) / 2 > 1,
       "ranhura curta demais para a ponte: aumente slot_length ou reduza slot_gap");

cut_layer();
