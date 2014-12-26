--[[
The MIT License (MIT)

Copyright (c) 2014 Loïc Fejoz

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

-- @see https://en.wikipedia.org/wiki/Couillard

hole_tolerance=0.22
width=5
total_height=50
verge_length=2.5 * total_height
center_proportion = 0.33 --%
split_angle=15
hinge_radius=0.75
arm_length = total_height/2
delta =  1.5*width
small_part_length = center_proportion * verge_length / cos(split_angle) + width/tan(split_angle) + width/2
big_part_length = (1-center_proportion) * verge_length - delta
hole_radius = hinge_radius + hole_tolerance
arm_angle = 45

-- dofile('IcestoneSL.lua')
--================================ from IcestoneSL =======================================================================
----
-- pie_sector(r, a, h) creates a shape that fits into a cylinder of radius r and heigh h, and has angle a.
-- The sector is aligned on the X axis. The end is at the origin. It lies on floor.
-- @return a pie sector
function pie_sector(radius, angle, height)
   local box_width = 3 * radius
   return difference{
      cylinder(radius, height),
      rotate(0, 0, -angle/2) * translate(0, box_width/2, height/2) * scale(box_width, box_width, 2 * height) * box(1),
      rotate(0, 0, angle/2) * translate(0, -box_width/2, height/2) * scale(box_width, box_width, 2 * height) * box(1)
   }
end

----
-- pie_sector(r, a, h) creates a shape that fits into a cylinder of radius r and heigh h, and has angle a.
-- The sector is aligned on the X axis. The end is at the origin. It lies on floor.
-- The resulting shape has attribute small_center that provides the center of the small circle.
-- @return a pie sector
function rounded_pie_sector(radius, angle, height, small_radius)
   local delta = small_radius / sin(angle/2)
   local l = small_radius/tan(radius/2)
   local small_center = v(-delta, 0, 0)
   local result = difference{
      pie_sector(radius, angle, height),
      difference{
	 translate(-l/2, 0, height/2) * scale(l, l, 2 * height) * box(1),
	 translate(-delta, 0, -height/2) * cylinder(small_radius, 2 * height)
      }
   }
   result.small_center = small_center
   result.height = height
   result.radius = radius
   result.small_radius = small_radius
   result.angle = angle
   return result
end
--====================================================================================================================

function two_arms()
   return union({
	 translate(0, cos(arm_angle) * (width+arm_length/2), sin(arm_angle) * (arm_length/2)) * rotate(arm_angle, 0, 0) * translate(0, 0, width) * scale(width, width, arm_length) * box(1),
	 translate(0, -cos(arm_angle) * (width + arm_length/2), sin(arm_angle) * (arm_length/2)) * rotate(-arm_angle, 0, 0) * translate(0, 0, width) * scale(width, width, arm_length) * box(1),
   })
end

function support()
   virtual_hinge_length = 2 * width
   return difference{
      union{
	 translate(0, 0, total_height/2) * scale(width, width, total_height) * box(1),
	 translate(0, 0, width/2) * rotate(90, 0, 0) * scale(width, width, total_height) * box(1),
	 translate(0, 0, width/2) * rotate(90, 0, 90) * scale(width, width, total_height) * box(1),
	 two_arms(),
	 rotate(0, 0, 90) * two_arms(),
      },
      translate(-virtual_hinge_length/2, 0, total_height - width/2) * rotate(0,90,0) * cylinder(hole_radius, virtual_hinge_length)
   }
end

function verge()
   local virtual_hinge_length = 4 * width
   local part = difference{
      scale(width, small_part_length , width) * box(1),
      translate(0, -small_part_length/2 + 2 * hinge_radius, 0) * rotate(0, 90, 0) * translate(0, 0, -virtual_hinge_length/2) *  cylinder(hole_radius, virtual_hinge_length), -- counterweight holes
   }
   local left_transfo = translate(-width/2, width/2, 0) * rotate(0, 0, -split_angle) * translate(-width/2, width/tan(split_angle)-small_part_length/2, 0)
   local right_transfo = translate(width/2, width/2, 0) * rotate(0, 0, split_angle) * translate(width/2, width/tan(split_angle)-small_part_length/2, 0)
   local result =union{
      difference{
	 union{
	    right_transfo * part, -- right part
	    left_transfo * part, -- left part
	    translate(0, delta + big_part_length/2, 0) * scale(width, big_part_length, width) * box(1), -- longer part
	 },
	 translate(-virtual_hinge_length/2, 0, 0) * rotate(0,90,0) * cylinder(hole_radius, virtual_hinge_length), -- main axis hole
	 translate(-virtual_hinge_length/2, big_part_length + delta - 2 * hinge_radius, 0) * rotate(0,90,0) * cylinder(hole_radius, virtual_hinge_length), -- sling hole,
	 scale(width + 2*hole_tolerance, 2 * delta, 2 * delta) * box(1) -- spaces to let the verge rotates
      },
   }
   result.left_center = left_transfo *  v(0, -small_part_length/2 + 2 * hinge_radius, 0)
   result.right_center = right_transfo *  v(0, -small_part_length/2 + 2 * hinge_radius, 0)
   return result
end

function hinge()
   real_hinge_length = 4 * width
   local result = rotate(0, 90, 0) * translate(0, 0, -real_hinge_length/2) * cylinder(hinge_radius, real_hinge_length)
   result.radius = hinge_radius
   return result
end

function counterweight()
   local height = 3 * width
   local angle = 30
   local radius = 30
   local small_radius = 3
   local pie = rounded_pie_sector(radius, angle, height, small_radius)
   local virtual_hinge_length = 2 * pie.height
   local c = difference{
      pie,
      translate(pie.small_center) * translate(0, 0, -virtual_hinge_length/4) * cylinder(hole_radius, virtual_hinge_length), -- hole
      translate(0, 0, height/2) * translate(pie.small_center) * scale(3 * pie.small_radius, 3 * pie.small_radius, pie.height / 2) * box(1)
   }
   local center =  v(pie.small_center.x, pie.small_center.y, height/2)
   local result = translate(-1 * center) * c
   result.height = height
   result.center = center
   result.width = 2 * sin(angle/2) * radius
   result.angle = angle
   result.small_radius = small_radius
   return result
end

function print3d()
   local c1 = counterweight()
   local c2 = counterweight()
   local h = hinge()
   return scale(1) *
      union({
	    handle('support', translate(-total_height/2, 0, 0) * support()),
	    handle('verge', translate(sin(split_angle) * small_part_length, 0, width/2) * verge()),
	    handle('hinges', union{
		      translate(-10, -width, h.radius) * h,
		      translate(-10, -2*width, h.radius) * h,
		      translate(-10, -3*width, h.radius) * h,
	    }),
	    handle('counter_weight1', translate(1.1*width, c1.height, 0) * rotate(-90, 0, 0) * translate(0, -c1.small_radius, c1.height/2) * rotate(0, 0, c1.angle/2) *  c1),
	    handle('counter_weight2', translate(1.1*width, c1.height + c2.height + 1, 0) * rotate(-90, 0, 0) * translate(0, -c2.small_radius, c2.height/2) * rotate(0, 0, c2.angle/2) * c2),
      })
end

function mounted()
   local v = verge()
   local verge_transfo = translate(0, 0, total_height-width/2)
   return scale(1) *
      union({
	    support(),
	    translate(0, 0, total_height-width/2) * v,
	    translate(0, 0, total_height-width/2) * hinge(),
	    verge_transfo * translate(v.left_center) * rotate(0, -90, -split_angle) * counterweight(), -- left
	    verge_transfo * translate(v.right_center) * rotate(0, -90, split_angle) * counterweight(), -- right
	    -- counterweight hinges are not displayed
      })
end

--emit(print3d(), 0)
emit(mounted(), 0)
