// ============ PARAMETERS (all in mm) ============
layer = "cut";            // "cut" = contours and holes | "engrave" = text

key_w = 70;               // keychain width
key_h = 25;               // keychain height
corner_r = 4;             // corner radius
hole_d = 4.5;             // ring hole diameter
hole_edge_left = 3.5;     // distance from left edge to hole edge
text_gap = 3;             // minimum gap text-hole and text-edges
name = "MARIA";           // engraved name
text_max = 8;             // maximum letter size
font_name = "Liberation Sans:style=Bold"; // font
mark_d = 0.6;             // registration circle diameter
mark_offset = 3;          // registration circle distance outside corners
material_t = 3;           // MDF thickness (info only, echo)
clearance = 0;            // joint clearance (unused: no joints here)
circle_fn = 64;           // circle smoothness

// ============ CALCULATIONS ============
hole_cx = hole_edge_left + hole_d / 2;      // hole center X
hole_cy = key_h / 2;                        // hole center Y (centered)
text_x0 = hole_edge_left + hole_d + text_gap; // free area start X
text_x1 = key_w - text_gap;                 // free area end X
free_w = text_x1 - text_x0;                 // free width for the name
letter_count = len(name);
text_size = min(text_max, free_w / letter_count);
text_cx = (text_x0 + text_x1) / 2;          // text center X
text_cy = key_h / 2;                        // text center Y

// ============ ECHO ============
echo("Layer", layer);
echo("Piece W x H", key_w, key_h);
echo("Material thickness", material_t);
echo("Hole center", hole_cx, hole_cy, "diameter", hole_d);
echo("Free width for name", free_w);
echo("Letter size", text_size);
echo("Letter count", letter_count);
echo("Free area X from", text_x0, "to", text_x1);
echo("Mark 1 center", -mark_offset, -mark_offset);
echo("Mark 2 center", key_w + mark_offset, key_h + mark_offset);

// ============ MODULES ============
module body() {
    hull() {
        translate([corner_r, corner_r]) circle(r = corner_r, $fn = circle_fn);
        translate([key_w - corner_r, corner_r]) circle(r = corner_r, $fn = circle_fn);
        translate([corner_r, key_h - corner_r]) circle(r = corner_r, $fn = circle_fn);
        translate([key_w - corner_r, key_h - corner_r]) circle(r = corner_r, $fn = circle_fn);
    }
}

module marks() {
    translate([-mark_offset, -mark_offset])
        circle(d = mark_d, $fn = circle_fn);
    translate([key_w + mark_offset, key_h + mark_offset])
        circle(d = mark_d, $fn = circle_fn);
}

module cut_layer() {
    difference() {
        body();
        translate([hole_cx, hole_cy]) circle(d = hole_d, $fn = circle_fn);
    }
}

module engrave_layer() {
    translate([text_cx, text_cy])
        text(name, size = text_size, font = font_name,
             halign = "center", valign = "center");
}

// ============ OUTPUT ============
if (layer == "cut") {
    cut_layer();
    marks();
} else if (layer == "engrave") {
    engrave_layer();
    marks();
}
