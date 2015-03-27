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

function ball_trajectory(fall, radius, ball_radius)
   outer_radius = radius + ball_radius
   glsl = [[
float minDistanceSphereTracing=0.01;
float sdTorus( vec3 p, vec2 t )
{
  vec2 q = vec2(length(p.xy)-t.x,p.z);
  return length(q)-t.y;
}

const vec2 torus = vec2(<CST_R>, <CST_BR>);

float distanceEstimator(vec3 pp) 
{
  vec3 p;
  float angle =  atan(pp.x, pp.y);
  float new_z = pp.z - <CST_FALL> * angle;
  if (new_z >= 0) {
    p = vec3(pp.xy, 0);
  } else {
    p = vec3(pp.xy, new_z);
  }

  return sdTorus(p, torus);
}

]]
   glsl = string.gsub(glsl, '<CST_R>', '' .. radius)
   glsl = string.gsub(glsl, '<CST_BR>', '' .. ball_radius)
   glsl = string.gsub(glsl, '<CST_FALL>', '' .. fall / ( 2 * math.pi))
   print(glsl)
   return implicit(v(-outer_radius, -outer_radius, -fall), v(outer_radius, outer_radius, fall), glsl)
end

function simple_ball_contraption(conf)
   trajectory_fall =  conf.rail.height.max - conf.rail.height.min
   trajectory = translate(0, 0, conf.rail.height.min) * ball_trajectory(trajectory_fall, conf.radius, conf.ball_radius)
   return union{
      cylinder(conf.radius + conf.rim + conf.rail.width, conf.base_height),
      difference{
	 cylinder(conf.radius + conf.rail.width/2, conf.rail.height.max),
	 cylinder(conf.radius - conf.rail.width/2, conf.rail.height.max),
	 translate(0, 0, conf.rail.height.min + trajectory_fall/2) * trajectory
      }
   }
end


emit(
   simple_ball_contraption{
      radius=50,
      base_height=1,
      rim=2,
      rail = {
	 width = 5,
	 height = {
	    max = 20,
	    min = 5
	 }
      },
      ball_radius = 5
   }
)

--emit(ball_trajectory(20, 20, 5))

