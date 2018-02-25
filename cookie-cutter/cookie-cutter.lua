-- Cookie cutter module

local cookie_cutter_module = {}

function cookie_cutter_module.svg_extrude_centered(filename, dpi, height)
  local svg_shapes = svg_ex(filename, dpi)
  for i, contour in pairs(svg_shapes) do
    obj = linear_extrude(
      v(0, 0, height),
      contour:outline())
    --obj = scale(-1, 1, 1) * obj
    bb = bbox(obj):center()
    obj = translate(-1 * bb) * obj
    return obj
  end
end

function cookie_cutter_module.dilate_it(shape, cfg)
--obj_bb = bbox(obj):extent()
--factor = math.max(
--  (obj_bb.x + 2*cfg.thickness) / obj_bb.x,
--  (obj_bb.y + 2*cfg.thickness) / obj_bb.y)
  local factor = cfg.thickness
  local dilated = scale(1, 1, 3) * dilate(shape, factor)
  local dilated_bb = bbox(dilated):extent()
  local cutter = difference(
    intersection{
      dilated,
        ccube(dilated_bb.x + 3* cfg.thickness, dilated_bb.y + 3 * cfg.thickness, cfg.height)
    },
    shape)
  return cutter
end

function cookie_cutter_module.create(cfg)
  if cfg.filename == nil then 
    error("filename is mandotary")
  end
  if cfg.thickness == nil then
    cfg.thickness = 0.6
  end
  if cfg.height == nil then
    cfg.height = 10
  end
  if cfg.base == nil then
    cfg.base = 2
  end
  if cfg.dpi == nil then
    cfg.dpi = 90
  end
  local obj = cookie_cutter_module.svg_extrude_centered(cfg.filename, 90, cfg.height)
  local cutter = cookie_cutter_module.dilate_it(obj, cfg)
  --emit(cutter)
  local base_cfg = {}
  base_cfg.height = cfg.base
  base_cfg.thickness = 5
  support = translate(0, 0, (cfg.base-cfg.height)/2) * cookie_cutter_module.dilate_it(obj, base_cfg)
  return union(cutter, support)
end

function cookie_cutter_module.ui_create(cfg)
  cfg.height = ui_scalar('height', 10, 0.1, 50)
  cfg.thickness = ui_scalar('cutter thickness', 0.6, 0.1, 5) -- = 2 * nozzle_width
  cfg.base = ui_scalar('base', 1, 0.1, cfg.height)
  cfg.dpi = 90
  return cookie_cutter_module.create(cfg)
end

-- If used as main script then display samples
-- see http://stackoverflow.com/questions/4521085/main-function-in-lua
if not pcall(getfenv, 4) then 
  emit(cookie_cutter_module.ui_create{filename='pi.svg'})
end

return cookie_cutter_module