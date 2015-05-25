dofile 'lampshade.lua'

local config = {
   scale = 0.25,
   tolerance = 1,
   thickness = 3,
   profile_number = 4, -- shall be 20 to be nicer
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
   view = 'cutting' -- could be 'assembled', 'cutting', or absent
}
build_lampshade(Path .. 'profil-00.svg', config)
