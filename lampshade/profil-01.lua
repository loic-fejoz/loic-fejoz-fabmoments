dofile 'lampshade.lua'

local config = {
   tolerance = 1,
   thickness = 3,
   profile_number = 20, -- shall be 20 to be nicer
   angle = 0,
   radius = 90,
   upper = {
      height = 200,
      external_radius = 100,
      internal_radius = 80,
      -- radius = at middle
   },
   bottom = {
      external_radius = 130,
      internal_radius = 110,
      -- radius = at middle
   },
--   view = 'cutting' -- could be 'assembled', 'cutting', or absent
}
build_lampshade(Path .. 'profil-01.svg', config)
