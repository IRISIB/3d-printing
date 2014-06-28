// TRY IT!
brick(4,4,1);



// BASE DEFINITION
unit_width = 8;
unit_height = 3.2;
pin_radius = 2.43;   // Adjusted by measuring real pieces
pin_height = 1.6;	// Adjusted by measuring real pieces
thickness = 1.52;	// Adjusted by measuring real pieces
central_cylinder_inner_radius = 4.8/2;
central_cylinder_outer_radius = 6.5/2;

// Returns true if number is pair
function isPair(value) = value/2 == ceil(value/2);

// Draw a simple "pin"
module pin() {
	scale([0.25,0.25,1]) cylinder(h=pin_height+0.5, r=pin_radius*4,center=false);
}

// Draw inner reinforcement cylinder
module inside_cylinder(height) {
	difference() {
		scale([0.25,0.25,1])cylinder(h=height-thickness, r=central_cylinder_outer_radius*4, center=false);
		translate([0,0,-thickness/2]) scale([0.25,0.25,1]) cylinder(h=height, r=central_cylinder_inner_radius*4, center=false);
	}
}

// Draw a brick for the given x,y,z values given
module brick(xunit, yunit, zunit) {
	x = xunit * unit_width - 0.2;
	y = yunit * unit_width - 0.2;
	z = zunit * unit_height; 
	xmax = xunit-1;
	ymax = yunit-1;
	union() {
		difference() {
			union() {
				cube([x,y,z]);
				for ( dx = [0:xmax] ,  dy = [0:ymax] ) {
					assign(	
								pin_x = unit_width/2 - 0.1 + unit_width*dx,
								pin_y	 = unit_width/2 - 0.1 + unit_width*dy,
								pin_z = z
					) {
						translate([pin_x, pin_y, pin_z-0.5]) pin();
					}
				}
			}
			translate([thickness,thickness,-0.5*thickness]) cube([x-2*thickness,y-2*thickness,z-0.5*thickness]);
		}
		if ( xunit>1 && yunit>1 ) {
			for( cx = [0:xunit-2], cy = [0:yunit-2] ) {
				assign( cyl_x = unit_width - 0.1 + unit_width*cx, cyl_y = unit_width - 0.1 + unit_width*cy) {
					translate([cyl_x,cyl_y,0]) inside_cylinder(z);
				}
			}
		}
	}
}



