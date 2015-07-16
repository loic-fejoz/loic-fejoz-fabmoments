-- = Printing =
-- shape = scale(0.1) * load('dauphin-binary.stl')
-- emit(shape)

-- = Machining =
-- This is a first sketch on how to use IceSL for CNC Milling.
-- First, set nozzle_width to be your cylindrical tool radius.

merged_shape = merge_vertices(load('dauphin-binary.stl'))
eroded_shape = linear_offsets(merged_shape, {v(1,0,0), v(0,1,0), v(0,0,1)}, {-0.4, -0.4, -0.4})

-- == Rough Machining =
-- Second, generate GCode with a layer thickness of 1mm
-- and with printer described in https://groups.google.com/forum/#!topic/icesl/ZV9ifqZ12Tw
shape = scale(0.1) * eroded_shape
block_height = 6.75 + 1.0
block_size = 42
emit(
   difference(
      cube(block_size, block_size, block_height),
      translate(0, 0, block_height) * mirror(v(0, 0, 1)) * translate(-22, -22, 0) * shape
))

-- == Finished Machinig =
-- Third, generate GCode with a layer thickness of 0.2mm
-- with CNC printer
-- emit(
--    translate(0, 0, block_height) * mirror(v(0, 0, 1)) * translate(-22, -22, 0) *
--       difference(
-- 	 eroded_shape,
-- 	 shape
-- ))

-- == Finally ==
-- Merge both GCode and send it to your CNC.
