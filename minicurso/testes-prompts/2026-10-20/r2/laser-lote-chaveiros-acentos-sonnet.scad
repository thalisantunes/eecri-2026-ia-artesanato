// Keychain batch for laser: cut / engrave layers (OpenSCAD 2021.01, 2D only)
// All units in millimetres. No kerf compensation.

layer = "cut";                              // "cut" = outlines and holes; "engrave" = text only

names = ["ANA", "JOÃO", "CONCEIÇÃO", "PEDRO"]; // one keychain per name
font_name = "Liberation Sans:style=Bold";   // text font

key_w = 70;          // keychain width
key_h = 25;          // keychain height
hole_d = 4.5;        // hole diameter
hole_edge = 3.5;     // distance from left edge to the hole edge
text_margin = 3;     // minimum distance from text to hole and to borders
max_size = 8;        // maximum letter size
cols = 2;            // number of columns in the grid
gap = 3;             // spacing between keychains
mark_d = 0.6;        // registration mark diameter
mark_off = 3;        // registration mark offset outside the batch corners (on X and Y)
clearance = 0;       // joint clearance (no joints in this part, so unused)
fn = 64;             // circle resolution

// ---- derived values ----
n = len(names);
rows = ceil(n / cols);
batch_w = cols * key_w + (cols - 1) * gap;
batch_h = rows * key_h + (rows - 1) * gap;
hole_cx = hole_edge + hole_d / 2;                     // hole center X
text_x0 = hole_edge + hole_d + text_margin;           // text zone start (3 mm after the hole)
text_x1 = key_w - text_margin;                        // text zone end (3 mm from right edge)
free_w = text_x1 - text_x0;                           // free width for the name
text_cx = (text_x0 + text_x1) / 2;                    // text center X

function fsize(name) = min(max_size, free_w / len(name));
function col_of(i) = i % cols;
function row_of(i) = floor(i / cols);
function ox(i) = col_of(i) * (key_w + gap);
function oy(i) = (rows - 1 - row_of(i)) * (key_h + gap);  // row 0 on top

module key_cut() {
    difference() {
        square([key_w, key_h]);
        translate([hole_cx, key_h / 2]) circle(d = hole_d, $fn = fn);
    }
}

module key_text(name) {
    s = fsize(name);
    // baseline fixed so cap height is vertically centered (same baseline for all names)
    translate([text_cx, key_h / 2 - s / 2])
        text(name, size = s, font = font_name, halign = "center", valign = "baseline");
}

module marks() {
    translate([-mark_off, -mark_off]) circle(d = mark_d, $fn = 32);
    translate([batch_w + mark_off, batch_h + mark_off]) circle(d = mark_d, $fn = 32);
}

if (layer == "cut") {
    for (i = [0 : n - 1]) translate([ox(i), oy(i)]) key_cut();
} else if (layer == "engrave") {
    for (i = [0 : n - 1]) translate([ox(i), oy(i)]) key_text(names[i]);
} else {
    echo("ERROR: layer must be \"cut\" or \"engrave\"");
}
marks();   // on both layers

// ---- final measures ----
echo(layer = layer);
echo(keychain_count = n);
echo(keychain_size = [key_w, key_h], hole_center = [hole_cx, key_h / 2]);
echo(free_width_for_name = free_w);
for (i = [0 : n - 1]) echo(name = names[i], letters = len(names[i]), letter_size = fsize(names[i]));
echo(batch_size = [batch_w, batch_h], grid = [cols, rows]);
echo(marks_at = [[-mark_off, -mark_off], [batch_w + mark_off, batch_h + mark_off]]);
echo(total_with_marks = [batch_w + 2 * mark_off, batch_h + 2 * mark_off]);
