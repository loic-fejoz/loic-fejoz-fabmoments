-- Test for lithophane
-- by now the image is converted to Lua
-- but better be loaded.
-- Also we use sampler3D but better used sampler2D.

-- Use https://github.com/loic-fejoz/img2icesl utility tool
-- to convert your image into a lua 3D texture object
-- until IceSL has native image loading capability.
dofile("Lenna-grey-100x100.lua")


imp_res_xy = 0.01
imp_res_z = 3.5
imp_dim = v(tex_dim.x, tex_dim.y, 1.0 * imp_res_z)
imp = implicit_solid(v(0,0,0), imp_dim, 0.05, [[
uniform sampler3D tex_data;
uniform float res_xy = 0.1;
uniform float res_z = 1;
float solid(vec3 p)
{
    if (p.z < 0.0) {
        return 1.0;
    }
    vec3 p_tex = vec3(p.xy, 0.0) * res_xy;
	  float height = 0.05 + res_z * (1.0 - texture(tex_data, p_tex).z);
    return p.z - height;
}
]])
set_uniform_texture3d(imp, 'tex_data', tex)
set_uniform_scalar(imp, 'res_xy', imp_res_xy)
set_uniform_scalar(imp, 'res_z', imp_res_z)
emit(scale(0.75) * imp)
