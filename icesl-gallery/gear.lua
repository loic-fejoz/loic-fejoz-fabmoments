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
local r = 15
local n = 16
local h = 3
gear = implicit_distance_field(v(-6*r,-2*r,0), v(2*r,4*r,h),
[[
const float PI = 3.1415926535897932384626433832795;
uniform float r = 5;
uniform float n = 16;

float involute_solid(vec3 p) {

	float num = p.y + sqrt(p.x * p.x + p.y * p.y - r * r);
	float denom = r + p.x;
	float theta = 2 * atan(num, denom);
	vec2 c = vec2(r * cos(theta), r * sin(theta));
	float s = r * theta;
	float sp = length(p.xy - c);
	return sp - s;
}

float distance(vec3 p) {
	float l = length(p.xy) - r;
	
	float alpha1 = mod(atan(p.y, p.x), 2 * PI / n);
	float rho = length(p.xy);
	vec3 p1 = vec3(rho * cos(alpha1), rho * sin(alpha1), p.z);
	
	float alpha2 = mod(atan(p.y, -p.x), 2 * PI / n);
	vec3 p2 = vec3(rho * cos(alpha2), rho * sin(alpha2), p.z);
	
	return min(l, max(involute_solid(p1), involute_solid(p2)));
}
]])
set_uniform_scalar(gear, 'r', r)
set_uniform_scalar(gear, 'n', n)
emit(gear,2)

emit(cylinder(r,h),1)