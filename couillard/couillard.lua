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
width=3
total_height=60
verge_length=2.5 * total_height
center_proportion = 0.33 --%
split_angle=15
hinge_radius=0.75
arm_length = total_height/2
delta =  1.5*width
small_part_length = center_proportion * verge_length / cos(split_angle) + width/tan(split_angle) + width/2
big_part_length = (1-center_proportion) * verge_length - delta
hole_radius = hinge_radius + hole_tolerance

dofile('IcestoneSL.lua')

function two_arms()
   return union({
	 translate(0, cos(45) * (width + arm_length/2), sin(45) * arm_length/2) * rotate(45, 0, 0) * translate(0, 0, width) * scale(width, width, arm_length) * box(1),
	 translate(0, -cos(45) * (width + arm_length/2), sin(45) * arm_length/2) * rotate(-45, 0, 0) * translate(0, 0, width) * scale(width, width, arm_length) * box(1),
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
   result = union{difference{
      union{
	 translate(width/2, width/2, 0) * rotate(0, 0, split_angle) * translate(width/2, width/tan(split_angle)-small_part_length/2, 0) * part, -- right part
	 translate(-width/2, width/2, 0) * rotate(0, 0, -split_angle) * translate(-width/2, width/tan(split_angle)-small_part_length/2, 0) * part, -- left part
	 translate(0, delta + big_part_length/2, 0) * scale(width, big_part_length, width) * box(1), -- longer part
      },
      translate(-virtual_hinge_length/2, 0, 0) * rotate(0,90,0) * cylinder(hole_radius, virtual_hinge_length), -- main axis
      translate(-virtual_hinge_length/2, big_part_length + delta - 2 * hinge_radius, 0) * rotate(0,90,0) * cylinder(hole_radius, virtual_hinge_length), -- sling hole
			    },
   }
   return result
end

function hinge()
   real_hinge_length = 4 * width
   return rotate(0, 90, 0) * translate(0, 0, -real_hinge_length/2) * cylinder(hinge_radius, real_hinge_length)
end

function counterweight()
   local height = 3 * width
   local angle = 30
   local radius = 30
   local pie = rounded_pie_sector(radius, angle, height, 3)
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
   return result
end

function print3d()
   c1 = counterweight()
   c2 = counterweight()
   return scale(1) *
      union({
	    handle(translate(-total_height/2, 0, 0) * support()),
	    handle(translate(sin(split_angle) * small_part_length, 0, width/2) * verge()),
	    translate(width, 0, 0) * rotate(0, 0, 90) * hinge(),
	    translate(10, c1.width, c1.height/2) * c1,
	    translate(10, c1.width + c2.width + hole_tolerance, c2.height/2) * c2,
      })
end

function mounted()
   return scale(1) *
      union({
	    support(),
	    translate(0, 0, total_height-width/2) * verge(),
	    translate(0, 0, total_height-width/2) * hinge(),
	    translate(0, 0, 0) * rotate(0, -90, split_angle) * counterweight()
      })
end

emit(print3d(), 0)
--emit(mounted(), 0)
--emit(translate(0, (verge_length/2) - (center_proportion*verge_length), width/2) * scale(width, verge_length, width) * box(1), 1)
--emit(translate(0,0,50) * scale(1,1,100) * box(1), 0)
--emit(translate(0,50,0) * scale(1,100,1) * box(1), 0)
--emit(translate(50,0,0) * scale(100,1,1) * box(1), 0)
--emit(counterweight(), 1)
