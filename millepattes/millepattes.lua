-- seed = ui_scalar('seed', 1, 1, 1024)
-- math.randomseed(seed)

millepattes = implicit_distance_field(
v(-60, -5, -40),
v(25, 5, 7),
[[
float polysmin(float a, float b, float k)
{
    float h = clamp( 0.5+0.5*(b-a)/k, 0.0, 1.0 );
    return mix( b, a, h ) - k*h*(1.0-h);
}

float opBlend(float d1, float d2)
{
    return polysmin(d1, d2, 0.5);
}
float sdEllipsoid( in vec3 p, in vec3 c, in vec3 r )
{
    return (length( (p-c)/r ) - 1.0) * min(min(r.x,r.y),r.z);
}

vec2 sdSegment( in vec3 p, vec3 a, vec3 b )
{
	vec3 pa = p - a, ba = b - a;
	float h = clamp( dot(pa,ba)/dot(ba,ba), 0.0, 1.0 );
	return vec2( length( pa - ba*h ), h );
}

float sdSphere( in vec3 p, in vec3 c, in float r )
{
    return length(p-c) - r;
}

// http://research.microsoft.com/en-us/um/people/hoppe/ravg.pdf
float det( vec2 a, vec2 b ) { return a.x*b.y-b.x*a.y; }
vec3 getClosest( vec2 b0, vec2 b1, vec2 b2 )
{

  float a =     det(b0,b2);
  float b = 2.0*det(b1,b0);
  float d = 2.0*det(b2,b1);
  float f = b*d - a*a;
  vec2  d21 = b2-b1;
  vec2  d10 = b1-b0;
  vec2  d20 = b2-b0;
  vec2  gf = 2.0*(b*d21+d*d10+a*d20); gf = vec2(gf.y,-gf.x);
  vec2  pp = -f*gf/dot(gf,gf);
  vec2  d0p = b0-pp;
  float ap = det(d0p,d20);
  float bp = 2.0*det(d10,d0p);
  float t = clamp( (ap+bp)/(2.0*a+b+d), 0.0 ,1.0 );
  return vec3( mix(mix(b0,b1,t), mix(b1,b2,t),t), t );
}

vec2 sdBezier(vec3 p, vec3 a, vec3 b, vec3 c)
{
	vec3 w = normalize( cross( c-b, a-b ) );
	vec3 u = normalize( c-b );
	vec3 v = normalize( cross( w, u ) );

	vec2 a2 = vec2( dot(a-b,u), dot(a-b,v) );
	vec2 b2 = vec2( 0.0 );
	vec2 c2 = vec2( dot(c-b,u), dot(c-b,v) );
	vec3 p3 = vec3( dot(p-b,u), dot(p-b,v), dot(p-b,w) );

	vec3 cp = getClosest( a2-p3.xy, b2-p3.xy, c2-p3.xy );

	return vec2( sqrt(dot(cp.xy,cp.xy)+p3.z*p3.z), cp.z );
}

vec2 sdLine( vec3 p, vec3 a, vec3 b )
{
	vec3 pa = p-a, ba = b-a;
	float h = clamp( dot(pa,ba)/dot(ba,ba), 0.0, 1.0 );
	return vec2( length( pa - ba*h ), h );
}

float smin( float a, float b, float k )
{
	float h = clamp( 0.5 + 0.5*(b-a)/k, 0.0, 1.0 );
	return mix( b, a, h ) - k*h*(1.0-h);
}

vec2 smin( vec2 a, vec2 b, float k )
{
	float h = clamp( 0.5 + 0.5*(b.x-a.x)/k, 0.0, 1.0 );
	return vec2( mix( b.x, a.x, h ) - k*h*(1.0-h), mix( b.y, a.y, h ) );
}

float smax( float a, float b, float k )
{
	float h = clamp( 0.5 + 0.5*(b-a)/k, 0.0, 1.0 );
	return mix( a, b, h ) + k*h*(1.0-h);
}

//---------------------------------------------------------------------------

mat3 base( in vec3 ww )
{
    vec3  vv  = vec3(0.0,0.0,1.0);
    vec3  uu  = normalize( cross( vv, ww ) );
    return mat3(uu.x,ww.x,vv.x,
                uu.y,ww.y,vv.y,
                uu.z,ww.z,vv.z);
}


float distance(vec3 p) {
  vec3 pSym = vec3(p.x, abs(p.y), p.z); // plan(x,z) symmetry
  vec3 vEyeR = vec3(1.5, 1.0, 1.8);
  float sdHead = sdEllipsoid(pSym, vec3(0.0, 0.0, 0.0), vec3(3.0, 3.0, 3.80));
  float sdEyeRHole = sdEllipsoid(pSym, vEyeR, vec3(1.0, 1.0, 1.0));
  float sdEyeR = sdEllipsoid(pSym, vEyeR, vec3(.9, 0.9, 0.9));
  float d = smax(sdHead, -sdEyeRHole, 0.4);
  d = smax(d, -sdEyeRHole, 0.3);
  d = smin(sdEyeR, d, 0.4);
  float sdNoze = sdEllipsoid(pSym, vec3(3.5, 0.0, 0.2), vec3(1, 1, 1));
  d = smin(d, sdNoze, 0.5);
  vec3 pMouth = vec3(pSym.x, pSym.y, pSym.z - 0.15*sin(abs(0.7*pSym.y)));
  float sdMouth = sdEllipsoid(pMouth, vec3(1.3, 0, -1.5), vec3(1.8, 2.5, 2));
  float sdMouthHole = sdEllipsoid(pMouth, vec3(4.3, 0, -1.9), vec3(1.8, 2.5, 0.5));
  d = smin(d, sdMouth, 0.1);
  d = smax(d, -sdMouthHole, 0.2);
  float radiusMouthBorder = 0.8;
  float sdMouthBorder = sdEllipsoid(
    pMouth,
    vec3(1.9, 1.7, -1.9),
    vec3(radiusMouthBorder,radiusMouthBorder,radiusMouthBorder));
  d = smin(d, sdMouthBorder, 0.4);

  {
  vec2 antennaR = sdBezier(p,
    vec3(0, 1, 3),
    vec3(0, 1, 5),
    vec3(3, 2, 5));
  float tr = 0.5 + 0.1*antennaR.y;
  float d3 = antennaR.x - tr;
  d = smin(d, d3, 0.1);
  }
{
  vec2 antennaL = sdBezier(p,
    vec3(0, -1, 3),
    vec3(0, -1, 5.5),
    vec3(3, -2.5, 5.5));
  float tr = 0.5 + 0.15*antennaL.y;
  float d3 = antennaL.x - tr;
  d = smin(d, d3, 0.05);
  }
  int nb = 8;
  float ratio = nb/(2*3.1415);
  for(int i=1; i < nb; ++i) {
    vec3 center = vec3(2.5-2*3.1 * i, 0, -6 + mod(i, 2));
    float localSd = sdSphere(p, center, 3.6);
    d = smin(d, localSd, 1.8);
  }

  return d;
}
]])
emit(millepattes)
