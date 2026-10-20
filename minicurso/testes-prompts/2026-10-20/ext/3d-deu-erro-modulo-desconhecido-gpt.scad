module rounded_plate(size, radius) {
    r = min(radius, size[0] / 2, size[2] / 2);

    translate([0, size[1], 0])
        rotate([90, 0, 0])
            linear_extrude(height = size[1])
                hull() {
                    translate([r, r])
                        circle(r = r);
                    translate([size[0] - r, r])
                        circle(r = r);
                    translate([r, size[2] - r])
                        circle(r = r);
                    translate([size[0] - r, size[2] - r])
                        circle(r = r);
                }
}

// Porta-cartão de mesa - impressão 3D
card_w = 90;         // largura do cartão (mm)
card_h = 50;         // altura do cartão (mm)
stack = 12;          // espessura da pilha de cartões (mm)
wall = 2.4;          // espessura das paredes (mm)
clearance = 1;       // folga para os cartões (mm)
tilt = 12;           // inclinação do encosto (graus)
base_d = 45;         // profundidade da base (mm)
base_h = 4;          // altura da base (mm)
lip_h = 12;          // altura da aba da frente (mm)
back_h = 40;         // altura do encosto (mm)
word = "ATELIÊ";     // texto gravado
font_size = 7;       // altura da letra (mm)
engrave = 0.8;       // profundidade da gravação (mm)

body_w = card_w + 2 * clearance + 2 * wall;
pocket = stack + clearance;

difference() {
    union() {
        cube([body_w, base_d, base_h]);
        cube([body_w, wall, lip_h]);
        translate([0, wall + pocket + wall, 0])
            rotate([-tilt, 0, 0])
                translate([0, -wall, 0])
                    rounded_plate([body_w, wall, back_h], 2);
    }
    translate([body_w / 2, -0.01, lip_h / 2])
        rotate([90, 0, 0])
            translate([0, 0, -engrave])
                linear_extrude(engrave + 0.01)
                    text(word, size = font_size, font = "Liberation Sans:style=Bold",
                         halign = "center", valign = "center");
}

echo(str("Largura: ", body_w, " mm"));
echo(str("Profundidade: ", base_d, " mm"));
echo(str("Altura: ", back_h * cos(tilt), " mm"));
