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
   local c2 = 2 * c
   local glsl = [[
//float minDistanceSphereTracing=0.001;
float inTrompette(vec3 p)
{
  vec3 p2 = p * p;
  return (p2.x + p2.y) * p2.z - (<CST_C> * <CST_C>);
}

float distanceEstimator(vec3 p) 
{
  float p_radius = length(p.xy);
  vec2 cp = vec2(p.z, p_radius);
  vec2 cq = vec2(p.z, <CST_C> / p.z);
  if (p.z >= 1.0) {
    // Search min distance by dichotomy between projection of p on surface along z axis and point (1.0, c)
    vec2 cq_right = cq;
    vec2 cq_left = vec2(1.0, <CST_C>);
    vec2 cq_middle;
    float dist_right = length(cp - cq_right);
    float dist_left = length(cp - cq_left);
    float dist = min(dist_left, dist_right);
    float dist_middle;
    bool oneMoreStep;
    do {
      oneMoreStep = false;
      cq_middle.x = (cq_right.x + cq_left.x) / 2.0;
      cq_middle.y = <CST_C> / cq_middle.x;
      dist_middle = length(cp - cq_middle);
      if (dist_middle < dist) {
        oneMoreStep = (dist - dist_middle) > (minDistanceSphereTracing / 2.0);
        dist = dist_middle;
        if (dist_middle < dist_left) {
          cq_left = cq_middle;
        } else {
          cq_right = cq_middle;
        }
      }
    } while(oneMoreStep);
    if (p_radius < <CST_C> / p.z) {
      return -0.1 * dist;
    }
    return 0.1 * dist;
  } else {
    if (p_radius < <CST_C>) {
      return 0.1 * abs(p.z - 1);
    } else {
      cq = vec2(1.0, <CST_C>);
      return 0.1 * length(cp - cq);
    }
  }
}
]]
   glsl = string.gsub(glsl, '<CST_C>', '' .. c)
   print(glsl)
   trompette_sphere = implicit(v(-c2,-c2, 1), v(c2,c2,c2), glsl)
   return trompette_sphere
end

--emit(horn(5.0))
--emit(scale(1) * horn(5.0))
emit(scale(2) * horn(5.0)) -- This one does not slice because of empty scene!
