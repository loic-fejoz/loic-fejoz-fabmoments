//The MIT License (MIT)
//
//Copyright (c) 2014 Loïc Fejoz
//
//Permission is hereby granted, free of charge, to any person obtaining a copy of
//this software and associated documentation files (the "Software"), to deal in
//the Software without restriction, including without limitation the rights to
//use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//the Software, and to permit persons to whom the Software is furnished to do so,
//subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

inner_tolerance=0.3; // Tolerance for hole

total_length=58;
big_cylinder_length=19;
big_cylinder_radius=16 / 2;
mouthpiece_height=6;
mouthpiece_width=14.5;
mouthpiece_length=12;
bigger_part_length=33;
step_length=5;
pipe_radius=(12.8 / 2) + inner_tolerance;
mouthpiece_inner_height=1.8;
mouthpiece_inner_width=8.8;
hole_width=8.5;
hole_length=6;
hole_angle=25;

sc = 100;
epsilon=5;
really_long=total_length;
difference() {
	union() {
        // Mouthpiece part
        // PROFILE_B = ellipse... = 
		translate([0, big_cylinder_radius - mouthpiece_height/2, big_cylinder_length])
		  scale([mouthpiece_width/sc,mouthpiece_height/sc,1])
			cylinder(h = total_length-big_cylinder_length, r1 = sc/2, r2 = sc/2, center = false);

       // big cylinder part
		cylinder(h = big_cylinder_length, r1 = big_cylinder_radius, r2 = big_cylinder_radius, center = false);

       // connection to mouthpiece
		hull() {
          // PROFILE_B =
		  translate([0, big_cylinder_radius - mouthpiece_height/2, total_length-mouthpiece_length])
		    scale([mouthpiece_width/sc,mouthpiece_height/sc,1])
		      cylinder(h = 1, r1 = sc/2, r2 = sc/2, center = false);
		  // PROFILE_A =
		  translate([0,0, bigger_part_length])
		    hull() {
		      translate([0, big_cylinder_radius - mouthpiece_height/2, 0])
		        scale([mouthpiece_width/sc,mouthpiece_height/sc,1])
		          cylinder(h = 1, r1 = sc/2, r2 = sc/2, center = false);
		      cylinder(h = 1, r1 = big_cylinder_radius, r2 = big_cylinder_radius, center = false);
		    }
		}
		// connection to big cylinder
		hull() {
		  // PROFILE_A =
		  translate([0, 0, big_cylinder_length])
		    hull() {
		      translate([0, big_cylinder_radius - mouthpiece_height/2, 0])
		        scale([mouthpiece_width/sc,mouthpiece_height/sc,1])
		          cylinder(h = 1, r1 = sc/2, r2 = sc/2, center = false);
		      cylinder(h = 1, r1 = big_cylinder_radius, r2 = big_cylinder_radius, center = false);
		    }
		  translate([0, 0, big_cylinder_length-step_length])
		     cylinder(h = 1, r1 = big_cylinder_radius, r2 = big_cylinder_radius, center = false);
		}
		
		// Middle part
		// scale([1, 1, bigger_part_length - big_cylinder_length]) * PROFILE_A =
		translate([0, 0, big_cylinder_length])
		  hull() {
		    translate([0, big_cylinder_radius - mouthpiece_height/2, 0])
		      scale([mouthpiece_width/sc,mouthpiece_height/sc,1])
		        cylinder(h = bigger_part_length - big_cylinder_length, r1 = sc/2, r2 = sc/2, center = false);
		    cylinder(h = bigger_part_length - big_cylinder_length, r1 = big_cylinder_radius, r2 = big_cylinder_radius, center = false);
		  };
		// BOX_1 =
		translate([0, big_cylinder_radius-mouthpiece_inner_height, bigger_part_length-hole_length])
			cube(size=[hole_width, mouthpiece_inner_height, 2*hole_length], center=true);
	};
    // Now create holes...
	translate([0, 0, -epsilon])
		difference() {
			cylinder(h = bigger_part_length+epsilon, r1 = pipe_radius, r2 = pipe_radius, center = false);
           // minus BOX_1
			translate([-hole_width/2, big_cylinder_radius - mouthpiece_height/2, bigger_part_length-hole_length])
				cube(size=[hole_width, 2*mouthpiece_inner_height, 2*hole_length], center=false);
		};
	translate([0, big_cylinder_radius - mouthpiece_height/2, bigger_part_length+total_length/2-epsilon])
		cube(size=[mouthpiece_inner_width, mouthpiece_inner_height, total_length], center =true);
	translate([0, really_long/2, bigger_part_length-hole_length/2])
		cube(size=[hole_width, really_long, hole_length], center=true);
	translate([0, big_cylinder_radius , bigger_part_length - hole_length + sin(hole_angle)*hole_length/2 ])
		rotate([-90+hole_angle, 0, 0])
			translate([0, really_long/2, 0])
				cube(size=[hole_width, really_long, hole_length], center=true);
}