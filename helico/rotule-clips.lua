l = 10.9 + 0.3
L = 19.82 + 1.0
h = 5.07 + 1.0
ep = 0.66

i_l = 6.25
i_L = 12.51

diam_barre = 4.8 + 0.1
diam_rotule = 4.34 - 0.4
diam_axe_rotule = diam_rotule * 2 / 6

clips = 1.1

delta_x_rotule = 2.32
delta_y_rotule = 3.27


rotule =       translate(L / 2 - delta_x_rotule, -(l / 2 + delta_y_rotule), 0) * sphere(diam_rotule /2)

passages_barres = union{
   translate(-L, 0, 0) * rotate(0, 90, 0) * cylinder(diam_barre / 2, 2 * L), -- passages barres
   translate(0, 0,  -diam_barre/2) * box(2 * L, diam_barre, diam_barre), -- passages barres
}

piece =
   union{
      difference{
	 box(L + 2 * ep, l + 2 * ep, h + 2 * ep),
	 box(L, l, h), -- existant
	 passages_barres,
	 --	 translate(0, -L, 0) * rotate(0, 0, 90) * passages_barres,
	 translate(0, -L, 0) * rotate(0, 0, 90) * translate(-L, 0, 0) * rotate(0, 90, 0) * cylinder(diam_barre / 2, 2 * L),
	 box(i_L, i_l, 3 * h), -- trou haut
	 translate(0, 0, -h) * box(L - clips, l - clips, 2*h), -- trou bas
      },
      rotule,
      translate(L / 2 - delta_x_rotule, -i_l, 0) * rotate(90, 0, 0) * cylinder(diam_axe_rotule, delta_y_rotule + ep), -- axe rotule
   }


emit(rotate(180, 0, 0) * piece, 1)


-- This used to be a native function
function support(obj)
   hs = (h + 2 * ep) / 2
   -- 0.3 is the minimum diameter that generates a GCode something.
   return rotate(180, 0, 0) * translate(L / 2 - delta_x_rotule, -(l / 2 + delta_y_rotule), 0) * cylinder(0.3, hs)
end

--emit(support(rotule))
