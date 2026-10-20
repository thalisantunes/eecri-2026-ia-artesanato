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
