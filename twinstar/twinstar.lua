width = 19.80
height = 2
inter_hole_length = 38
central_hole_radius = 5 / 2
central_hole_head_radius = 10 / 2
central_hole_head_height = 4
central_cylinder_height = 6
pin_radius = 5
pin_height = 11

function pin()
    return union{
        translate(0, 0, pin_height - pin_radius) * sphere(pin_radius),
        cylinder(pin_radius, pin_height - pin_radius)
    }
end

emit(
    difference{
      union{
        box(width, 2 * inter_hole_length, 2),
        translate(0, inter_hole_length, -height / 2) * cylinder(width / 2, height),
        translate(0, -inter_hole_length, -height / 2) * cylinder(width / 2, height),
        cylinder(13.8 / 2, central_cylinder_height),
        translate(0, inter_hole_length, 0) * pin(),
        translate(0, -inter_hole_length, 0) * pin(),
      },
      translate(0, 0, -central_cylinder_height) * cylinder(central_hole_radius, 2 * central_cylinder_height),
      translate(0, 0, -height/2) * cylinder(central_hole_head_radius, central_hole_head_height)
    })