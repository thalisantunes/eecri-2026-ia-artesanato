// Porta-cartão de mesa - ATELIÊ
// Unidades: mm. Peça única, apoiada em z = 0, imprime deitada na base sem suporte.
card_w      = 90;    // largura do cartão (eixo X)
card_h      = 50;    // altura do cartão (ao longo do encosto)
card_clear  = 1;     // folga lateral por lado (eixo X)
stack_t     = 12;    // espessura da pilha de cartões
stack_clear = 0.5;   // folga perpendicular ao encosto
tilt        = 12;    // inclinação do encosto para trás (graus)
wall        = 3;     // espessura de parede, base e encosto (minimo 2)
base_t      = 3;     // espessura da base
side_t      = 3;     // espessura das laterais (eixo X)
front_h     = 28;    // altura do lábio frontal
back_len    = 58;    // comprimento do encosto ao longo da inclinação
heel_len    = 18;    // quanto a base avança para trás do encosto (pé)
heel_h      = 6;     // altura do bloco traseiro (pé)
txt         = "ATELIÊ";
txt_font    = "Liberation Sans:style=Bold";
txt_size    = 8;     // tamanho do texto
txt_depth   = 0.8;   // profundidade da gravação na frente
txt_out     = 1;     // margem extra para o corte do texto sair da face
W      = card_w + 2*card_clear + 2*side_t;   // largura total (X)
gap_p  = stack_t + stack_clear;              // vão perpendicular ao encosto
gap_h  = gap_p / cos(tilt);                  // vão horizontal na base
yi0    = wall + gap_h;                       // face interna do encosto na base
yo0    = yi0 + wall;                         // face externa do encosto na base
dz     = back_len * cos(tilt);               // subida do encosto
zt     = base_t + dz;                        // topo do encosto
yit    = yi0 + dz*tan(tilt);                 // topo, face interna
yot    = yo0 + dz*tan(tilt);                 // topo, face externa
yoh    = yo0 + (heel_h - base_t)*tan(tilt);  // face externa na altura do pé
ye     = yo0 + heel_len;                     // fim traseiro do pé
profile = [
  [0, 0], [ye, 0], [ye, heel_h], [yoh, heel_h],
  [yot, zt], [yit, zt], [yi0, base_t], [wall, base_t],
  [wall, front_h], [0, front_h]
];
side_wall = [
  [wall, 0], [yi0, 0], [yi0, base_t], [yit, zt], [wall, zt]
];
module side_extrude(pts, len) {
  rotate([90, 0, 90]) linear_extrude(height = len) polygon(pts);
}
module body() {
  side_extrude(profile, W);
  side_extrude(side_wall, side_t);
  translate([W - side_t, 0, 0]) side_extrude(side_wall, side_t);
}
module engrave() {
  translate([W/2, txt_depth, front_h/2])
    rotate([90, 0, 0])
      linear_extrude(height = txt_depth + txt_out)
        text(txt, size = txt_size, font = txt_font, halign = "center", valign = "center");
}
difference() {
  body();
  engrave();
}
depth_real  = max([for (p = profile) p[0]]);
height_real = max([for (p = profile) p[1]]);
echo("largura (mm)", W);
echo("profundidade (mm)", depth_real);
echo("altura (mm)", height_real);
