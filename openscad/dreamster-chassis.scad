use <roundedrect.scad>
// Dreamster parametric prototype chassis V1

// Default resolution (set it lower for faster rendering)
$fn = 50;

// Chassis parameters
depth = 95;
width = 90;
height_wall = 25+8+1.5;
thickness = 3;
thickness_wall = 3.5;
mount_holes_diameter = 3;
hole_width = 40;
hole_depth = 50;
hole_pos_y = 10;

corner_radius = 10;
slope = 5;

module distance_sensor() {
  radio = 16.3 / 2;
  sep = 25.7;
  translate([-10, -(radio)-(sep-2*radio)/2, 0]) {
	rotate ([0, 90, 0]) {
		cylinder (h = 20, r = radio);
		translate ([0, sep, 0]) {
			cylinder (h = 20, r = radio);
		}
	}
}
}

module rounded_slope(width, depth)
{
  translate([0, 0, width/2]) {
    difference() {
      cube([width, depth, width], center=true);
      rotate([90, 0, 0]) translate ([width/2, width/2, 0]) cylinder(h=depth+2, r=width, center=true);
    }
  }
}

module rounder() {
  r = corner_radius;
  translate([0, 0, -5]) {
    difference() {
      roundedRect([width+r, depth+r, height_wall+10], r);
      roundedRect([width-r, depth-r, height_wall+10], r);
    }
  }
}

module base() {
  difference() {
    cube([width, depth, thickness], center=true);
    translate([0, -hole_pos_y, 0]) {
      cube([hole_width, hole_depth, thickness+2], 1, center=true);
    }
  }
}


module side_wall(slope_width) {
  wd = depth-10;
  difference() {
    cube([thickness_wall, wd, height_wall], center=true);
    translate([0, -43/2-2, height_wall/2]) {
      distance_sensor();
    }
    translate([0, 43/2+2, height_wall/2]) {
      distance_sensor();
    }
  }
  translate([slope_width/2+thickness_wall/2, 0, -height_wall/2]) rounded_slope(slope_width, wd);
}

module front_wall(slope_width) {
  difference() {
    cube([thickness_wall, 50, height_wall], center=true);
    translate([0,0,height_wall/2]) {
      distance_sensor();
    }
  }
  translate([slope_width/2+thickness_wall/2, 0, -height_wall/2]) rounded_slope(slope_width, 50);
  rotate([180, 180, 0]) translate([slope_width/2+thickness_wall/2, 0, -height_wall/2]) rounded_slope(slope_width, 50);
}

module chassis() {
  base();
  translate([width/2-thickness_wall/2, 0, height_wall/2+thickness/2]) {
    rotate([0, 0, 180]) {
      side_wall(slope);
    }
  }
  translate([-(width/2-thickness_wall/2), 0, height_wall/2+thickness/2]) {
    side_wall(slope);
  }
  translate([0, depth/2-thickness_wall/2-7, height_wall/2+thickness/2]) {
    rotate([0, 0, 90]) {
      front_wall(slope);
    }
  }
}

module holes() {
  translate([-37, -depth/2 + 30, -3]) {
    #cube([3, 25, 6], center=false);
    translate([-2.1, 0, 4.5])
    #cube([5, 25, 6], center=false);
  }
  translate([35, -depth/2 + 30, -3]) {
    #cube([3, 25, 6], center=false);
    translate([0, 0, 4.5])
    #cube([5, 25, 6], center=false);
  }
	translate([17, -depth/2 + 8, 0]) {
		cube([10, 10, 3], center=false);
	}

	translate ([20, -depth/2 + 69, -5]) {
		cylinder (h = 20, r = 1.75);
	}

	translate ([-8.5, -depth/2 + 69, -5]) {
		cylinder (h = 20, r = 1.75);
	}

	translate ([-22.5, -depth/2 + 19, -5]) {
		cylinder (h = 20, r = 1.75);
	}
}
difference() {
  chassis();
  rounder();
  holes();
}
