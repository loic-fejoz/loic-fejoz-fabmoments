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

function tower(conf)
	function tower_side()
		return owall(conf.width, conf.wall.thickness, conf.height, conf.wall.stone)
	end
	return polygon(tower_side, 4, conf.width)
end

function castle(conf)
	local tower_conf = conf.tower
	tower_conf.width= conf.width/4
	tower_conf.height = conf.wall.height * 3
	tower_conf.wall.thickness=conf.wall.thickness
	function castle_side()
		return merge{
			tower(tower_conf),
			translate(tower_conf.width,0,0) * owall(0.5*conf.width, conf.wall.thickness, conf.wall.height, conf.wall.stone),
		}
	end
	return polygon(castle_side, conf.side, conf.width)
end

function samples()
	emit(castle{
		side=4,
		width=184,
		wall={
			thickness=5,
			height=35,
			stone={
				avg=v(12, 5, 5),
				delta=v(5, 0, 0),
				radius=1
			}
		},
		tower={
			wall={
				stone={
					avg=v(12, 7, 15),
					delta=v(5, 0, 0),
					radius=0.5
				}
			}
		}
	})
--	load_warp_shader(Path .. 'stone-warp.sh')
end	

-- If used as main script then display samples
-- see http://stackoverflow.com/questions/4521085/main-function-in-lua
if not pcall(getfenv, 4) then 
	samples();
end