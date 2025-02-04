--[[
The MIT License (MIT)

Copyright (c) 2016 Loïc Fejoz

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


function rand_float(min, max)
   return min + math.random() * (max-min)
end

function orounded_rectangle(x, y, z, r)
  return merge{
	translate(x-r,y-r,z-r) * sphere(r),
	translate(x-r,y-r,r) * sphere(r),
	translate(x-r,r,z-r) * sphere(r),
	translate(x-r,r,r) * sphere(r),
	translate(r,y-r,z-r) * sphere(r),
	translate(r,y-r,r) * sphere(r),
	translate(r,r,z-r) * sphere(r),
	translate(r,r,r) * sphere(r),
	translate(0,r,r) * ocube(x,y-2*r,z-2*r),
	translate(r,0,r) * ocube(x-2*r,y,z-2*r),
	translate(r,r,0) * ocube(x-2*r,y-2*r,z),
	translate(r,r,r)*cylinder(r,z-2*r),
	translate(x-r,r,r)*cylinder(r,z-2*r),
	translate(r,y-r,r)*cylinder(r,z-2*r),
	translate(x-r,y-r,r)*cylinder(r,z-2*r),
	
	translate(r,r,r)*rotate(0,90,0)*cylinder(r,x-2*r),
	translate(r,r,z-r)*rotate(0,90,0)*cylinder(r,x-2*r),
	translate(r,y-r,r)*rotate(0,90,0)*cylinder(r,x-2*r),
	translate(r,y-r,z-r)*rotate(0,90,0)*cylinder(r,x-2*r),
	
	translate(r,r,r)*rotate(-90,0,0)*cylinder(r,y-2*r),
	translate(r,r,z-r)*rotate(-90,0,0)*cylinder(r,y-2*r),
	translate(x-r,r,r)*rotate(-90,0,0)*cylinder(r,y-2*r),
	translate(x-r,r,z-r)*rotate(-90,0,0)*cylinder(r,y-2*r),
  }
end

function orounded_rectangle3(s, r)
	return orounded_rectangle(s.x, s.y, s.z, r)
end

function crounded_rectangle(x, y, z, r)
	return	translate(-x/2,-y/2,-z/2) * orounded_rectangle(x,y,z,r)
end

function rand_block_size(size_left, stone_stat)
	local s_min = stone_stat.avg - stone_stat.delta
	local s_max = stone_stat.avg + stone_stat.delta
	local s = v(
		rand_float(s_min.x, s_max.x),
		size_left.y,--rand_float(s_min.y, s_max.y),
		rand_float(s_min.z, s_max.z)
	)
	if size_left.x <= s.x then
		s.x = size_left.x
	end
	if size_left.y <= s.y then
		s.y = size_left.y
	end
	if size_left.z <= s.z then
		s.z = size_left.z
	end
	return s
end

function owall(x, y, z, conf)
	r = conf.radius
	blocks = {}
	dy = 0
	dz = 0
	while dz < z do
		dx = 0
		while dx < x do
			local left_size = v(x-dx, y-dy,z-dz)
			local size = rand_block_size(left_size, conf)
			s = translate(dx, 0, dz) * orounded_rectangle3(size, math.min(r, size.x/2))
			table.insert(blocks,s)
			dx =  dx + size.x
		end
		dz = dz + conf.avg.z
	end
  return merge(blocks)
end

function samples()
	local conf = {
		avg=v(12, 5, 5),
		delta=v(5, 0, 0),
		radius=1
	}
	emit(owall(conf.avg.x * 6, conf.avg.y, conf.avg.z * 7, conf))
	load_warp_shader(Path .. 'stone-warp.sh')
end	

-- If used as main script then display samples
-- see http://stackoverflow.com/questions/4521085/main-function-in-lua
if not pcall(getfenv, 4) then 
	samples();
end
