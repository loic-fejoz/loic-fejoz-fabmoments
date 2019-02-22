--[[
The MIT License (MIT)

Copyright (c) 2019 Loïc Fejoz

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
-- emit the inside of the involute of the circle of radius r for the first two quadrants
local r = 20
local h = 3
involute_of_circle = implicit_solid(v(-6*r,0,0), v(2*r,4*r,h), 0.1,
[[
uniform float r = 5;
float solid(vec3 p) {
	float l = length(p.xy) - r;
	float num = p.y + sqrt(p.x * p.x + p.y * p.y - r * r);
	float denom = r + p.x;
	float theta = 2 * atan(num, denom);
	vec2 c = vec2(r * cos(theta), r * sin(theta));
	float s = r * theta;
	float sp = length(p.xy - c);
	return min(l, sp - s);
}
]])
set_uniform_scalar(involute_of_circle, 'r', r)
emit(involute_of_circle,2)

emit(cylinder(r,h),1)