espesor_pared = 2;

largo_interno = 70;
ancho_interno = 38;
alto_interno = 19;

alto_externo = alto_interno + espesor_pared;
largo_externo = largo_interno + 2 * espesor_pared;
ancho_externo = ancho_interno + 2 * espesor_pared;

ancho_agujero = 15;
largo_agujero = 15;
alto_cola = 15;

ancho_llave = 16;
desp_ancho_llave = 13;

ancho_base = 42;
alto_base = 2.5;
delta_ancho = 0;

largo_base_interno = 42;

tornillo = 8;

radio = 94.25;
antigolpe = 8;


difference() {
  cube([ancho_externo,largo_externo,alto_externo]);
  translate([espesor_pared,espesor_pared,espesor_pared])
    cube([ancho_interno,largo_interno,alto_interno+.01]);
  translate([-.1,largo_externo-largo_agujero-espesor_pared,espesor_pared])
    cube([ancho_agujero+espesor_pared+.1,largo_agujero+espesor_pared+.01,alto_interno+.1]);
}

difference() {
	translate([-((ancho_base-ancho_externo)/2 - delta_ancho),0,-alto_base/3])
   		cube([ancho_base, largo_externo, alto_base]);
}

module pestania_agujero1(){
	difference(){
		translate([-2.5, -7.5, -alto_base/3])
			cube([10, 10, alto_base]);
		translate([2, -3.8, -alto_base/3])
			cylinder(h = alto_base*2, r = 1.8, $fn=25, center = false);
	}
}

module pestania_agujero2(){
	difference(){
		translate([39, 41.4, -alto_base/3])
			cube([9.3, 10, alto_base]);
		translate([45, 46.6, -alto_base/3])
			cylinder(h = alto_base*2, r = 1.8, $fn=25, center = false);
	}
}

pestania_agujero1();

pestania_agujero2();

*translate([46.5, 50, -5])
	cylinder(h = 10, r = 1.75, $fn=25, center = false);

*difference(){
  translate([ancho_externo-espesor_pared,0,-alto_cola-alto_base])
    cube([espesor_pared,largo_externo,alto_cola+alto_base+.1]);

  translate([ancho_externo-espesor_pared-.01,desp_ancho_llave,-alto_cola-alto_base-.01])
    cube([espesor_pared+.02,ancho_llave+.01,alto_base]);
}

