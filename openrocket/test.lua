
local implicit_precision = 0.01

function BodyTube(cfg)
  return rotate(0, 90, 0) * difference(cylinder(cfg.outer_radius, cfg.length), cylinder(cfg.inner_radius, cfg.length))
end

function trapezoid_symmetrical_naca_airfoil(cfg)
   local airfoil = implicit_solid(
      v(0, -cfg.thickness/2, 0),
      v(cfg.sweep + cfg.length, cfg.thickness/2, cfg.height),
      implicit_precision,
[[
uniform highp float t = 0.12;
uniform highp float chord_length = 40.0;
uniform highp float sweep_coeff = 0.0;
uniform highp float chord_coeff = 0.0;
highp float solid(vec3 p) {
        highp float c = chord_length - chord_coeff*p.z;
        highp float x = p.x - sweep_coeff * p.z;
        // This avoid some numerical instabilities
        if (x < 0 || x > c) {
          return 1;
        }
        highp float xc = x / c;
        highp float sdf = t / 0.2 *(0.2969 * sqrt(xc) - 0.1260 * xc - 0.3516 * pow(xc, 2) + 0.2843 * pow(xc, 3) - 0.1015 * pow(xc, 4));
        return abs(p.y) - sdf ;
}
]])
   set_uniform_scalar(airfoil, 't', cfg.thickness)
   set_uniform_scalar(airfoil, 'chord_length', cfg.root_chord)
   set_uniform_scalar(airfoil, 'sweep_coeff', cfg.sweep/cfg.height)
   set_uniform_scalar(airfoil, 'chord_coeff', (cfg.root_chord - cfg.tip_chord)/cfg.height)
   return rotate(-90, 0, 0) * airfoil
end

function square_airfoil(cfg)
   return translate(0, 0, -cfg.thickness/2) * linear_extrude(v(0, 0, cfg.thickness), cfg.fin_points)
end

function TrapezoidFinSet(cfg)
   local creator_function
   if (cfg.cross_section == 'AIRFOIL') then
      creator_function = trapezoid_symmetrical_naca_airfoil
   else
      creator_function = square_airfoil
   end
   local a_fin = translate(0, cfg.body_radius, 0) * creator_function(cfg)
   fins = {}
   for i=1,cfg.fin_count do
      table.insert(fins, rotate((i * 360)/cfg.fin_count, 0, 0) * a_fin)
   end
   return translate(cfg.position) * union(fins)
end
function InnerTube(cfg)
   return BodyTube(cfg)
end

function LaunchLug(cfg)
   return translate(v(0, cfg.axial_offset, 0)) * BodyTube(cfg)
end

function ConicalTransition(cfg)
   return translate(cfg.position) * cone(cfg.fore_radius, cfg.aft_radius, v(cfg.length, 0, 0), v(0, 0, 0))
end

function withAftShoudler(shape, cfg)
   local shoulder_pos = cfg.position + v(cfg.length, 0, 0)
   local shoulder = translate(shoulder_pos) * rotate(0, 90, 0) * difference(cylinder(cfg.aft_shoulder.radius, cfg.aft_shoulder.length), cylinder(cfg.aft_shoulder.radius - cfg.aft_shoulder.thickness, cfg.aft_shoulder.length))
   return union{shoulder, shape}
end

function PowerseriesNoseCone(cfg)
      local max_radius = math.max(1, cfg.shape_param) * math.max(cfg.fore_radius, cfg.aft_radius)
   ogive = implicit_solid(
      v(0, -max_radius, -max_radius),
      v(cfg.length, max_radius, max_radius),
      implicit_precision,
[[
uniform float param = 1.0;
uniform float len = 2.5;
uniform float radius = 2.5;
uniform float thickness = 0.3;
float solid(vec3 p) {
	float sdf = length(p.yz) - radius * pow(p.x / len, param);
        return abs(sdf) - thickness;
}
]])
   set_uniform_scalar(ogive, 'len', cfg.length)
   set_uniform_scalar(ogive, 'radius', cfg.aft_radius - cfg.thickness)
   set_uniform_scalar(ogive, 'param', cfg.shape_param)
   set_uniform_scalar(ogive, 'thickness', cfg.thickness)
   return withAftShoudler(ogive, cfg)
end
function TubeCoupler(cfg)
   return BodyTube(cfg)
end

function CenteringRing(cfg)
   return BodyTube(cfg)
end

function ConicalNoseCone(cfg)
   return translate(cfg.position) * cone(cfg.fore_radius, cfg.aft_radius, v(0, 0, 0), v(cfg.length, 0, 0))
end

function pow2(v)
   return v * v
end

function OgiveNoseCone(cfg)
   local max_radius = math.max(1, pow2(cfg.shape_param)) * math.max(cfg.fore_radius, cfg.aft_radius)
   ogive = implicit_solid(
      v(0, -max_radius, -max_radius),
      v(cfg.length, max_radius, max_radius),
      implicit_precision,
[[
uniform float R = 1.0;
uniform float L = 1.0;
uniform float y0 = 0.0;
uniform float thickness = 0.3;
float solid(vec3 p) {
	float sdf = length(p.yz) - (sqrt(pow(R, 2) - pow(L - p.x, 2)) - y0);
        return abs(sdf) - thickness;
}
]])
   local radius = cfg.aft_radius - cfg.thickness;
   local R = math.sqrt((pow2(cfg.length) + pow2(radius)) *
	 (pow2((2 - cfg.shape_param) * cfg.length) + pow2(cfg.shape_param * radius)) / (4 * pow2(cfg.shape_param * radius)))
   local L = cfg.length / cfg.shape_param
   local y0 = math.sqrt(pow2(R) - pow2(L))
   print("" .. R .. "," ..  L .. "," .. y0)
   set_uniform_scalar(ogive, 'R', R)
   set_uniform_scalar(ogive, 'L', L)
   set_uniform_scalar(ogive, 'y0', y0)
   set_uniform_scalar(ogive, 'thickness', cfg.thickness)
   return withAftShoudler(ogive, cfg)
end

function EllipsoidNoseCone(cfg)
   local max_radius = math.max(1.5, pow2(cfg.shape_param)) * math.max(cfg.fore_radius, cfg.aft_radius)
   ogive = implicit_solid(
      v(0, -max_radius, -max_radius),
      v(cfg.length, max_radius, max_radius),
      implicit_precision,
[[
uniform float len = 2.5;
uniform float radius = 2.5;
uniform float thickness = 0.3;
float solid(vec3 p) {
	float x = p.x * radius / len;
	float sdf = length(p.yz) - sqrt(2 * radius * x - x * x);
        return abs(sdf) - thickness;
}
]])
   set_uniform_scalar(ogive, 'len', cfg.length)
   set_uniform_scalar(ogive, 'radius', cfg.aft_radius - cfg.thickness)
   set_uniform_scalar(ogive, 'thickness', cfg.thickness)
   return withAftShoudler(ogive, cfg)
end

function ParabolicNoseCone(cfg)
   local max_radius = math.max(1.5, pow2(cfg.shape_param)) * math.max(cfg.fore_radius, cfg.aft_radius)
   ogive = implicit_solid(
      v(0, -max_radius, -max_radius),
      v(cfg.length, max_radius, max_radius),
      implicit_precision,
[[
uniform float param = 1.0;
uniform float len = 2.5;
uniform float radius = 2.5;
uniform float thickness = 0.3;
float solid(vec3 p) {
        float sdf = length(p.yz) - radius * ((2 * p.x / len - param * pow(p.x / len, 2)) / (2 - param));
        return abs(sdf) - thickness;
}
]])
   set_uniform_scalar(ogive, 'len', cfg.length)
   set_uniform_scalar(ogive, 'radius', cfg.aft_radius - cfg.thickness)
   set_uniform_scalar(ogive, 'param', cfg.shape_param)
   set_uniform_scalar(ogive, 'thickness', cfg.thickness)
   return withAftShoudler(ogive, cfg)
end

function HaackNoseCone(cfg)
   local max_radius = math.max(2.0, pow2(cfg.shape_param)) * math.max(cfg.fore_radius, cfg.aft_radius)
   ogive = implicit_solid(
      v(0, -max_radius, -max_radius),
      v(cfg.length, max_radius, max_radius),
      implicit_precision,
[[
uniform float len = 2.5;
uniform float param = 1.0;
uniform float radius = 2.5;
uniform float thickness = 0.3;
float solid(vec3 p) {
        float theta = acos(1 - 2 * p.x / len);
	float sdf= length(p.yz) - radius * sqrt((theta - sin(2*theta) / 2 + param * pow(sin(theta), 3)));
        return abs(sdf) - thickness;
}
]])
   set_uniform_scalar(ogive, 'len', cfg.length)
   set_uniform_scalar(ogive, 'radius', cfg.aft_radius - cfg.thickness)
   set_uniform_scalar(ogive, 'param', cfg.shape_param)
   set_uniform_scalar(ogive, 'thickness', cfg.thickness)
   return withAftShoudler(ogive, cfg)
end
function Ogive()
  -- expected mass of the section: 0.012137169839827384
  -- actual java class net.sf.openrocket.rocketcomponent.NoseCone
  return translate(v(0.0, 0.0, 0.0)) * OgiveNoseCone{
    thickness = 1.1,
    shape_param = 1.0,
    fore_radius = 0.0,
    aft_radius = 12.5,
    aft_shoulder={
        length = 17.0,
        radius = 11.299999999999999,
        thickness = 3.0,
        is_capped = false,
    },
    length = 103.00000000000001,
    position = v(0.0, 0.0, 0.0),
    axial_offset = 0.0,
  }
end

function Tube_de_guidage()
  -- expected mass of the section: 5.879050828221797E-5
  -- actual java class net.sf.openrocket.rocketcomponent.LaunchLug
  return translate(v(79.5, 0.0, 0.0)) * LaunchLug{
    outer_radius = 2.2500000000000004,
    inner_radius = 2.0500000000000003,
    thickness = 0.2,
    instance_count = 1.0,
    instance_separation = 0.0,
    length = 32.0,
    position = v(79.5, 0.0, 0.0),
    axial_offset = 14.5000000000000004,
  }
end

function Parachute()
  -- expected mass of the section: 0.011659468311620647
  -- actual java class net.sf.openrocket.rocketcomponent.Parachute
  return translate(v(20.0, 0.0, 0.0)) * box(0)
end

function Cordon_amortisseur()
  -- expected mass of the section: 0.00108
  -- actual java class net.sf.openrocket.rocketcomponent.ShockCord
  return translate(v(20.0, 0.0, 0.0)) * box(0)
end

function Tube_du_corps()
  -- expected mass of the section: 0.015493971322858404
  -- actual java class net.sf.openrocket.rocketcomponent.BodyTube
  return translate(v(103.00000000000001, 0.0, 0.0)) * union{
BodyTube{
    outer_radius = 12.5,
    inner_radius = 12.17,
    length = 155.0,
    position = v(103.00000000000001, 0.0, 0.0),
    axial_offset = 0.0,
  },
    Tube_de_guidage(),
    Parachute(),
    Cordon_amortisseur(),
  }
end

function Coupleur_de_tube_Ailerons()
  -- expected mass of the section: 3.6570494682275383E-4
  -- actual java class net.sf.openrocket.rocketcomponent.TubeCoupler
  return translate(v(-5.0, 0.0, 0.0)) * TubeCoupler{
    outer_radius = 11.2,
    inner_radius = 9.549999999999999,
    thickness = 1.6500000000000001,
    length = 5.0,
    position = v(-5.0, 0.0, 0.0),
    axial_offset = -5.0,
  }
end

local shape = ui_number('airfoil shape?', 1, 0, 1)
if shape > 0.5 then
   shape = 'AIRFOIL'
else
   shape = 'SQUARE'
end

function Ailerons_Trap_zo_daux()
  -- expected mass of the section: 0.009063912000000004
  -- actual java class net.sf.openrocket.rocketcomponent.TrapezoidFinSet
  return translate(v(0.0, 0.0, 0.0)) * TrapezoidFinSet{
    fin_count = 3.0,
    cant_angle = 0.017453292519943295,
    fillet_radius = 0.0,
    cross_section = shape,
    tab_points = {},
    root_points = {v(0.0, 0.0, 0.0),v(57.99999999999999, 0.0, 0.0),},
    body_radius = 12.5,
    length = 58.000000000000014,
    position = v(0.0, 0.0, 0.0),
    axial_offset = 0.0,
    tip_chord = 30.0,
    sweep = 81.0,
    height = 38.0,
    root_chord = 58.000000000000014,
    position = v(0.0, 0.0, 0.0),
    thickness = 1.3000000000000003,
    fin_points = {v(0.0, 0.0, 0.0),v(81.0, 38.0, 0.0),v(111.0, 38.0, 0.0),v(58.000000000000014, 0.0, 0.0),},
  }
end

function Anneau_de_centrage_1()
  -- expected mass of the section: 4.802737018093435E-4
  -- actual java class net.sf.openrocket.rocketcomponent.CenteringRing
  return translate(v(47.47, 0.0, 0.0)) * CenteringRing{
    outer_radius = 11.2,
    inner_radius = 9.54,
    thickness = 1.66,
    length = 6.53,
    position = v(47.47, 0.0, 0.0),
    axial_offset = -4.0,
    length = 6.53,
    position = v(47.47, 0.0, 0.0),
  }
end

function Anneau_de_centrage_2()
  -- expected mass of the section: 4.802737018093435E-4
  -- actual java class net.sf.openrocket.rocketcomponent.CenteringRing
  return translate(v(6.469999999999996, 0.0, 0.0)) * CenteringRing{
    outer_radius = 11.2,
    inner_radius = 9.54,
    thickness = 1.66,
    length = 6.53,
    position = v(6.469999999999996, 0.0, 0.0),
    axial_offset = -45.0,
    length = 6.53,
    position = v(6.469999999999996, 0.0, 0.0),
  }
end

function Tube_interne_Moteur()
  -- expected mass of the section: 8.938891701142838E-4
  -- actual java class net.sf.openrocket.rocketcomponent.InnerTube
  return translate(v(-12.00000000000001, 0.0, 0.0)) * InnerTube{
    outer_radius = 9.5,
    inner_radius = 9.18,
    thickness = 0.32,
    length = 70.0,
    position = v(-12.00000000000001, 0.0, 0.0),
    axial_offset = 0.0,
  }
end

function Tube_du_corps_des_Ailerons()
  -- expected mass of the section: 0.01908746242431125
  -- actual java class net.sf.openrocket.rocketcomponent.BodyTube
  return translate(v(258.0, 0.0, 0.0)) * union{
BodyTube{
    outer_radius = 12.5,
    inner_radius = 11.2,
    length = 57.99999999999999,
    position = v(258.0, 0.0, 0.0),
    axial_offset = 0.0,
  },
    Coupleur_de_tube_Ailerons(),
    Ailerons_Trap_zo_daux(),
    Anneau_de_centrage_1(),
    Anneau_de_centrage_2(),
    Tube_interne_Moteur(),
  }
end

function Sustainer()
  -- expected mass of the section: 0.04671860358699703
  -- actual java class net.sf.openrocket.rocketcomponent.AxialStage
  return translate(v(0.0, 0.0, 0.0)) * union{
    Ogive(),
    Tube_du_corps(),
    Tube_du_corps_des_Ailerons(),
  }
end

function Fus_e()
  -- expected mass of the section: 0.04671860358699703
  -- actual java class net.sf.openrocket.rocketcomponent.Rocket
  return translate(v(0.0, 0.0, 0.0)) * union{
    Sustainer(),
  }
end


--emit(Fus_e())
--emit(translate(40, 40, 1.5*258) * rotate(0, 90, 0) * Ogive())
--emit(Tube_du_corps(), 2)
emit(rotate(180, 0, 0) * translate(0, 0, -10) * rotate(0, 90, 0) *  Tube_du_corps_des_Ailerons())
