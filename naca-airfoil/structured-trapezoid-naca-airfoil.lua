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

function trapezoid_symmetrical_naca_airfoil(cfg)
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
      v(0, -cfg.thickness/2, 0),
      v(cfg.sweep + cfg.length, cfg.thickness/2, cfg.height),
      implicit_precision,
[[
uniform highp float t = 0.12;
uniform highp float chord_length = 40.0;
uniform highp float sweep_coeff = 0.0;
uniform highp float chord_coeff = 0.0;
uniform highp float wall_thickness = 0.35;
uniform highp float dist = 15.0;
highp float solid(vec3 p) {
        highp float c = chord_length - chord_coeff*p.z;
        highp float x = p.x - sweep_coeff * p.z;
        // This avoid some numerical instabilities
        if (x < 0 || x > c) {
          return 1;
        }
        highp float xc = x / c;
        highp float sdf = t / 0.2 *(0.2969 * sqrt(xc) - 0.1260 * xc - 0.3516 * pow(xc, 2) + 0.2843 * pow(xc, 3) - 0.1015 * pow(xc, 4));
        sdf = abs(p.y) - sdf;
        highp float profile_sdf = abs(sdf + wall_thickness) - wall_thickness;

        // Now compute structures
        highp float s1 = mod(p.x + p.z, dist) - wall_thickness;
        highp float s2 = mod(-p.x + p.z, dist) - wall_thickness;
        highp float s = min(s1, s2);
        //vec3 q = mod(p+0.5*dist, dist/2)-0.5*dist;
        vec3 q;
        q.y = mod(p.y+0.25*dist,dist/2)-0.25*dist;
        q.x = mod(p.x+0.5*dist,dist/2)-0.25*dist;
        q.z = mod(p.z+0.5*dist,dist/2)-0.25*dist;
        highp float void_structures = length(q)- dist/5;
        s = max(-void_structures,max(sdf, s)); // void structures
        return min(max(sdf, s), profile_sdf);
}
]])
   set_uniform_scalar(airfoil, 'wall_thickness', cfg.wall_thickness)
   set_uniform_scalar(airfoil, 't', cfg.thickness)
   set_uniform_scalar(airfoil, 'chord_length', cfg.root_chord)
   set_uniform_scalar(airfoil, 'sweep_coeff', cfg.sweep/cfg.height)
   set_uniform_scalar(airfoil, 'chord_coeff', (cfg.root_chord - cfg.tip_chord)/cfg.height)
   return airfoil
end

local chord_length = ui_number('chord length (mm)', 50, 10, 200)
local root_chord = ui_number('root chord (mm)', 58, 10, 200)
local sweep = ui_number('sweep (mm)', 81, 0, 200)
local tip_chord = ui_number('tip chord (mm)', 30, 0, 200)
local thickness = ui_scalar('max thickness (mm)', 10, 0, 10)
local fin_height = ui_number('height (mm)', 38, 1, 100)
local wall_thickness = ui_scalar('wall thickness (mm/100)', 35, 0, 40) / 100
local cfg = {
   chord_length = chord_length,
   fin_count = 1,
	
    cant_angle = 0.017453292519943295,
    fillet_radius = 0.0,
    cross_section = 'AIRFOIL',
    tab_points = {},
    root_points = {v(0.0, 0.0, 0.0),v(57.99999999999999, 0.0, 0.0),},
    body_radius = 0,
    length = 58.000000000000014,
    position = v(0.0, 0.0, 0.0),
    axial_offset = 0.0,
    tip_chord = tip_chord,
    sweep = sweep,
    height = fin_height,
    root_chord = root_chord,
    position = v(0.0, 0.0, 0.0),
    thickness = thickness,
    wall_thickness = wall_thickness,
    fin_points = {
       v(0.0, 0.0, 0.0),
       v(sweep, fin_height, 0.0),
       v(sweep+tip_chord, fin_height, 0.0),
       v(root_chord, 0.0, 0.0),
    },
}
emit(trapezoid_symmetrical_naca_airfoil(cfg))
print("NACA Profile " .. cfg.naca_serie)

function TrapezoidFinSet(cfg)
   fins = {}
   for i=1,cfg.fin_count do
      local a_fin = translate(0, cfg.body_radius, -cfg.thickness/2) * linear_extrude(v(0, 0, cfg.thickness), cfg.fin_points)
      table.insert(fins, rotate((i * 360)/cfg.fin_count, 0, 0) * a_fin)
   end
   return translate(cfg.position) * union(fins)
end

local do_display_ref = ui_number('do display square fin', 0, 0, 1)
if do_display_ref > 0.5 then
   emit(rotate(90, 0, 0) * TrapezoidFinSet(cfg), 2)
end
