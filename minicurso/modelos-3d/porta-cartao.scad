// porta-cartao.scad
// Porta-cartao de mesa para impressao 3D (banca de feira, balcao, loja).
// Oficina de sabado do I EECri 2026 (07/11/2026), demonstracao de IA para 3D.
// OpenSCAD 2021.01, sem bibliotecas. Unidades em milimetros.
//
// Imprime apoiado na base, sem suporte: a frente e vertical e o
// encosto inclina tilt graus para tras (inclinacao pequena, sem balanco).
// O texto e gravado (afundado) na frente.
//
// Exportar:
//   openscad -o porta-cartao.stl porta-cartao.scad
//   openscad -D 'label="DOCES DA ANA"' -o porta-cartao-ana.stl porta-cartao.scad
// Depois: abrir o STL no fatiador da impressora e fatiar com o material do laboratorio.

// ---------- Parametros ----------
card_width  = 90;    // largura do cartao, mm (cartao de visita comum: 90 x 50)
clearance   = 1.5;   // folga total na largura do bolso, mm
stack       = 12;    // espessura da pilha de cartoes que cabe no bolso, mm
wall        = 3;     // espessura das paredes, mm
base        = 3;     // espessura do fundo, mm
front_height = 16;   // altura da frente, mm
back_height = 36;    // altura do encosto, mm
tilt        = 12;    // inclinacao do encosto para tras, graus
foot        = 10;    // pe atras do encosto, para nao tombar, mm
label       = "ATELIÊ";  // texto gravado na frente ("" = sem texto)
font_size   = 8;     // tamanho desejado das letras, mm
bold        = true;  // negrito
text_depth  = 0.8;   // profundidade da gravacao do texto, mm
text_margin = 6;     // margem lateral do texto, mm

// ---------- Contas ----------
t = tan(tilt);
inner_w = card_width + clearance;          // largura do bolso
total_w = inner_w + 2 * wall;              // largura total
total_d = 2 * wall + stack + foot;         // profundidade da base
text_w  = total_w - 2 * text_margin;       // largura livre para o texto
size_final = len(label) > 0 ? min(font_size, text_w / len(label)) : 0;
font = bold ? "Liberation Sans:style=Bold" : "Liberation Sans";

echo(str("porta-cartao: ", total_w, " x ", total_d, " x ", back_height, " mm (largura x profundidade x altura)"));
echo(str("bolso: ", inner_w, " mm de largura, ", stack, " mm de pilha; texto com tamanho ", size_final));

// perfil lateral (Y para tras, Z para cima), ja com o bolso
module profile() {
    polygon([
        [0, 0],
        [total_d, 0],
        [total_d, base],
        [2 * wall + stack + t * base, base],
        [2 * wall + stack + t * back_height, back_height],
        [wall + stack + t * (back_height - base), back_height],
        [wall + stack, base],
        [wall, base],
        [wall, front_height],
        [0, front_height]
    ]);
}

// laterais: fecham o bolso ate a altura da frente
module cheek_profile() {
    polygon([
        [0, 0],
        [2 * wall + stack, 0],
        [2 * wall + stack + t * front_height, front_height],
        [0, front_height]
    ]);
}

module body() {
    rotate([90, 0, 90]) linear_extrude(height = total_w) profile();
    for (x = [0, total_w - wall])
        translate([x, 0, 0]) rotate([90, 0, 90]) linear_extrude(height = wall) cheek_profile();
}

difference() {
    body();
    if (len(label) > 0)
        translate([total_w / 2, text_depth, front_height / 2 + base / 2])
            rotate([90, 0, 0])
                linear_extrude(height = text_depth + 1)
                    text(label, size = size_final, font = font, halign = "center", valign = "center");
}
