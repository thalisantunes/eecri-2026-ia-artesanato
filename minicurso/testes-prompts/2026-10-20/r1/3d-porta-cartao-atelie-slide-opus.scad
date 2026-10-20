card_w       = 90;
card_h       = 50;
stack        = 12;
clr_w        = 1;
clr_d        = 1.5;
angle        = 15;
wall_side    = 3;
front_t      = 3;
front_h      = 15;
floor_t      = 3;
back_t       = 3;
total_h      = 45;
lip_extra    = 1;
eps          = 0.01;
label        = "ATELIÊ";
font_name    = "Liberation Sans:style=Bold";
text_size    = 7;
text_depth   = 0.8;
pocket_d = stack / cos(angle) + clr_d;
bt       = back_t / cos(angle);
y0       = front_t + pocket_d;
W        = card_w + clr_w + 2 * wall_side;
D        = y0 + bt + (total_h - floor_t) * tan(angle);
H        = total_h;
echo(largura = W, profundidade = D, altura = H);
module outer_profile() {
    polygon([
        [0, 0],
        [D, 0],
        [D, total_h],
        [y0 + (total_h - floor_t) * tan(angle), total_h],
        [y0 + (front_h - floor_t) * tan(angle), front_h],
        [0, front_h]
    ]);
}
module rear_void() {
    polygon([
        [y0 + bt, floor_t],
        [D + eps, floor_t],
        [D + eps, total_h - eps],
        [D, total_h]
    ]);
}
module pocket_profile() {
    zc = front_h + lip_extra;
    polygon([
        [front_t, floor_t],
        [y0, floor_t],
        [y0 + (zc - floor_t) * tan(angle), zc],
        [front_t, zc]
    ]);
}
module along_x(len) {
    rotate([90, 0, 90]) linear_extrude(height = len) children();
}
difference() {
    along_x(W) difference() {
        outer_profile();
        rear_void();
    }
    translate([wall_side, 0, 0]) along_x(card_w + clr_w) pocket_profile();
    translate([W / 2, text_depth, front_h / 2])
        rotate([90, 0, 0])
            linear_extrude(height = text_depth + eps)
                text(label, size = text_size, font = font_name,
                     halign = "center", valign = "center");
}
