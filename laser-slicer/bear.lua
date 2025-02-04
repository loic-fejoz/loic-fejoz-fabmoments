--[[
The MIT License (MIT)

Copyright (c) 2018 Loïc Fejoz

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

laserslicer = require "laser-slicer"

-- First go download https://www.thingiverse.com/thing:192392/files
filename = 'bear_optimize.STL'
object = scale(1.3) * load_centered(filename)
object = translate(0, 0, -bbox(object):min_corner().z) * object

local cfg = laserslicer.defaultCfg(object, true)
cfg.board.height = 3

local b = bbox(object)

local one_stick = cylinder(cfg.stick.diameter / 2, b:max_corner().z - b:min_corner().z + cfg.board.height)
local sticks = {}
sticks[0] = translate(7, 2.5, 0) * one_stick
sticks[1] = translate(-8, 2, 0) * one_stick
sticks[2] = translate(-6, 35, 0) * one_stick
sticks[3] = translate(5.5, 35, 0) * one_stick
sticks = merge(sticks)
cfg.stick.shape = sticks

laserslicer.slice(cfg)
