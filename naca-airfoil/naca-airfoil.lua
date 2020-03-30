--[[
The MIT License (MIT)

Copyright (c) 2020 Loïc Fejoz

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
local implicit_precision = 0.1

function symmetrical_naca_airfoil(cfg)
   if cfg.thickness == nil then
      cfg.thickness = cfg.t * cfg.chord_length
   end
   if cfg.t == nil then
      cfg.t = cfg.thickness / cfg.chord_length
   end
   local p = math.floor(cfg.t * 100)
   cfg.naca_serie = '00' .. p
   if p < 10 then
      cfg.naca_serie = '0' .. cfg.naca_serie
   end
   local airfoil = implicit_solid(
      v(0, -cfg.thickness, 0),
      v(cfg.chord_length, cfg.thickness, cfg.length),
      implicit_precision,
[[
uniform float t = 0.12;
uniform float c = 40;
float solid(vec3 p) {
        float xc = p.x / c;
        float sdf = t / 0.2 *(0.2969 * sqrt(xc) - 0.1260 * xc - 0.3516 * pow(xc, 2) + 0.2843 * pow(xc, 3) - 0.1015 * pow(xc, 4));
        return abs(p.y) - sdf ;
}
]])
   set_uniform_scalar(airfoil, 't', cfg.thickness)
   set_uniform_scalar(airfoil, 'c', cfg.chord_length)
   return airfoil
end

local chord_length = ui_number('chord length (mm)', 50, 10, 200)
local thickness = ui_scalar('max thickness (mm)', 2, 0, 10)
local cfg = {
	chord_length = chord_length,
	thickness =thickness,
	length = 3,
}
emit(symmetrical_naca_airfoil(cfg))
print("NACA Profile " .. cfg.naca_serie)
--ui_number("NACA ", math.floor(cfg.t * 100), 0, 100)

emit(  translate(cfg.chord_length/2, cfg.thickness + 1, 0) * cube(cfg.chord_length, cfg.thickness, cfg.length), 3)

emit( translate(0, 2*cfg.thickness + 2, 0) * union{
	 translate(cfg.thickness/2, 0, 0) * cylinder(cfg.thickness/2.0, cfg.length),
	 translate(cfg.chord_length-cfg.thickness/2, 0, 0) * cylinder(cfg.thickness/2.0, cfg.length),	 
	 translate(cfg.chord_length/2, 0, 0) * cube(cfg.chord_length - cfg.thickness, cfg.thickness, cfg.length),
}, 4)
