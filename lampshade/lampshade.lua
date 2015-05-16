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

function load_profile(filename, config)
   local shapes = svg(Path .. 'profil-00.svg', 90)
   local p = nil
   local s
   local big_number = 100000000000000
   local pts_min = v(big_number, big_number)
   local pts_max = v(0, 0)
   for _,contour in ipairs(shapes) do
      for _,pts in ipairs(contour) do
	 pts_min.x = math.min(pts_min.x, pts.x)
	 pts_min.y = math.min(pts_min.y, pts.y)
	 pts_max.x = math.max(pts_max.x, pts.x)
	 pts_max.y = math.max(pts_max.y, pts.y)
      end
      s = linear_extrude(v(0, 0, config.thickness),contour)
      if p == nil then
	 p = s
      else
	 p = merge(p, s)
      end
   end
   p.bounding_box = {pts_min, pts_max}
   return p
end

function build_bottom_part(config)
   return difference(
      cylinder(config.bottom.external_radius, config.thickness),
      cylinder(config.bottom.internal_radius, config.thickness))
end

function build_upper_part(config)
   return difference(
      cylinder(config.upper.external_radius, config.thickness),
      cylinder(config.upper.internal_radius, config.thickness))
end

function computeConfig(config)
   if config.angle == nil then
      config.angle = 0
   end
   if config.bottom.radius == nil then
      config.bottom.radius = (config.bottom.external_radius + config.bottom.internal_radius) / 2.0
   end
   if config.upper.radius == nil then
      config.upper.radius = (config.upper.external_radius + config.upper.internal_radius) / 2.0
   end
   if config.radius == nil then
      config.radius = (config.bottom.radius + config.upper.radius) / 2.0
   end
   if config.profile == nil then
      config.profile = {}
   end
   if config.view == nil then
      config.view = 'assembled'
   end
   if config.bottom.brush == nil then
      config.bottom.brush = 0
   end
   if config.upper.brush == nil then
      config.upper.brush = 0
   end
   if config.profile.brush == nil then
      config.profile.brush = 0
   end
   if config.view == 'assembled' then
      config.bottom.brush = 0
      config.upper.brush = 0
      config.profile.brush = 1
   end
end

function build_profile(filename, config)
   local raw_profile = load_profile(filename, config)
   local t_raw_profile = translate(config.radius, 0, 0) * rotate(90, 0 , config.angle) * raw_profile
   local profile = difference{
      t_raw_profile,
      cylinder(config.bottom.radius, config.thickness),
      translate(0, 0, config.upper.height - config.thickness) * cylinder(config.upper.radius, config.thickness)
   }
   profile.bounding_box = raw_profile.bounding_box
   return profile
end

function build_lampshade(filename, config)
   computeConfig(config)
   local profile = build_profile(filename, config)
   local bottom_part = build_bottom_part(config)
   local top_part = translate(0, 0, config.upper.height - config.thickness) * build_upper_part(config)
   local all_profiles = {}
   local inv_transform
   local index = 0
   for angle = 0, 360, (360 / config.profile_number) do
      local p = rotate(0, 0, angle) * profile
      if config.view == 'assembled' then
	 emit(p, config.profile.brush)
      else
	 emit(
	    translate(index * (profile.bounding_box[2].x - profile.bounding_box[1].x + config.tolerance), 0, 0) *
	    translate(0, config.bottom.external_radius - profile.bounding_box[1].x, 0) *
	       rotate(-90, 0, 0) *
	       rotate(0, 0, -config.angle) *
	       translate(-config.radius, 0, 0) *
	       profile,
	    config.profile.brush)
      end
      table.insert(all_profiles, p)
      index = index + 1
   end
   bottom_part = difference(bottom_part, union(all_profiles))
   top_part = difference(top_part, union(all_profiles))
   emit(bottom_part, config.bottom.brush)
   if config.view == 'cutting' then
      inv_transform = translate(config.bottom.external_radius + config.upper.external_radius + config.tolerance, 0,  - config.upper.height + config.thickness)
   else
      inv_transform = translate(0,0,0)
   end
   emit(inv_transform * top_part, config.upper.brush)
end

