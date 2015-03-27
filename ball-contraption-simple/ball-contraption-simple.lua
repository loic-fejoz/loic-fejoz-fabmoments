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
   ball =  union(
      sphere(ball_radius),
      translate(0,0, fall/2) * box(2*ball_radius, 2*ball_radius, fall)
   )
   trajectory = ball
   for angle = 0, 360, 3 do
      trajectory = union{
	 trajectory,
	 translate(
	    radius * cos(angle),
	    radius * sin(angle),
	    angle / 360 * fall)
	    * ball
      }
   end
   return trajectory
end

function simple_ball_contraption(conf)
   trajectory_fall =  conf.rail.height.max - conf.rail.height.min
   trajectory = ball_trajectory(trajectory_fall, conf.radius, conf.ball_radius)
   return union{
      cylinder(conf.radius + conf.rim + conf.rail.width, conf.base_height),
      difference{
	 cylinder(conf.radius + conf.rail.width/2, conf.rail.height.max),
	 cylinder(conf.radius - conf.rail.width/2, conf.rail.height.max),
	 translate(0, 0, conf.rail.height.min) * trajectory
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
