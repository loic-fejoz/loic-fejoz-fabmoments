-- Public Domain

-- This example is about a ball trajectory. Think of it as base part for a ball contraption...

function union_based(step)
   ball = sphere(2.5)
   ball_trajectory = ball
   for angle = 0, 360, step do
      ball_trajectory = union{
	 ball_trajectory,
	 translate(
	    15 * cos(angle),
	    15 * sin(angle),
	    5 + angle / 360 * 5)
	    * ball
      }
   end
   return ball_trajectory
end

function merge_based(clear_up)
   ball = sphere(2.5)
   if clear_up then
      ball = union(ball, cylinder(2.5, 15))
   end
   ball_trajectory = ball
   for angle = 0, 360, 1 do
      ball_trajectory = merge{
	 ball_trajectory,
	 translate(
	    15 * cos(angle),
	    15 * sin(angle),
	    5 + angle / 360 * 5)
	    * ball
      }
   end
   return ball_trajectory
end

function solution()
   ball = sphere(2.5)
   ball_trajectory = ball
   for angle = 0, 360, 1 do
      trans = translate(
	 15 * cos(angle),
	 15 * sin(angle),
	 d + 5 + angle / 360 * 5)
      ball_trajectory = merge{
	 ball_trajectory,
	 trans * ball,
	 trans * cylinder(2.5, 15)
      }
   end
   return ball_trajectory
end

emit(
   difference(
      cylinder(20, 10),
      union_based(5) -- This one is ok
--      union_based(1) -- This one is NOK: *ASSERT FAILED** n <= MAX_NUMBER_OF_ID, file libcsg/src/DexelBuffer.cpp, line 1615
--      merge_based(false) -- This is one is perfect but...
--      merge_based(true) -- I would like this one which is NOK: [[LUA]exit] merge table should only contain tesselated geometries or other merge (no composed shapes)!
--      solution() -- which is much slower
   )
)
