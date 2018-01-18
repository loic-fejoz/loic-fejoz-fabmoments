--[[
The MIT License (MIT)

Copyright (c) 2015 Loïc Fejoz

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

-- Directly applied from http://www.iquilezles.org/www/articles/distfunctions/distfunctions.htm
-- See IceSL's forum for the trick to multiply distance by 0.1.
h = 20
twisted = implicit(v(-h,-h,0), v(h,h,2*h), [[
float distanceEstimator(vec3 ppp)
{
  precision highp float;
  // translate (0,0,18)
  vec3 pp = ppp - vec3(0,0,18);
  // Twist p to pp
  float c = cos(radians(20.0 * pp.z));
  float s = sin(radians(20.0 * pp.z));
  mat2 m = mat2(c, -s, s, c);
  vec3 p = vec3(m * pp.xy, pp.z);
  // Torus
  vec2 t = vec2(12.0, 6.0);
  vec2 q = vec2(length(p.xz)-t.x, p.y);
  return 0.1 * (length(q)-t.y);
}
]])
emit(twisted)
e = 1
emit(translate(0, 0, e/2 + 0.220) * box(20, 20, e)) -- the basement
-- emit(translate(0, 0, 0.220/2) * box(20, 20, 0.220), 3) -- for slow first layer printing
-- emit(cylinder(30, 0.220), 4) -- for contouring
