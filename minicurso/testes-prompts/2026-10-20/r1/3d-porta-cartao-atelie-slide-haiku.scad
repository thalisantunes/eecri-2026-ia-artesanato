CARD_W   = 90;
STACK_T  = 12;
CLEAR    = 2;
WALL     = 4;
BASE_T   = 4;
LIP_H    = 20;
END_T    = 4;
TILT     = 15;
TOP_H    = 60;
TXT      = "ATELIÊ";
TXT_SIZE = 7;
ENGRAVE  = 0.8;
FONT     = "Liberation Sans:style=Bold";
W        = CARD_W + CLEAR + 2*END_T;
GAP_H    = (STACK_T + CLEAR) / cos(TILT);
T        = tan(TILT);
LIP_T    = WALL;
WALL_H   = WALL / cos(TILT);
function y_in(z)  = LIP_T + GAP_H + z*T;
function y_out(z) = y_in(z) + WALL_H;
D        = y_out(BASE_T);
DEPTH    = y_out(TOP_H);
H        = TOP_H;
echo(str("largura X: ", W, " mm"));
echo(str("profundidade Y: ", DEPTH, " mm"));
echo(str("altura Z: ", H, " mm"));
module profile_back() {
    rotate([90, 0, 90])
        linear_extrude(height = W)
            polygon([[y_in(0), 0], [y_out(0), 0],
                     [y_out(TOP_H), TOP_H], [y_in(TOP_H), TOP_H]]);
}
module profile_side() {
    rotate([90, 0, 90])
        linear_extrude(height = END_T)
            polygon([[0, 0], [y_out(0), 0], [y_out(TOP_H), TOP_H],
                     [LIP_T, TOP_H], [LIP_T, LIP_H], [0, LIP_H]]);
}
difference() {
    union() {
        cube([W, D, BASE_T]);
        cube([W, LIP_T, LIP_H]);
        profile_back();
        profile_side();
        translate([W - END_T, 0, 0]) profile_side();
    }
    translate([W/2, ENGRAVE, LIP_H/2])
        rotate([90, 0, 0])
            linear_extrude(height = ENGRAVE + 1)
                text(TXT, size = TXT_SIZE, font = FONT,
                     halign = "center", valign = "center");
}
