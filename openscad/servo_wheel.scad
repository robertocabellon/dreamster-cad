width=5;
radius=18;

pole_w = 6;
pole_l = 17;
arm_w = 4;
arm_l = 7;
hole_r = 3.5;

$fn=50;

module motor_nut(center_r, pole_l, pole_w) {
    cylinder(r=center_r, h=width+5, center=true);
    translate([0, 0, 2]) {
        cube([2*pole_l, pole_w, 2], center=true);
        cube([arm_w, arm_l*2, 2], center=true);
    }
    translate([7.5, 0, 0]) {
        cylinder(r=1.5, h=width+5, center=true);
    }
    translate([12, 0, 0]) {
        cylinder(r=1.1, h=width+5, center=true);
    }
    translate([-7.5, 0, 0]) {
        cylinder(r=1.1, h=width+5, center=true);
    }
    translate([-12, 0, 0]) {
        cylinder(r=1.1, h=width+5, center=true);
    }
}

module semi_circle() {
    difference() {
        cylinder(r=radius-3, h=width+5, center=true);
        translate([0, radius-8, 0]) {
            cube([2*radius, 2*radius, width+5], center=true);
        }
    }
}

module wheel(radius, width) {
    difference() {
        cylinder(r=radius, h=width, center=true);
        motor_nut(hole_r, pole_l, pole_w);
        semi_circle();
        rotate([0,0,180]) semi_circle();
    }
}

wheel(radius, width);
