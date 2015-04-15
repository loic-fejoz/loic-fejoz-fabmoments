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
  float angle =  atan(pp.x, pp.y);
  float new_z = pp.z - <CST_FALL> * angle;

  vec3 p0 = vec3(pp.xy, 0);
  float sdCylinderExt = length(p0) - <CST_R> - <CST_BR>;
  float sdCylinderInt = length(p0) - <CST_R> + <CST_BR>;
  float sdPipe = max(sdCylinderExt, -sdCylinderInt);
  float sdPlaneXY = - new_z;
  vec3 p = vec3(pp.xy, new_z);
  float sdTheTorus = sdTorus(p, torus);
  return 0.1 * min(max(sdPlaneXY, sdPipe), sdTheTorus);
}

]]
   glsl = string.gsub(glsl, '<CST_R>', '' .. radius)
   glsl = string.gsub(glsl, '<CST_BR>', '' .. ball_radius)
   glsl = string.gsub(glsl, '<CST_FALL>', '' .. fall / ( 2 * math.pi))
   print(glsl)
   return implicit(v(-outer_radius, -outer_radius, -fall), v(outer_radius, outer_radius, fall), glsl)
end

function simple_ball_contraption(conf)
   if conf.outer_radius == nil then
      conf.outer_radius = conf.outer_diameter / 2.0
   end
   if conf.rail.radius == nil then
      conf.rail.radius = conf.outer_radius - conf.rim - (conf.rail.width / 2.0)
   end
   conf.rail.height.fall =  conf.rail.height.max - conf.rail.height.min
   trajectory = translate(0, 0, conf.rail.height.min) * ball_trajectory(conf.rail.height.fall, conf.rail.radius, conf.ball_radius)
--   trajectory = box(1)
   return union{
      cylinder(conf.outer_radius, conf.base_height),
      difference{
	 cylinder(conf.rail.radius + conf.rail.width/2, conf.rail.height.max),
	 cylinder(conf.rail.radius - conf.rail.width/2, conf.rail.height.max),
	 translate(0, 0, conf.rail.height.min + conf.rail.height.fall/2) * trajectory
      }
   }
end

function manual_ball_contraption(conf)
   s = simple_ball_contraption(conf)
   l = math.max(2 * conf.ball_radius, conf.rail.width)
   b = difference{
      s,
      translate(-l/2, -conf.rail.radius, conf.rail.height.min + conf.base_height) * box(l, 2*l, 2*conf.rail.height.min)
   }
   l = l - 2 * conf.tolerance
   pallet = intersection{
      s,
      translate(-l/2 - conf.tolerance, -conf.rail.radius, conf.rail.height.min + conf.base_height + conf.tolerance) * box(l, 2*l, 2*conf.rail.height.min)
   }
   if conf.arm.height == nil then
      conf.arm.height = conf.arm.width
   end
   if conf.arm.length == nil then
      conf.arm.length = 2 * conf.rail.radius - 2 * conf.rail.width
   end
   conf.arm.angle = math.deg(math.atan2(l/2, conf.rail.radius))
   arm = translate(-l/2, -conf.arm.length/2, conf.base_height + conf.rail.height.min + conf.arm.height/2) * rotate(conf.arm.angle, 0, 0) * box(conf.arm.width, conf.arm.length, conf.arm.height)
   return union{
      b,
      pallet,
      arm,
      translate(0, -conf.rail.radius, conf.rail.height.min + conf.rail.height.fall / 2) * box(5, 5, conf.rail.height.fall)
   }
end

layer_thickness = 0.2
emit(
   manual_ball_contraption{
      outer_diameter = 120,
      base_height = 2 * layer_thickness,
      rim = 2,
      rail = {
	 width = 10,
	 height = {
	    max = 25,
	    min = 5
	 }
      },
      arm = {
	 width = 3
      },
      ball_radius = 12.67 / 2.0,
      tolerance = layer_thickness
   }
)

--emit(ball_trajectory(20, 20, 5))

