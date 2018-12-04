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
local laserslicer = {}

function laserslicer.defaultCfg(the_mesh, cut_or_display)
   local cfg = {}
   cfg.cut = cut_or_display
   cfg.shape = the_mesh
   cfg.board = {}
   cfg.board.height = 1
   cfg.stick = {}
   cfg.stick.diameter = 2.1
   cfg.stick.show = true and not cfg.cut
   cfg.stick.shape = nil
   cfg.spaces = {}
   cfg.spaces.x = 2
   cfg.spaces.y = 2
   cfg.dz = 0.001
   return cfg
end

function laserslicer.slice(cfg)
   local b = bbox(cfg.shape)
   cfg.nb_slices = math.floor(b:max_corner().z / cfg.board.height)
   print("#slices: " .. cfg.nb_slices)
   print("size: " .. (cfg.board.height * cfg.nb_slices) .. "mm")

   cfg.dx = b:max_corner().x - b:min_corner().x
   cfg.dy = b:max_corner().y - b:min_corner().y
   cfg.dz = 0.001
   local basic_slice = cube(cfg.dx, cfg.dy, cfg.dz)

   local sticks
   if cfg.stick.shape == nil then
      sticks = cylinder(cfg.stick.diameter / 2, b:max_corner().z - b:min_corner().z + cfg.board.height)
   else
      sticks = cfg.stick.shape
   end
   if cfg.stick.show then
      emit(sticks, 2)
   end

   slices = {}
   for idx=1,cfg.nb_slices do
      local s = intersection(cfg.shape, translate(0, 0, cfg.board.height * idx) * basic_slice)
      local slice_scale = cfg.board.height / cfg.dz
      s = translate(0, 0, cfg.board.height * idx) * scale(1, 1, slice_scale) * translate(0, 0, -cfg.board.height * idx) * s
      slices[idx] = difference(s, sticks)
      if not cfg.cut then
	 emit(slices[idx])
      end
   end

   -- 32cm x 19cm
   if cfg.cut then
      s_x = 0
      s_y = 0
      max_y = 0
      for idx=1,cfg.nb_slices do
	 if (s_x > 275) then
	    s_x = 0
	    s_y = s_y - max_y + cfg.spaces.y
	    max_y = 0
	 end

	 local s = slices[idx]
	 local b = bbox(s)
	 s = translate(s_x, s_y, -cfg.board.height * idx) * s
	 s_x = s_x +  b:max_corner().x -b:min_corner().x + cfg.spaces.x
	 max_y = math.max(max_y, b:max_corner().y - b:min_corner().y)
	 emit(s)
      end
   end
end

return laserslicer
