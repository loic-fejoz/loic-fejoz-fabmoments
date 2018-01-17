function shallowcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function vrandom()
   return v(math.random(), math.random(), math.random())
end

function rand_float(min, max)
   return min + math.random() * (max-min)
end

function rand_rotate(min, max)
   return rotate(rand_float(min, max), rand_float(min, max), rand_float(min, max))
end

function rand_angle(state)
   return rand_rotate(-state.angle, state.angle)
end

function flip(limit)
   return (math.random() < limit)
end

function tree(state)
   local radius = math.sqrt(dot(state.direction, state.direction))
   if (radius < state.min_radius) then
      return
   end
   emit(translate(state.origin) * sphere(radius), state.brush)
   state.origin = state.origin + state.direction
   state.direction = (2/3 + math.random()/3) * state.direction
   local rotation = state.rand_angle(state)
   state.direction = rotation * state.direction
   if flip(state.branching) then
--      print("branching")
      local d = shallowcopy(state)
--      d.brush = state.brush + 1
      d.direction = rotation * state.direction
      tree(d)
   end
   tree(state)
end

-- UI

if ui_scalar == nil then
  function ui_scalar(a, b ,c , d)
    return b
  end
end

seed = ui_scalar('seed', 0, 1024, 1)
math.randomseed(seed)

radius = ui_scalar('radius', 5, 10, 100)
min_radius = ui_scalar('min radius', 1, 0, 100)
branching = ui_scalar('branching', 50, 0, 100) / 100
max_angle = ui_scalar('max angle', 20, 0, 360)

-- Main
tree{
   radius=radius,
   branching=branching,
   origin=v(0,0,0),
   direction=v(0,0,radius),
   min_radius=min_radius,
   angle=max_angle,
   rand_angle = rand_angle,
   brush=0
}
emit(intersection(translate(0, 0, -1.3*radius) * sphere(1.3*radius), box(2*1.3*radius)), 1)
