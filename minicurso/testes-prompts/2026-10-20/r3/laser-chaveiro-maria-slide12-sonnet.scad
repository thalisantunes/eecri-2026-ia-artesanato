// ===== PARAMETERS (all in mm) =====
layer = "cut";        // "cut" = contours and holes only; "engrave" = text only
W = 70;               // keychain width
H = 25;               // keychain height
corner_r = 4;         // corner radius
hole_d = 4.5;         // ring hole diameter
hole_edge = 3.5;      // distance from hole edge to the left edge of the piece
text_gap = 3;         // minimum gap between the text and the hole / the edges
max_letter = 8;       // maximum letter size
mark_d = 0.6;         // diameter of the corner marks
mark_off = 3;         // mark offset outside the corner, in X and Y
material = 3;         // MDF thickness (information only, not used in 2D)
clearance = 0.15;     // joint clearance (no joints in this piece, not used)
fn_circle = 64;       // circle resolution
name = "MARIA";       // engraved text
font_name = "Liberation Sans:style=Bold";

$fn = fn_circle;

// ===== DERIVED VALUES =====
hole_cx = hole_edge + hole_d / 2;                 // hole center X
hole_cy = H / 2;                                  // hole center Y (centered in height)
free_x0 = hole_cx + hole_d / 2 + text_gap;        // free area start (X)
free_x1 = W - text_gap;                           // free area end (X)
free_w = free_x1 - free_x0;                       // free width for the name
letter_size = min(max_letter, free_w / len(name));
text_cx = free_x0 + free_w / 2;                   // text center X

// ===== MODULES =====
module body() {
    hull() {
        for (x = [corner_r, W - corner_r], y = [corner_r, H - corner_r])
            translate([x, y]) circle(r = corner_r);
    }
}

module marks() {
    translate([-mark_off, -mark_off]) circle(d = mark_d);
    translate([W + mark_off, H + mark_off]) circle(d = mark_d);
}

module cut_layer() {
    difference() {
        body();
        translate([hole_cx, hole_cy]) circle(d = hole_d);
    }
}

module engrave_layer() {
    translate([text_cx, H / 2])
        text(name, size = letter_size, font = font_name,
             halign = "center", valign = "center");
}

// ===== OUTPUT =====
echo(str("layer = ", layer));
echo(str("piece = ", W, " x ", H, " mm, corner radius = ", corner_r, " mm"));
echo(str("hole: diameter = ", hole_d, " mm, center = (", hole_cx, ", ", hole_cy, ")"));
echo(str("hole edge to left edge = ", hole_cx - hole_d / 2, " mm"));
echo(str("free width for the name = ", free_w, " mm (from X=", free_x0, " to X=", free_x1, ")"));
echo(str("letter size = ", letter_size, " mm (", len(name), " letters)"));
echo(str("marks: diameter = ", mark_d, " mm at (", -mark_off, ", ", -mark_off,
         ") and (", W + mark_off, ", ", H + mark_off, ")"));
echo(str("material = ", material, " mm MDF, kerf not compensated"));

if (layer == "cut") {
    cut_layer();
    marks();
} else if (layer == "engrave") {
    engrave_layer();
    marks();
} else {
    echo("ERROR: layer must be \"cut\" or \"engrave\"");
}
