--[[
The MIT License (MIT)

Copyright (c) 2018 Loïc Fejoz

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
local centers = {}

local n = 6
local m = 6
local height = 8 -- #lines
local armlength = 15 -- distance between spheres
local display_flat=false
local epsilon = 0.01


local dir0 = v(armlength * cos(-30), armlength * sin(-30), 0)
--emit(cone(2, 1, v(0,0,0), dir0), 7)
local sign = 1

local a1 = dir0 + rotate(0, 0, 60) * dir0
local a2 = rotate(0, 0, -60) * dir0 + dir0
--emit(cone(2, 1, v(0,0,0), a1), 1)
--emit(cone(2, 1, v(0,0,0), a2), 1)

local linespace = -a2 + rotate(0, 0, 60) * a1
--emit(cone(2, 1, v(0,0,0), linespace), 1)
local y0 = height/2 * linespace--rotate(0, 0, 120) * ((height + ((height+2) % 2)) * dir0)
--emit(cone(2, 1, v(0,0,0), y0), 1)

local ch = n * a1 + m * a2
local ch4closing = ch + a1 -- Trick here to get a closed tube
local ch_angle = acos(dot(v(1, 0, 0), normalize(ch)))
--emit(cone(2, 1, v(0,0,0), ch), 2)
local y1 = rotate(0, 0, -ch_angle) * y0
--emit(cone(2, 1, v(0,0,0), y1), 4)
local s1 = ch + y1
--emit(cone(2, 1, v(0,0,0), s1), 4)

local ch_length = length(ch) + epsilon
local ch_length_pow2 = ch_length * ch_length
local ch4closing_length = length(ch4closing) + epsilon
local ch4closing_length_pow2 = ch4closing_length* ch4closing_length
local y1_length = length(y1) + epsilon
local y1_length_pow2 = y1_length * y1_length

local R = ch_length / (2 * math.pi)

local max_i = 2*math.ceil(s1.x / a1.x) + 10
print("max_i = " .. max_i)

local min_row = 2*math.floor(ch.y / linespace.y) - 2
print("min_row = " .. min_row)
local max_row = 2*math.floor(y1.y / linespace.y) + 2
assert(max_row - min_row >= height)

local dir = dir0

if display_flat then
   emit(rotate(0, 0, -ch_angle) * translate(ch_length/2, y1_length/2, -5) * cube(ch_length, y1_length, 0.5), 1)
end

for row=min_row,max_row do
   assert(1 + row - min_row > 0)
   local  p0 = row * (v(0, armlength, 0) - dir0)
   local p = p0
   for i=1,max_i do
      -- first coordinate conversion
      local p_prime = rotate(0, 0, ch_angle) * p
      -- second coordinate conversion from plane to cylinder
      local theta = 360 * p_prime.x / ch_length
      local p_second = v(R * cos(theta), R * sin(theta), p_prime.y)
      -- Track centers in a grid like system
      if dot(ch4closing, p) >= 0 and dot(y1, p) >= 0 and dot(ch4closing, p) <= ch4closing_length_pow2 and dot(y1, p) <= y1_length_pow2 then
	 local final_point
	 if display_flat then
	    final_point = p
	 else
	    final_point = p_second
	 end
	 centers[math.pow(10, 1 + row - min_row) + i] = final_point
      end
      -- Moveto next point in row
      p = p0 + (math.floor((i+1)/2) * (rotate(0, 0, 60) * dir0)) + (math.floor(i/2) * dir0)
   end
   dir = dir0
end

--emit(ccube(3)) -- display the origin

function join(c0, c1)
   if c0 ~= nil and c1 ~= nil then
      emit(cone(1, 1, c0, c1))
   end
end

for row=min_row,max_row do
   for i=1,max_i do
      local c0 = centers[math.pow(10, 1 + row - min_row) + i]
      local c1 = centers[math.pow(10, 1 + row - min_row) + i+1]
      local c2 = centers[math.pow(10, 1 + row - min_row +1) + i]
      local c3 = centers[math.pow(10, 1 + row - min_row +1) + i+1]

      if c0 ~= nil then
	 emit(translate(c0) * sphere(4), i)
	 join(c0, c1)
	 if i % 2 == 0 then
	    join(c0, c3)
	 end
      end
   end
end
