
if ui_scalar == nil then
  function ui_scalar(a, b ,c , d)
    return b
  end
end

function inverse_or_given(a_vector, value)
  local r = v(0, 0, 0)
  if a_vector.x == 0 then
	r.x = value
  else
	r.x = 1 / a_vector.x
  end
  if a_vector.y == 0 then
	r.y = value
  else
	r.y = 1 / a_vector.y
  end
  if a_vector.z == 0 then
	r.z = value
  else
	r.z = 1 / a_vector.z
  end
  return r
end

function inverse_or_zero(a_vector)
  return inverse_or_given(a_vector, 0)
end

function inverse_or_one(a_vector)
  return inverse_or_given(a_vector, 1)
end

function join(part_a, part_b, nb_finger_v)
  local i = intersection(part_a, part_b)
  local bx = bbox(i)
  if bx:empty() then
    print('oops, cannot joint parts!')
    return {part_a, part_b}
  end
  ex = bx:extent()
  cr  = bx:min_corner()
  print('extent = ' .. ex.x .. ' ' .. ex.y .. ' ' .. ex.z .. '\n')
  print('mincorner = ' .. cr.x .. ' ' .. cr.y .. ' ' .. cr.z .. '\n')
  --part_a = difference(part_a, i)
  --part_b = difference(part_b, i)
  local nb_finger = 10
  local s_v = inverse_or_zero(nb_finger_v)
  s_v = v(s_v.x * ex.x, s_v.y * ex.y, s_v.z * ex.z)
  local size_v = inverse_or_one(nb_finger_v)
  for n = 0, nb_finger do
    local b = translate(cr.x + n * s_v.x, cr.y + n * s_v.y, cr.z + n * s_v.z) * ocube(ex.x * size_v.x, ex.y * size_v.y, ex.z * size_v.z)
    if n % 2 ==0 then
      --part_a = union(part_a, intersection(b, i))
	  part_b = difference(part_b, intersection(b, i))
    else
      --part_b = union(part_b, intersection(b, i))
	  part_a = difference(part_a, intersection(b, i))
    end
  end
  return {part_a, part_b}
end


tickness = ui_scalar('tickness', 5, 1, 50)
width = ui_scalar('width', 100, 3, 1000)

parts={}
trs={}
trs[1] = translate(0, 0, 0)
parts[1] = cube(width, width, tickness)
trs[2] = translate(0, width/2, width/2) * rotate(90, 0 ,0)
parts[2] = trs[2] * cube(width, width , tickness)
trs[3] = translate(width/2-tickness, 0, width/2) * rotate(0, 90 ,0)
parts[3] = trs[3] * cube(width, width , tickness)

nb_parts = table.getn(parts)

-- autojoin
j =  join(parts[1], parts[2], v(10, 0, 0))
parts[1] = j[1]
parts[2] = j[2]

j =  join(parts[1], parts[3], v(0, 10, 0))
parts[1] = j[1]
parts[3] = j[2]

-- j =  join(parts[2], parts[3], v(0, 0, 10))
-- parts[2] = j[1]
-- parts[3] = j[2]

itrs={}
itrs[1] = translate(0, 0, 0)
itrs[2] = translate(0, width+tickness, 0)
itrs[3] = translate(width+tickness, 0, tickness) * rotate(0, -180 ,0)

if true then
  -- disassembled
  for i = 1, nb_parts do
    emit(itrs[i] * inverse(trs[i]) * parts[i], i)
  end
else
  -- assambled
  for i = 1, nb_parts do
    emit(parts[i], i)
  end
end