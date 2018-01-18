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

-- Directly applied from http://graphics.cs.illinois.edu/sites/default/files/zeno.pdf
-- See IceSL's forum for the trick to multiply distance by 0.1.
function superquadrics(radius, p)
   glsl = [[
uniform float uradius;
uniform float up;
float sum3(vec3 p) {
  return p.x + p.y + p.z;
}

// This might not be need but abs(vec3) does not work on my card.
vec3 abs3(vec3 p) {
  return vec3(abs(p.x), abs(p.y), abs(p.z));
}

float quadricsDistance(vec3 pt, float p) {
  vec3 v1 = pow(abs(pt), vec3(p));
  float v2 = sum3(v1);
  return pow(v2, 1 / p);
}

float distanceEstimator(vec3 pt)
{
  return 0.01 * (quadricsDistance(pt,  up) - uradius);
}
]]
   obj = implicit(v(-radius, -radius, -radius), v(radius, radius, radius), glsl)
   set_uniform_scalar(obj, "up", p)
   set_uniform_scalar(obj, "uradius", radius)
   return obj
end

function samples()
   ps = {0.1, 0.2, 0.3, 0.5, 0.8, 1.0, 1.5, 1.8, 2.0, 5.0, 10.0}
   for k, p in pairs(ps) do
      emit(translate(20 * k, 0, 0) * scale(10) * superquadrics(1.0, p))
   end
end

-- If used as main script then display samples
-- see http://stackoverflow.com/questions/4521085/main-function-in-lua
if not pcall(getfenv, 4) then
   samples()
end
