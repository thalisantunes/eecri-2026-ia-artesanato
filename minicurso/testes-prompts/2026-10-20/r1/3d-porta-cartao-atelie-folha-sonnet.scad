// ============================================================
// Porta-cartao de mesa "ATELIE" - OpenSCAD 2021.01
// Sem bibliotecas. Unidades em milimetros.
// Imprime apoiado na base (z = 0), sem suporte.
// ============================================================

// ---------- Numeros (todos aqui) ----------
tilt         = 12;    // inclinacao do encosto para tras, em graus
card_w       = 90;    // largura do cartao
card_h       = 50;    // altura do cartao (so referencia da checagem)
stack_t      = 12;    // espessura da pilha de cartoes
clear_w      = 1.0;   // folga total na largura do bolso
clear_t      = 1.0;   // folga total na espessura do bolso
front_t      = 4;     // parede frontal (onde fica o texto)
back_t       = 4;     // parede traseira (encosto)
side_t       = 4;     // paredes laterais
floor_t      = 2.4;   // espessura minima do piso sob o bolso
min_wall     = 2;     // parede minima exigida
pocket_depth = 36;    // profundidade do bolso ao longo do encosto
window_depth = 20;    // altura da parede frontal baixa (cartao aparece acima)
foot_len     = 38;    // quanto o pe avanca atras do encosto
foot_h       = 16;    // altura onde o pe encontra o encosto
foot_end_t   = 2.4;   // espessura da ponta do pe
foot_w       = 70;    // largura do pe
foot_overlap = 3;     // quanto o pe entra na parede traseira (fusao)
text_str     = "ATELIÊ";                      // texto gravado
text_font    = "Liberation Sans:style=Bold";  // fonte
text_size    = 10;    // altura das letras
engrave      = 0.8;   // profundidade da gravacao

// ---------- Derivados ----------
ca       = cos(tilt);
sa       = sin(tilt);
pocket_w = card_w + clear_w;               // largura interna do bolso
pocket_t = stack_t + clear_t;              // espessura interna do bolso
body_w   = pocket_w + 2 * side_t;          // largura total
body_t   = front_t + pocket_t + back_t;    // espessura da placa inclinada
// piso do bolso: o canto traseiro e o mais baixo (inclinado), fica a floor_t de z=0
floor_u  = (floor_t + (front_t + pocket_t) * sa) / ca;
slab_h   = floor_u + pocket_depth;         // altura da placa ao longo do encosto
u_win    = floor_u + window_depth;         // topo da parede frontal baixa
text_u   = u_win / 2;                      // centro vertical do texto
function y_r(z) = body_t / ca + z * tan(tilt);  // y da face traseira na altura z
y_end    = y_r(0) + foot_len;              // ponta do pe

assert(front_t - engrave >= min_wall, "parede frontal sob a gravacao ficou fina");
assert(back_t >= min_wall && side_t >= min_wall && floor_t >= min_wall && foot_end_t >= min_wall,
       "alguma parede ficou abaixo do minimo");
assert(pocket_depth < card_h, "o cartao precisa sobrar acima do bolso");

// ---------- Modulos ----------
module slab() {
    rotate([-tilt, 0, 0])
        translate([-body_w / 2, 0, 0])
            cube([body_w, body_t, slab_h]);
}

module foot() {
    // perfil (y,z) extrudado ao longo de X
    rotate([90, 0, 90])
        linear_extrude(height = foot_w, center = true)
            polygon([
                [y_r(0) - foot_overlap, 0],
                [y_end, 0],
                [y_end, foot_end_t],
                [y_r(foot_h), foot_h],
                [y_r(foot_h) - foot_overlap, foot_h]
            ]);
}

module pocket() {
    rotate([-tilt, 0, 0]) {
        // bolso dos cartoes, aberto em cima
        translate([-pocket_w / 2, front_t, floor_u])
            cube([pocket_w, pocket_t, slab_h]);
        // rebaixo da parede frontal, deixa o cartao aparecer
        translate([-pocket_w / 2, -1, u_win])
            cube([pocket_w, front_t + 1.01, slab_h]);
    }
}

module engraving() {
    // texto na face frontal, cortando engrave mm para dentro
    rotate([-tilt, 0, 0])
        translate([0, engrave, text_u])
            rotate([90, 0, 0])
                linear_extrude(height = engrave + 1)
                    text(text_str, size = text_size, font = text_font,
                         halign = "center", valign = "center");
}

// ---------- Peca ----------
difference() {
    intersection() {
        union() {
            slab();
            foot();
        }
        // corta tudo abaixo de z = 0 (base plana na mesa)
        translate([-500, -500, 0]) cube([1000, 1000, 500]);
    }
    pocket();
    engraving();
}

// ---------- Dimensoes ----------
echo(largura_mm = body_w);
echo(profundidade_mm = y_end);
echo(altura_mm = slab_h * ca);
