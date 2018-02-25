require('gear')

set_brush_color(0, 255, 255, 255)
set_brush_color(1, 255, 0, 0)

b = gear{
  number_of_teeth=25,
  circular_pitch=400,
  hub_diameter=0,
  gear_thickness = 12,
  rim_thickness = 12,
  bore_diameter = 0,
  circles=0}
emit(b)

f = font('C:\\Windows\\Fonts\\calibri.ttf')
A = scale(0.8) * f:str('A', 10)
center_A = bbox(A):center()
A = translate(-center_A.x, -center_A.y, 12) * A
emit(A, 1)
