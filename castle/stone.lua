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

stone_stat = {
	avg=v(12, 5, 5),
	delta=v(5, 0, 0)
}

function rand_block_size(size_left)
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

function owall(x, y, z, r)
	blocks = {}
	dy = 0
	dz = 0
	while dz < z do
		dx = 0
		while dx < x do
			local left_size = v(x-dx, y-dy,z-dz)
			local size = rand_block_size(left_size)
			s = translate(dx, 0, dz) * orounded_rectangle3(size, math.min(r, size.x/2))
			table.insert(blocks,s)
			dx =  dx + size.x
		end
		dz = dz + stone_stat.avg.z
	end
  return merge(blocks)
end

function samples()
	emit(owall(stone_stat.avg.x * 6, stone_stat.avg.y, stone_stat.avg.z * 7, 1))
	load_warp_shader(Path .. 'stone-warp.sh')
end	

-- If used as main script then display samples
-- see http://stackoverflow.com/questions/4521085/main-function-in-lua
if not pcall(getfenv, 4) then 
	samples();
end
