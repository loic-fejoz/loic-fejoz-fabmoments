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
   state.direction = state.rand_angle(state) * state.direction
   tree(state)

end

-- UI

if ui_scalar == nil then
  function ui_scalar(a, b ,c , d)
    return b
  end
end

radius = ui_scalar('radius', 25, 10, 100)
branching = ui_scalar('branching', 80, 0, 100) / 100

-- Main
tree{
   radius=radius,
   branching=1,
   origin=v(0,0,0),
   direction=v(0,0,radius),
   min_radius=5,
   angle=20,   
   rand_angle = rand_angle,
   brush=0
}
emit(intersection(translate(0, 0, -1.3*radius) * sphere(1.3*radius), box(2*1.3*radius)), 1)
