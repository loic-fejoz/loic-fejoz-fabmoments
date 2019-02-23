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

function gear_solid(params)
	local number_of_teeth = params.number_of_teeth or 15
	local circular_pitch = params.circular_pitch or -1
	local diametral_pitch = params.diametral_pitch or -1
	local pressure_angle = params.pressure_angle or 28
	local clearance = params.clearance or 0.2
	local gear_thickness = params.gear_thickness or 12
	local rim_thickness = params.rim_thickness or 15
	local rim_width = params.rim_width or 5
	local hub_thickness = params.hub_thickness or 17
	local hub_diameter = params.hub_diameter or 15
	local bore_diameter = params.bore_diameter or 5
	local circles = params.circles or 3
	local backlash = params.backlash or 0
	local twist = params.twist or 0
	local involute_facets = params.involute_facets or 0
	local flat = params.flat or false
	
	if ( circular_pitch < 0 and diametral_pitch < 0 ) then
		print("!! gear module needs either a diametral_pitch or circular_pitch !!");
		return Void
	end

	-- Convert diametrial pitch to our native circular pitch
	if circular_pitch < 0 then
		circular_pitch = 180/diametral_pitch
	end
	print("Circular pitch:" .. circular_pitch)

	-- Pitch diameter: Diameter of pitch circle.
	pitch_diameter  =  number_of_teeth * circular_pitch / 180;
	pitch_radius = pitch_diameter/2;
	print("Teeth:" .. number_of_teeth)
	print("Pitch radius:" .. pitch_radius);

	-- Base Circle
	base_radius = pitch_radius*cos(pressure_angle);
	print("Base radius:" .. base_radius) 

	-- Diametrial pitch: Number of teeth per unit length.
	pitch_diametrial = number_of_teeth / pitch_diameter;
	print("Pitch diametrial:" .. pitch_diametrial)

	-- Addendum: Radial distance from pitch circle to outside circle.
	addendum = 1/pitch_diametrial;
	print("Addendum:" .. addendum)

	--Outer Circle
	outer_radius = pitch_radius+addendum;
	print("Outer radius:" .. outer_radius)

	-- Dedendum: Radial distance from pitch circle to root diameter
	dedendum = addendum + clearance;
	print("Dedendum:" .. dedendum)

	-- Root diameter: Diameter of bottom of tooth spaces.
	root_radius = pitch_radius-dedendum;
	print("Root radius:" .. root_radius .. " (" .. (root_radius-base_radius)..")")
	backlash_angle = backlash / pitch_radius * 180 / math.pi;
	print("Backlash angle:"..backlash_angle)
	half_thick_angle = (360 / number_of_teeth - backlash_angle) / 4;
	print("half_thick_angle:" .. half_thick_angle)

	-- Variables controlling the rim.
	rim_radius = root_radius - rim_width;
	print("Rim radius:"..rim_radius)

	-- Variables controlling the circular holes in the gear.
	circle_orbit_diameter=hub_diameter/2+rim_radius;
	circle_orbit_curcumference=math.pi*circle_orbit_diameter;


	local gear = implicit_distance_field(
		v(-2*root_radius,-2*root_radius,0),
		v(2*root_radius,2*root_radius, rim_thickness*0.8),
[[
const float PI = 3.1415926535897932384626433832795;
uniform float r = 5;
uniform float z = 16;
uniform float r_outside = 20;
uniform float r_root = 15;

uniform float delta_involute = 0.0;

float involute_solid(vec3 p) {

	float num = p.y + sqrt(p.x * p.x + p.y * p.y - r * r);
	float denom = r + p.x;
	float theta = 2 * atan(num, denom);
	vec2 c = vec2(r * cos(theta), r * sin(theta));
	float s = r * theta;
	float sp = length(p.xy - c);
	return sp - s + delta_involute;
}

float distance(vec3 p) {
	float l_outside = length(p.xy) - r_outside;
	float l_root = length(p.xy) - r_root;
	
	float alpha1 = mod(atan(p.y, p.x), 2 * PI / z);
	float rho = length(p.xy);
	vec3 p1 = vec3(rho * cos(alpha1), rho * sin(alpha1), p.z);
	
	float alpha2 = mod(atan(p.y, -p.x), 2 * PI / z);
	vec3 p2 = vec3(rho * cos(alpha2), rho * sin(alpha2), p.z);
	
	return max(l_outside, min(l_root, max(involute_solid(p1), involute_solid(p2))));
}
]])
	set_uniform_scalar(gear, 'r', base_radius)
	set_uniform_scalar(gear, 'r_outside',outer_radius)
	set_uniform_scalar(gear, 'r_root', math.max(root_radius, base_radius))
	set_uniform_scalar(gear, 'z', number_of_teeth)
	set_uniform_scalar(gear, 'delta_involute', math.pi/2 - 0.042 * number_of_teeth) -- 0.042 is still blakc magic and shall depend on circular_pitch
	return gear
end


local params = {number_of_teeth=24,circular_pitch=400,flat=true}

local b_solid = gear_solid(params)
emit(b_solid,2)


dofile("C:\\Users\\lfejoz\\AppData\\Roaming\\IceSL\\icesl-models\\libs\\gear.lua")
local b = translate(0,0,-5) * rotate(0,0, 180 / params.number_of_teeth) * gear(params)
--emit(b,3)