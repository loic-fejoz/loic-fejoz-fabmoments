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


-- trompette_ray = implicit(v(-10,-10, 1), v(10,10,10), [[
-- #undef SPHERE_TRACING
-- #define RAY_MARCHING
-- const int iterationsMarching=2000;
-- float minDistanceSphereTracing=0.01;
-- float inTrompette(vec3 p)
-- {
--   vec3 p2 = p * p;
--   return (p2.x + p2.y) * p2.z - 25;
-- }
-- float distanceEstimator(vec3 p) 
-- {
--   return inTrompette(p);
-- }

-- float evalFunction(vec3 p) 
-- {
--   return inTrompette(p);
-- }
-- ]])


-- Gabriel's Horn is defined as the implicit surface of revolution of equation r = c / p.z; and r the length in the plane (x,y).
function horn(c)
   glsl = [[
float solid(vec3 p)
{
  return length(p.xy) - (<CST_C> / p.z);
}
]]
   glsl = string.gsub(glsl, '<CST_C>', '' .. c)
   return solid(
      v(-10, -10, -10),
      v(10,   10,  10),
      0.25,
      glsl)
end

--emit(horn(5.0))
--emit(scale(1) * horn(5.0))
emit(horn(5.0))
