// ================== PARAMETERS (all in mm) ==================
layer         = "cut";      // "cut" = outline + holes; "engrave" = text only
part_w        = 70;         // keychain width (X)
part_h        = 25;         // keychain height (Y)
corner_r      = 4;          // corner radius
hole_d        = 4.5;        // key ring hole diameter
hole_edge_gap = 3.5;        // gap from hole edge to left edge of the part
name_text     = "MARIA";    // engraved name
name_gap      = 3;          // minimum gap from text to hole and to part edges
max_letter    = 8;          // maximum letter size
font_name     = "Liberation Sans:style=Bold"; // font
material_t    = 3;          // MDF thickness (reference only, 2D file)
clearance     = 0;          // fit clearance (only for joints; this part has none)
mark_d        = 0.6;        // registration mark diameter
mark_offset   = 3;          // registration mark offset outside the corners (X and Y)
half          = 0.5;        // helper factor for halves/centers
$fn           = 64;         // circle resolution

// ================== DERIVED VALUES ==================
hole_x   = hole_edge_gap + hole_d * half;          // hole center X
hole_y   = part_h * half;                          // hole center Y (centered in height)
text_x0  = hole_edge_gap + hole_d + name_gap;      // left limit of text area
text_x1  = part_w - name_gap;                      // right limit of text area
free_w   = text_x1 - text_x0;                      // free width for the name
free_h   = part_h - 2 * name_gap;                  // free height for the name
letter   = min(max_letter, free_w / len(name_text)); // letter size
text_cx  = (text_x0 + text_x1) * half;             // text center X
mark_pos = [[-mark_offset, -mark_offset],
            [part_w + mark_offset, part_h + mark_offset]]; // registration marks

assert(layer == "cut" || layer == "engrave", "layer must be \"cut\" or \"engrave\"");
assert(free_w > 0, "no free width for the name");
assert(letter <= free_h, "letter size exceeds free height");

// ================== REPORT ==================
echo(str("Layer: ", layer));
echo(str("Part: ", part_w, " x ", part_h, " mm, corner radius ", corner_r, " mm, MDF ", material_t, " mm"));
echo(str("Hole: d = ", hole_d, " mm, center = (", hole_x, ", ", hole_y, ") mm"));
echo(str("Text area: X ", text_x0, " to ", text_x1, " mm"));
echo(str("Free width for name: ", free_w, " mm"));
echo(str("Letter size: ", letter, " (min of ", max_letter, " and ", free_w / len(name_text), ")"));
echo(str("Registration marks: d = ", mark_d, " mm at ", mark_pos[0], " and ", mark_pos[1]));
echo(str("Overall extent incl. marks: ", part_w + 2 * mark_offset + mark_d, " x ", part_h + 2 * mark_offset + mark_d, " mm"));

// ================== MODULES ==================
module outline() {
    hull() {
        for (x = [corner_r, part_w - corner_r], y = [corner_r, part_h - corner_r])
            translate([x, y]) circle(r = corner_r);
    }
}

module cut_layer() {
    difference() {
        outline();
        translate([hole_x, hole_y]) circle(d = hole_d);
    }
}

module engrave_layer() {
    translate([text_cx, hole_y])
        text(name_text, size = letter, font = font_name,
             halign = "center", valign = "center");
}

module marks() {
    for (p = mark_pos) translate(p) circle(d = mark_d);
}

// ================== OUTPUT ==================
if (layer == "cut") cut_layer();
if (layer == "engrave") engrave_layer();
marks();
