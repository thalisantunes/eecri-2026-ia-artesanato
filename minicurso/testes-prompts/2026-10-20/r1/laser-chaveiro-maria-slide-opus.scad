// ===== Parameters (all in mm) =====
layer         = "cut";    // "cut" = outline + holes; "engrave" = text only
tag_w         = 70;       // keychain width
tag_h         = 25;       // keychain height
corner_r      = 4;        // corner radius
hole_d        = 4.5;      // key ring hole diameter
hole_cx       = 7;        // hole center distance from left edge
hole_cy       = 12.5;     // hole center height (tag_h / 2)
name_txt      = "MARIA";  // engraved name
font_name     = "Liberation Sans:style=Bold"; // font
text_size     = 10;       // nominal text size
text_gap      = 3;        // gap between hole edge and text area
text_margin_r = 3;        // right margin of text area
material_t    = 3;        // MDF thickness (reference only, 2D file)
clearance     = 0;        // fit clearance - unused: this part has no fits
mark_d        = 0.6;      // registration mark diameter
mark_off      = 3;        // mark offset outside the corners (x and y)
seg           = 64;       // circle resolution ($fn)

// ===== Derived values =====
text_x0   = hole_cx + hole_d / 2 + text_gap;   // text area start
text_x1   = tag_w - text_margin_r;             // text area end
text_cx   = (text_x0 + text_x1) / 2;           // text center x
text_cy   = tag_h / 2;                         // text center y
text_area = text_x1 - text_x0;                 // available text width
hole_edge = hole_cx - hole_d / 2;              // material between hole and left edge

$fn = seg;

assert(layer == "cut" || layer == "engrave", "layer must be \"cut\" or \"engrave\"");
assert(corner_r > 0 && 2 * corner_r <= tag_h, "invalid corner radius");
assert(hole_edge > 0, "hole crosses the edge");

// ===== Reports =====
echo(str("Tag: ", tag_w, " x ", tag_h, " mm, corner R", corner_r, ", MDF ", material_t, " mm"));
echo(str("Hole: d=", hole_d, " mm at (", hole_cx, ", ", hole_cy, "), edge material ", hole_edge, " mm"));
echo(str("Text: \"", name_txt, "\" size ", text_size, " centered at (", text_cx, ", ", text_cy, "), area ", text_area, " mm wide"));
echo(str("Marks: d=", mark_d, " mm at (", -mark_off, ", ", -mark_off, ") and (", tag_w + mark_off, ", ", tag_h + mark_off, ")"));
echo(str("Layer: ", layer, ", clearance ", clearance, " mm, kerf not compensated"));

// ===== Modules =====
module rounded_rect(w, h, r) {
    hull()
        for (x = [r, w - r], y = [r, h - r])
            translate([x, y]) circle(r = r);
}

module marks() {
    translate([-mark_off, -mark_off]) circle(d = mark_d);
    translate([tag_w + mark_off, tag_h + mark_off]) circle(d = mark_d);
}

module cut_layer() {
    difference() {
        rounded_rect(tag_w, tag_h, corner_r);
        translate([hole_cx, hole_cy]) circle(d = hole_d);
    }
}

module engrave_layer() {
    translate([text_cx, text_cy])
        text(name_txt, size = text_size, font = font_name,
             halign = "center", valign = "center");
}

// ===== Output =====
if (layer == "cut") cut_layer();
if (layer == "engrave") engrave_layer();
marks();
