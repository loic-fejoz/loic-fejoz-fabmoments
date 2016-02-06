dofile(Path .. 'castle.lua')

function small_castle()
   emit(castle{
		side=ui_int("castle side", 4 , 4, 10),
		width=70,
		wall={
			thickness=4,
			height=20,
			stone={
				avg=v(8, 4, 4),
				delta=v(5, 0, 0),
				radius=1
			}
		},
		tower={
		   height=40,
            -- side = castle.side,
			wall={
				stone={
					avg=v(10, 4, 10),
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
	small_castle();
end
