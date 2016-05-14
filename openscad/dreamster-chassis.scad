// Dreamster parametric prototype chassis V2.0

// Default resolution (set it lower for faster rendering)
$fn = 80;

// Chassis parameters
depth = 95;
width = 90;
height_wall = 25+8+1.5;
thickness = 3;
thickness_wall = 3.5;

mount_holes_diameter = 3;
hole_width = 40;
hole_depth = 52;
hole_pos_y = 11;

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
battery_support_height = 28;

wheel_hole_depth = 20;
wheel_hole_width = 70;
wheel_hole_thickness = dreamster_base_thickness*1.1;

medida_servo = 23.6;
distancia_agujeros_servo = 28.6;

motor_x = 3;
motor_y = distancia_agujeros_servo-medida_servo;
motor_z = 12;
motor_axe_disp = 5;
motor_tab = 3;

ball_caster_r = 7.5; // canica d = 15 mm
ball_caster_center = 56;
ball_caster_support_holes = 11;

distance_to_floor = 12; // measured from the top of the base (aka includes the thickness)
ball_caster_height = distance_to_floor-dreamster_base_thickness-1.5;

//---------------------------------

module logo() {
   linear_extrude(height = 1.2,  convexity = 10)
        import(file="dreamster_logo.dxf");
}


module motor_support() {
  union(){
    difference() {
      cube([motor_x, motor_y, motor_z]);
      translate([-motor_x/2, motor_y/2, motor_z/2])
        rotate([0, 90, 0])
          cylinder(r = 1.3, h = 6);
    }
    difference() {
      cube([6.3, motor_y*2, motor_z/3]);
      translate([7, 2*motor_y+0.1, 4.1])
        rotate([90, 0, 0])
          cylinder(r = 4, h = motor_y*2.1);
    }
  }

  translate([-motor_tab,motor_y,0])  
  rotate([0,0,180])
  union(){
    difference() {
      cube([motor_x, motor_y, motor_z]);
      translate([-motor_x/2, motor_y/2, motor_z/2])
        rotate([0, 90, 0])
          cylinder(r = 1.3, h = 6);
    }
    difference() {
      translate([0, -motor_y, 0])
        cube([6.3, motor_y*2-0.1, motor_z/3]);
      translate([7, motor_y, 4.1])
        rotate([90, 0, 0])
          cylinder(r = 4, h = motor_y*2.1);
    }
  }
  
  translate([-motor_tab-motor_x,motor_y,0])
    cube([motor_tab+motor_x*2,motor_y,motor_z]);
  
}

// simple holder for ball caster
module ball_caster_holder() {
  difference() {
    union() {
      //difference() {
        //
        translate([0, 0, -ball_caster_height/2])
          cylinder(h=ball_caster_height,r=ball_caster_r+1.5,$fn=50,center=true);
        //translate([0, 0, -ball_caster_height/2+1])
          //cube([ball_caster_r*2+1,ball_caster_r*2+1,ball_caster_height-2],center=true);
      //}
      // base disc
      translate([0, 0, -0.5])
        cylinder(h=1,d=ball_caster_r*2+3+10,$fn=50,center=true);

    }
  
    translate([0, 0, ball_caster_r+dreamster_base_thickness-distance_to_floor]){
      cylinder(h=ball_caster_height, r= ball_caster_r+0.5, $fn=50);
      sphere(r = ball_caster_r+0.5, $fn=50); 
    }
    translate([0,0,0]) {
      for(i=[1:3])
        rotate([0,0,120*i-30])
          translate([-ball_caster_support_holes, 0, -1-0.05])
            cylinder(d = 2.1, h = 1.1, $fn=50); 
    }
    
  }
}

module ball_caster_holder_sensor() {
  ball_caster_holder();
  difference(){
    translate([-20,-20,0-1])cube([40,20,1]);
    translate([0, 0, -1.1])
      cylinder(h=1.2,d=ball_caster_r*2+3+10,$fn=50);
  }  
}

//sphere and 3 holes for support used in base
module ball_caster() {
  translate([0, 0, ball_caster_r+dreamster_base_thickness/2-distance_to_floor])
    %sphere(r = ball_caster_r, $fn=50);
  translate([0,0,0]) {
    for(i=[1:3])
      rotate([0,0,120*i-30])
        translate([-ball_caster_support_holes, 0, -dreamster_base_thickness/2-0.05])
          cylinder(d = 2.1, h = dreamster_base_thickness*1.1, $fn=50); 
  }
}

module dreamster_base_holes() {
  translate([0, ball_caster_center, 0]) ball_caster();
  rotate(180,0,0)
    translate([0, ball_caster_center, 0]) ball_caster();
  
  //holes for arduino base
  translate([37.5/2, 60/2 + 3.5-6, -dreamster_base_thickness/2-0.1])
    cylinder(r = 1.6, h = battery_support_height+dreamster_base_thickness+0.2);
  translate([-37.5/2, -(60/2 + 3.5 + 5.25)-6, -dreamster_base_thickness/2-0.1])
    cylinder(r = 1.6, h = battery_support_height+dreamster_base_thickness+0.2);
  
  // floor sensors holes
  translate([0,28,0])
    cube([20,6,dreamster_base_thickness*1.1], center=true);
  
  // battery hole
  translate([0, -9, 0])
    cube([battery_hole_width, battery_hole_depth-2, dreamster_base_thickness + 0.2], center=true); 
  
}


module wheels_holes() {
  intersection(){
    union(){
      translate([-(wheel_hole_depth/2+35.85+10), 0, 0])
        cube([wheel_hole_depth, wheel_hole_width, wheel_hole_thickness],center=true);
      translate([wheel_hole_depth/2+35.85+10, 0, 0])
        cube([wheel_hole_depth, wheel_hole_width, wheel_hole_thickness],center=true);
    }
    cylinder(h=wheel_hole_thickness, r=dreamster_base_r-6, center=true);
  }
}

module battery_supports() {
  translate([37.5/2, 60/2 + 3.5, 0]) {
    union() {
      cube([14, 7, battery_support_height], center=true);           
        translate([3.5, -3.5, 0])
          cube([7, 14, battery_support_height], center=true);          
    }
  }

  translate([-battery_hole_width/2, -(battery_hole_depth/2 + 3.5 + 5.25), 0]) {
    rotate([0, 0, 180]) {
      union() {
        cube([14, 7, battery_support_height], center=true);           
          translate([3.5, -3.5, 0])
            cube([7, 14, battery_support_height], center=true);
      }
    }
  }
}



module dreamster_base() {
  difference() {
    union() {
      cylinder (h = dreamster_base_thickness, r = dreamster_base_r, center = true); 
          // LOGO
      translate([0, -6, dreamster_base_thickness/2 + battery_support_height/2 ])
        battery_supports();
      translate([-dreamster_base_r/2.9,dreamster_base_r/1.68,dreamster_base_thickness/2])
        rotate([0,0,216]) resize([48,0,1], auto=true) logo();

      //motor tabs
      translate([0,motor_axe_disp,0]){
        translate([-dreamster_base_r/1.80+motor_x, medida_servo/2,1.4])
          motor_support();
        translate([-dreamster_base_r/1.80+motor_x-motor_tab/2, -medida_servo/2-motor_y/2,1.4])
          rotate(180,0,0)
            translate([motor_tab/2,-motor_y/2,0])
              motor_support();

        translate([+dreamster_base_r/1.80-motor_x+motor_tab, medida_servo/2,1.4])
          motor_support();

        translate([+dreamster_base_r/1.80-motor_x+motor_tab/2, -medida_servo/2-motor_y/2,1.4])
          rotate(180,0,0)
            translate([motor_tab/2,-motor_y/2,0])
              motor_support();
      }
    }
    
    dreamster_base_holes();
    wheels_holes();
  }
}
 
//------------------------

module arduino_holes() {
  translate([17, -depth/2 + 10.5, -thickness/2-1])
    cube([10, 12, thickness+2], center=false);
  translate([2, -hole_pos_y, 0])
    cube([hole_width, hole_depth, thickness+2], 1, center=true);
  translate ([20, -depth/2 + 74, 0])
    cylinder (h = arduino_base_thickness+0.2, r = 1.8,center=true);
  translate ([20-1.1*25.4, -depth/2 + 74, 0])
    cylinder (h = arduino_base_thickness+0.2, r = 1.8,center=true);
  translate ([-22.5, -depth/2 + 74-25.4*2, 0])
    cylinder (h = arduino_base_thickness+0.2, r = 1.8,center=true);
  translate([-37.5/2+1, -(60/2 + 3.5 + 5.25)-6-1, 0])
    cylinder(h=arduino_base_thickness+0.2, r = 1.8, center=true);
}

module arduino_base() {
  difference() {
    translate([2,-9,0])
      cube([arduino_base_width, arduino_base_depth, arduino_base_thickness], center=true);   
    arduino_holes();
  }
}


module show() {
  dreamster_base();
  translate([0, ball_caster_center, -dreamster_base_thickness/2])
    ball_caster_holder_sensor();
  rotate([0,0,180]) translate([0,ball_caster_center, -dreamster_base_thickness/2]) ball_caster_holder ();
  translate([-1.15, 1, battery_support_height+2])
    arduino_base();
}

module print_base() {
  dreamster_base();
}

module print_accesories() {
  translate([0,0,arduino_base_thickness/2])arduino_base();
  translate([-2, -12, ball_caster_height])
    rotate([0,0,90])
      ball_caster_holder_sensor();
  translate([50, -10, ball_caster_height])
    rotate([0,0,90])
      ball_caster_holder();

}

//print_accesories();
//print_base();
show();

