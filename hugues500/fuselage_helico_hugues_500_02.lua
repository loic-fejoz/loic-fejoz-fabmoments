function load_profile_svg(filename, height)
   global_shape = nil
   shapes = svg(filename, 90)
   barycenter = nil
   nb_points = 0
   for _,contour in ipairs(shapes) do
      for _,pts in ipairs(contour) do
	 nb_points = nb_points + 1
	 if barycenter == nil then
	    barycenter = pts
	 else
	    barycenter = barycenter + pts
	 end
      end
      c = linear_extrude(v(0,0,3), contour)
      if global_shape == nil then
	 global_shape = c
      else
	 global_shape = union(global_shape, c)
      end
   end
   barycenter = barycenter / nb_points
   global_shape = translate(-1 * barycenter) * global_shape
   return global_shape
end

emit(load_profile_svg('body.svg', 1))
