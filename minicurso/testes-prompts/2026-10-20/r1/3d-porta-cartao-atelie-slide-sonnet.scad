card_w   = 90;
card_h   = 50;
stack_t  = 12;
clear_w  = 0.8;
clear_t  = 1.0;
wall     = 2.4;
floor_t  = 3;
tilt     = 15;
engrave  = 0.8;
front_t  = 3.2;
front_h  = 22;
back_h   = 36;
txt      = "ATELIÊ";
txt_size = 8;
txt_z    = 6;
slot_w   = card_w + clear_w;
slot_t   = stack_t + clear_t;
slot_dy  = slot_t / cos(tilt);
tt       = tan(tilt);
body_w   = slot_w + 2*wall;
back_in  = front_t + slot_dy + (back_h - floor_t)*tt;
body_d   = back_in + wall;
top_cut  = back_h + 1;
module profile() {
    polygon([[0,0],[body_d,0],[body_d,back_h],[0,front_h]]);
}
module slot_profile() {
    polygon([
        [front_t, floor_t],
        [front_t + slot_dy, floor_t],
        [front_t + slot_dy + (top_cut - floor_t)*tt, top_cut],
        [front_t + (top_cut - floor_t)*tt, top_cut]
    ]);
}
module extrude_x(len) {
    rotate([90,0,90]) linear_extrude(height = len) children();
}
difference() {
    translate([-body_w/2, 0, 0]) extrude_x(body_w) profile();
    translate([-slot_w/2, 0, 0]) extrude_x(slot_w) slot_profile();
    translate([0, engrave, txt_z])
        rotate([90,0,0])
            linear_extrude(height = engrave + 0.2)
                text(txt, size = txt_size, font = "Liberation Sans:style=Bold",
                     halign = "center", valign = "baseline");
}
echo(str("Width (X): ", body_w, " mm"));
echo(str("Depth (Y): ", body_d, " mm"));
echo(str("Height (Z): ", back_h, " mm"));
