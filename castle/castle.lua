with_details = true

if with_details then
	dofile(Path .. 'stone.lua')
else
	function orounded_rectangle(x, y, z, r)
		return ocube(x,y,z)
	end

	function owall(x, y, z, r)
		return ocube(x,y,z)
	end
end

if ui_scalar == nil then
  function ui_scalar(a, b ,c , d)
    return b
  end
end

if ui_int == nil then
  function ui_int(label, current, min_val, max_val)
    return math.floor(ui_scalar(label, current, min_val, max_val))
  end
end

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
		return merge{
			translate(conf.width/3, 0, conf.height) * orounded_rectangle(conf.width/3, conf.wall.thickness, conf.wall.stone.avg.z*0.75, conf.wall.stone.radius),
			translate(0, 0, conf.height) * orounded_rectangle(conf.width/6, conf.wall.thickness, conf.wall.stone.avg.z*0.75, conf.wall.stone.radius),
			translate(5*conf.width/6, 0, conf.height) * orounded_rectangle(conf.width/6, conf.wall.thickness, conf.wall.stone.avg.z*0.75, conf.wall.stone.radius),
			owall(conf.width, conf.wall.thickness, conf.height, conf.wall.stone)
		}
	end
	return polygon(tower_side, conf.side, conf.width)
end

function castle(conf)
	local tower_conf = conf.tower
	if tower_conf.side == undefined then
		tower_conf.side = conf.side
	end
	if tower_conf.width == undefined then
		tower_conf.width= conf.width/tower_conf.side
	end
	if tower_conf.height == undefined then
		tower_conf.height = conf.wall.height * 3
	end
	if tower_conf.wall == undefined then
		tower_conf.wall = conf.wall
	end
	if tower_conf.wall.thickness == undefined then
		tower_conf.wall.thickness=conf.wall.thickness
	end
	function castle_side()
		return merge{
			tower(tower_conf),
			translate(tower_conf.width,0,0) * owall(conf.width-2*tower_conf.width, conf.wall.thickness, conf.wall.height, conf.wall.stone),
		}
	end
	return polygon(castle_side, conf.side, conf.width)
end

function samples()
	emit(castle{
		side=ui_int("castle side", 4 , 4, 10),
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
            -- side = castle.side,
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