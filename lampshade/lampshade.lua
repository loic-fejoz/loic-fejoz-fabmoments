
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
   if config.view == 'assembled' then
      config.bottom.brush = 0
      config.upper.brush = 0
      config.profile.brush = 1
   end
end

function build_profile(filename, config)
   local raw_profile = load_profile(filename, config)
   raw_profile = translate(config.bottom.radius, 0, 0) * rotate(90, 0 , config.angle) * raw_profile
   local profile = difference{
      raw_profile,
      cylinder(config.bottom.radius, config.thickness),
      translate(0, 0, config.upper.height - config.thickness) * cylinder(config.upper.radius, config.thickness)
   }
   return profile
end

function build_lampshade(filename, config)
   computeConfig(config)
   local profile = build_profile(filename, config)
   local bottom_part = build_bottom_part(config)
   local top_part = translate(0, 0, config.upper.height - config.thickness) * build_upper_part(config)
   local all_profiles = {}
   for angle = 0, 360, (360 / config.profile_number) do
      local p = rotate(0, 0, angle) * profile
      emit(p, config.profile.brush)
      table.insert(all_profiles, p)
   end
   bottom_part = difference(bottom_part, union(all_profiles))
   top_part = difference(top_part, union(all_profiles))
   emit(bottom_part, config.bottom.brush)
   emit(top_part, config.upper.brush)
end

local config = {
   thickness = 3,
   profile_number = 4,
   angle = 30, -- default is zero
   bottom = {
      external_radius = 100,
      internal_radius = 80,
      -- radius = at middle
   },
   upper = {
      height = 200,
      external_radius = 100,
      internal_radius = 80,
      -- radius = at middle
   },
   --   radius = average of the other two radii
--   view = 'cutting' -- could also be 'assembled'
}
build_lampshade(Path .. 'profil-00.svg', config)

