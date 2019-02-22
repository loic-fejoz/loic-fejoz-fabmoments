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