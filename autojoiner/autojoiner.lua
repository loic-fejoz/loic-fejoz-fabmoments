
if ui_scalar == nil then
  function ui_scalar(a, b ,c , d)
    return b
  end
end

function join(part_a, part_b, nb_part)
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
  part_a = difference(part_a, i)
  part_b = difference(part_b, i)
  for n = 0, nb_part do
    local b = translate(cr.x + n * ex.x / 10, cr.y, cr.z) * ocube(ex.x / 10, ex.y, ex.z)
    if n % 2 ==0 then
      part_a = union(part_a, intersection(b, i))
    else
      part_b = union(part_b, intersection(b, i))
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


-- autojoin
j =  join(parts[1], parts[2], 10)
parts[1] = j[1]
parts[2] = j[2]

itrs={}
itrs[1] = translate(0, 0, 0)
itrs[2] = translate(0, width+tickness, 0)
itrs[3] = translate(width+tickness, 0, 0)

if false then
  -- disassembled
  for i = 1, 2 do
    emit(itrs[i] * inverse(trs[i]) * parts[i], i)
  end
else
  -- assambled
  for i = 1, 2 do
    emit(parts[i], i)
  end
end