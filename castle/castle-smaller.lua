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
