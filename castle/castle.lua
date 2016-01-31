stone_stat = {
	avg=v(12, 5, 5),
	delta=v(5, 0, 0)
}

dofile(Path .. 'stone.lua')

-- function owall(x, y, z, r)
	-- return ocube(x,y,z)
-- end

function vrotate(angles)
	return rotate(angles.x, angles.y, angles.z)
end

function polygon(shaper, degree, width)
	local shapes = {}
	local pos = v(0,0,0)
	local dir = v(0,0,0)
	for side = 1, degree do
		table.insert(shapes, translate(pos) * vrotate(dir) * shaper())
		pos = pos + vrotate(dir) * v(width, 0, 0)
		dir = dir + v(0,0,360/degree)
	end
	return merge(shapes)
end

wall_length = v(stone_stat.avg.x * 12, stone_stat.avg.y, stone_stat.avg.z * 7)

function tower(conf)
	function tower_side()
		return owall(conf.width, conf.wall.thickness, conf.height, 0.5)
	end
	return polygon(tower_side, 4, conf.width)
end

function castle(conf)
	local tower_conf = {
		width= conf.width/4,
		height = conf.wall.height * 3,
		wall={
			thickness=conf.wall.thickness
		}
	}
	function castle_side()
		return merge{
			tower(tower_conf),
			translate(tower_conf.width,0,0) * owall(0.75*conf.width, conf.wall.thickness, conf.wall.height, 1),
		}
	end
	return polygon(castle_side, 4, tower_conf.width + wall_length.x)
end

function samples()
	emit(castle{
		width=stone_stat.avg.x * 16,
		wall={
			thickness=stone_stat.avg.y,
			height=stone_stat.avg.z * 7
		}
	})
--	load_warp_shader(Path .. 'stone-warp.sh')
end	

-- If used as main script then display samples
-- see http://stackoverflow.com/questions/4521085/main-function-in-lua
if not pcall(getfenv, 4) then 
	samples();
end