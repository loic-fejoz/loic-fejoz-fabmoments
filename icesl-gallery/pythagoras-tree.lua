phi = (1.0 + math.sqrt(5)) / 2.0 -- golden ratio

--Context = {length = 140, angle = 0, n = 6, x = 0, y = 0, z = 0, delta = 45, ratio = 0.5}
Context = {length = 140, angle = 0, n = 6, x = 0, y = 0, z = 0, delta = 60, ratio = 1.0/phi}

function Ctx_print(ctx)
   print('{length=' .. ctx.length .. ', angle=' .. ctx.angle .. ', n = ' .. ctx.n .. ', x = ' .. ctx.x .. ', y = ' .. ctx.y .. ', z = ' .. ctx.z .. '}')
end

function left(ctx)
   return {
      length = ctx.length * ctx.ratio,
      angle = ctx.angle - ctx.delta,
      n = ctx.n - 1,
      x = ctx.x + ctx.length/2.0 * sin(ctx.angle),
      y = 0,
      z = ctx.z + ctx.length/2.0 * cos(ctx.angle),
      delta = ctx.delta,
      ratio = ctx.ratio
   }
end

function right(ctx)
   return {
      length = ctx.length * ctx.ratio,
      angle = ctx.angle + ctx.delta,
      n = ctx.n - 1,
      x = ctx.x + ctx.length/2.0 * sin(ctx.angle),
      y = 0,
      z = ctx.z + ctx.length/2.0 * cos(ctx.angle),
      delta = ctx.delta,
      ratio = ctx.ratio
   }
end

function tree(ctx)
   if ctx.n == 0 then
      return  translate(ctx.x, ctx.y, ctx.z) *
      	 rotate(0, ctx.angle, 0) *
      	 merge{
      	    cylinder(ctx.length / 25.0, ctx.length),
      	    translate(0, 0, ctx.length) *
      	       sphere(0.2 / phi * ctx.length)
      	 }
   else
      local s1 = translate(ctx.x, ctx.y, ctx.z) * rotate(0, ctx.angle, 0) * cone(ctx.length / 25.0, ctx.length / 25.0 * ctx.ratio, ctx.length/2)
      local c1 = left(ctx)
      local c2 = right(ctx)
      local s3 = tree(c2)
      local s2 = tree(c1)
      return merge{s1, s2, s3}
   end
end

emit(tree(Context))
