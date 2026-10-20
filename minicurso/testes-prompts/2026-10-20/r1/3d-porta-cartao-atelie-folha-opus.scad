// Porta-cartao de mesa - OpenSCAD 2021.01 - unidades em mm
card_w       = 90;    // largura do cartao (mm)
card_h       = 50;    // altura do cartao (mm), referencia para back_len
stack_t      = 12;    // espessura da pilha de cartoes (mm)
clear_w      = 2;     // folga total na largura do bolso (mm)
clear_t      = 1;     // folga na espessura do bolso (mm)
wall         = 3;     // espessura das paredes (mm), minimo 2
base_t       = 3;     // espessura da base (mm)
lip_h        = 15;    // altura da aba frontal acima do piso do bolso (mm)
tilt         = 12;    // inclinacao do encosto para tras (graus)
back_len     = 40;    // comprimento do encosto ao longo da inclinacao (mm)
foot_len     = 35;    // pe atras: quanto a base passa alem do encosto (mm)
gusset_h     = 25;    // altura dos reforcos traseiros (mm)
gusset_inset = 2;     // recuo do reforco em relacao ao fim do pe (mm)
txt          = "ATELIÊ";                      // texto gravado na frente
txt_font     = "Liberation Sans:style=Bold";  // fonte do texto
txt_size     = 8;     // tamanho do texto (mm)
txt_depth    = 0.8;   // profundidade da gravacao (mm)
ovl          = 0.5;   // sobreposicao entre partes para uniao limpa (mm)
cut_extra    = 1;     // excesso do corte do texto para fora da face (mm)
half         = 0.5;   // fator de centralizacao (adimensional)
rot_up       = 90;    // rotacao para colocar perfis/texto em pe (graus)
zero         = 0;     // origem (mm)

// ---------- medidas derivadas ----------
inner_w    = card_w + clear_w;                 // largura util do bolso
W          = wall + inner_w + wall;            // largura total
slot_t     = stack_t + clear_t;                // fundo do bolso no piso
back_t     = wall / cos(tilt);                 // espessura horizontal do encosto
y_back_in  = wall + slot_t;                    // face interna do encosto no piso
y_back_out = y_back_in + back_t;               // face externa do encosto no piso
rise       = back_len * cos(tilt);             // subida vertical do encosto
run        = back_len * sin(tilt);             // avanco horizontal do encosto
D          = y_back_out + foot_len;            // profundidade total
H          = base_t + rise;                    // altura total
z_lip      = base_t + lip_h;                   // topo da aba frontal
sh         = ovl * tan(tilt);                  // deslocamento da inclinacao na sobreposicao

echo(largura = W, profundidade = D, altura = H);

// perfil 2D (y, z) extrudado ao longo de X com largura w
module prism(pts, w) {
    rotate([rot_up, zero, rot_up]) linear_extrude(height = w) polygon(pts);
}

difference() {
    union() {
        // base + pe traseiro
        cube([W, D, base_t]);

        // aba frontal
        cube([W, wall, z_lip]);

        // encosto inclinado
        prism([[y_back_in  - sh,       base_t - ovl],
               [y_back_out - sh,       base_t - ovl],
               [y_back_out + run,      H],
               [y_back_in  + run,      H]], W);

        // paredes laterais do bolso
        for (x = [zero, W - wall])
            translate([x, zero, zero])
                prism([[zero, zero],
                       [y_back_in + ovl, zero],
                       [y_back_in + ovl + lip_h * tan(tilt), z_lip],
                       [zero, z_lip]], wall);

        // reforcos triangulares entre encosto e pe
        for (x = [zero, W - wall])
            translate([x, zero, zero])
                prism([[y_back_out - ovl, base_t - ovl],
                       [D - gusset_inset, base_t - ovl],
                       [y_back_out - ovl + gusset_h * tan(tilt), base_t + gusset_h]], wall);
    }

    // texto gravado na face frontal
    translate([W * half, txt_depth, z_lip * half])
        rotate([rot_up, zero, zero])
            linear_extrude(height = txt_depth + cut_extra)
                text(txt, size = txt_size, font = txt_font,
                     halign = "center", valign = "center");
}
