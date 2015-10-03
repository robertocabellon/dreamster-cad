use <roundedrect.scad>
use <triangles.scad>
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

//---------------------------------

dreamster_base_r = 140/2;
dreamster_base_thickness = 3;

arduino_base_depth = 84;
arduino_base_width = 65;
arduino_base_height_wall = 25+8+1.5;
arduino_base_thickness = 3;

battery_hole_depth = 60;
battery_hole_width = 37.5;
battery_support_height = 22;

wheel_hole_depth = 25;
wheel_hole_width = 80;
wheel_hole_thickness = 10;


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
/*
module ball_caster() {
  bcw = 11.7;
  translate([-bcw/2, 0, 0]) {
    cylinder(r=0.5, h=20, center=true);
  }
  translate([bcw/2, 0, 0]) {
    cylinder(r=0.5, h=20, center=true);
  }
}
*/
module rounded_slope(width, depth)
{
  translate([0, 0, width/2]) {
    difference() {
      cube([width, depth, width], center=true);
      rotate([90, 0, 0]) translate ([width/2, width/2, 0]) cylinder(h=depth+2, r=width, center=true);
    }
  }
}

module motor_cutout()
{
  ml = 30;
  mh = 13;
  cube([ml, mh, thickness_wall+18]);
  translate([0, mh, -2]) {
    scale([1, 1, 22]) {
      Right_Angled_Triangle(40, ml);
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

module ball_caster() {
    translate([0, 15, 0]) {
        sphere(r = 3, $fn=50); 
    }  
    translate([0, 0, 0]) {
        sphere(r = 3, $fn=50); 
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
  translate([0, depth/2-thickness_wall/2-9, height_wall/2+thickness/2]) {
    rotate([0, 0, 90]) {
      front_wall(slope);
    }
  }
}

module holes() {
  translate([17, -depth/2 + 13, 0]) {
    cube([10, 10, 3], center=false);
  }
  translate ([20, -depth/2 + 74, -5]) {
    cylinder (h = 20, r = 1.775);
  }
  translate ([-8.5, -depth/2 + 74, -5]) {
    cylinder (h = 20, r = 1.775);
  }
  translate ([-22.5, -depth/2 + 24, -5]) {
    cylinder (h = 20, r = 1.775);
  }
  translate([-width/2-3, -depth/2, 0]) {
  rotate([90, 0, 90]) {
    motor_cutout();
  }
  }
  translate([width/2-20, -depth/2, 0]) {
  rotate([90, 0, 90]) {
    motor_cutout();
  }
  }
  translate([0, depth/2-5, 0]) ball_caster();
}


//-------------------------------

module motor_support() {
    difference() {
        union() { 
            translate([0, 0, 5.5]) {
                cube([3, 6, 6]);
            }
            difference() {
                cube([6, 6, 6]);
                translate([6, 6, 5]) {
                    rotate([90, 0, 0]) {
                        cylinder(r = 3.1, h = 6);
                    }
                }
            }
        }
        translate([-2, 3, 6]) {
            rotate([90, 0, 90]) {
                cylinder(r = 1.7, h = 6);
            }
        }
    }
    
    translate([0, 22 + 6, 0]) {
        difference() {
            union() { 
                translate([0, 0, 5.5]) {
                    cube([3, 6, 6]);
                }
                difference() {
                    cube([6, 6, 6]);
                    translate([6, 6, 5]) {
                        rotate([90, 0, 0]) {
                            cylinder(r = 3.1, h = 6);
                        }
                    }
                }
            }
            translate([-2, 3, 6]) {
                rotate([90, 0, 90]) {
                    cylinder(r = 1.7, h = 6);
                }
            }
        }
    }
}

module ball_caster() {
    translate([0, 15, 0]) {
        sphere(r = 3, $fn=50); 
    }  
}

module dreamster_base_holes() {
    translate([0, depth/2-5, 0]) ball_caster();
    translate([battery_hole_width/2, battery_hole_depth/2 + 3.5 + 5.25, -5]) cylinder(r = 3.5/2, 35);
    translate([-battery_hole_width/2, -(battery_hole_depth/2 + 3.5 + 5.25), -5]) cylinder(r = 3.5/2, 35);
}

module arduino_holes() {
    translate([17, -depth/2 + 12.5, -2]) {
    cube([10, 10, 6], center=false);
    }
    translate ([20, -depth/2 + 74, -5]) {
    cylinder (h = 20, r = 1.775);
    }
    translate ([-8.5, -depth/2 + 74, -5]) {
    cylinder (h = 20, r = 1.775);
    }
    translate ([-22.5, -depth/2 + 24, -5]) {
    cylinder (h = 20, r = 1.775);
    }
    translate([2, -hole_pos_y, 0]) {
        cube([hole_width, hole_depth, thickness+2], 1, center=true);
    }    
    translate([battery_hole_width/2, battery_hole_depth/2 + 3.5 + 5.25, -5]) cylinder(r = 3.5/2, 35);
    translate([-battery_hole_width/2, -(battery_hole_depth/2 + 3.5 + 5.25), -5]) cylinder(r = 3.5/2, 35);
}

module wheels_holes() {
    translate([-dreamster_base_r/2 - dreamster_base_r/2, -wheel_hole_width/2, -5]) {
        cube([wheel_hole_depth, wheel_hole_width, wheel_hole_thickness]);
    }    
    translate([dreamster_base_r/1.5, -wheel_hole_width/2, -5]) {
        cube([wheel_hole_depth, wheel_hole_width, wheel_hole_thickness]);
    }
}

module battery_supports() {
    translate([battery_hole_width/2, battery_hole_depth/2 + 3.5 + 5.25, 0]) {
        union() {
            cube([14, 7, 22], center=true);           
            translate([3.5, -3.5, 0]) {
                cube([7, 14, 22], center=true);          
            }
        }
    }

    translate([-battery_hole_width/2, -(battery_hole_depth/2 + 3.5 + 5.25), 0]) {
        rotate([0, 0, 180]) {
            union() {
                cube([14, 7, battery_support_height], center=true);           
                translate([3.5, -3.5, 0]) {
                    cube([7, 14, battery_support_height], center=true);          
                }
            }
        }
    }
 }

module arduino_base() {
    difference() {
        cube([arduino_base_width, arduino_base_depth, arduino_base_thickness - 1], center=true);   
        arduino_holes();
    }
}

module dreamster_base() {
    difference() {
       union() {
           difference() {
                cylinder (h = dreamster_base_thickness, r = dreamster_base_r, center = true);  
                translate([0, 0, -1]) {
                    cube([battery_hole_width, battery_hole_depth, dreamster_base_thickness + 2], center=true); 
                }
            }
            translate([0, 0, dreamster_base_thickness + battery_support_height/2 - 2]) {
                battery_supports();
            }
        }
        dreamster_base_holes();
        wheels_holes();
    }
    translate([-dreamster_base_r/2.5, -6 -22/2, -0.25]) {
        motor_support();
    }
    translate([dreamster_base_r/2.5, 6 + 22/2, -0.25]) {
        rotate([0, 0, 180]) {
            motor_support();
        }
    }
 }


//------------------------

  translate([0, 0, 25]) {
      arduino_base();
  }
 
  dreamster_base();

//difference() {
  //chassis();
  //rounder();
  //holes();
//}
