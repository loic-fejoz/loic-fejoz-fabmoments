bom = {}

function inc_bom(...)
  local args = {...}
  local dim = args[1] .. " x " .. args[2] .. " x ".. args[3]
  local v = bom[dim]
  if v == nil then
    v = 0
  end
  v = v + 1
  bom[dim] = v
end

function display_bom()
  print("=== BOM ===")
  for dim, count in pairs(bom) do
    print(count .. "x " .. dim)
  end
end

function mybox(x,y,z)
  inc_bom(x, y, z)
  --print("1x " .. x .. " x " ..  y .. " x " .. z)
  return box(x, y, z)
end

function mycube(x, y, z)
  inc_bom(x, y, z)
  --print("1x " .. x .. " x " ..  y .. " x " .. z)
  return cube(x, y, z)
end

function biblio(conf)
   if cfg.top == nil then
      cfg.with_top = true
   end
   i_top = table.getn(conf.spaces)
   bib = sphere(0.1)
   h = conf.ep / 2
   side_height = conf.height + conf.ep
   if not conf.with_stop then
      side_height = side_height - conf.spaces[i_top] - conf.ep + conf.top.side.height
      dep = conf.height - 2*conf.ep - conf.renfort - conf.spaces[i_top] + conf.top.side.height
      bib = union(bib, translate(0, -conf.depth/2 - conf.ep/2, dep) * mybox(conf.width, conf.ep, conf.top.back.height + conf.ep + conf.renfort/2))
   end
   bib = union(bib, translate(-conf.width/2 + conf.ep/2, 0, 0) * mycube(conf.ep, conf.depth, side_height))
   bib = union(bib, translate(conf.width/2 - conf.ep/2, 0, 0) * mycube(conf.ep, conf.depth, side_height))
   for i,d in ipairs(conf.spaces) do
      h = h + d + conf.ep
      if i ~= i_top or conf.with_top then
	 bib = union(bib, translate(0, 0, h) * mybox(conf.width - 2*conf.ep, conf.depth, conf.ep))
      end
      if i ~= i_top and i ~= i_top-1 or conf.with_top then

	 bib = union(bib, translate(0, -conf.depth/2 - conf.ep/2, h) * mybox(conf.width, conf.ep, conf.ep + cfg.renfort))
      end
   end
   bib = difference(bib, rotate(0, 90, 0) * ccylinder(conf.side.cut.height, cfg.width + 4 * conf.ep))
   return bib
end

mm = 1
cm = 10 * mm

cfg = {}
cfg.spaces = {150, 370, 320, 320, 310, 310}
cfg.depth = 30 * cm
cfg.width = 1174 * mm
cfg.height = 1894 * mm
cfg.ep = 19 * mm
cfg.renfort = 40 * mm
cfg.with_top = false
cfg.top = {}
cfg.top.side = {}
cfg.top.side.height = 16 * cm
cfg.top.back = {}
cfg.top.back.height = 21 * cm
cfg.side = {}
cfg.side.cut = {}
cfg.side.cut.height = 5 * cm


s = 0.05
emit(scale(s) * box(1500, 300, 1), 2)
emit(scale(s) * translate(0, 0, 1900) * box(1500, 300, 1), 2)
emit(scale(s) * biblio(cfg))
display_bom()
