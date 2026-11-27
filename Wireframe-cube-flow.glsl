#define AA 2   // make this 2 or 3 for antialiasing


vec3 rot3D(vec3 p, vec3 axis, float angle)
{
    // rodrigues formula (research later)
    // axis must be normalized
    return mix(dot(axis, p) * axis, p, cos(angle))
                    + cross(axis, p) * sin(angle);
}

mat2 rot2D (float angle)
{
    float s = sin(angle);
    float c = cos(angle);
    return mat2(c, -s, s, c);
}


float sdBox( vec3 p, vec3 b )
{
  vec3 q = abs(p) - b;
  return length(max(q,0.0)) + min(max(q.x,max(q.y,q.z)),0.0);
}

float sdBoxFrame( vec3 p, vec3 b, float e )
{
       p = abs(p  )-b;
  vec3 q = abs(p+e)-e;
  return min(min(
      length(max(vec3(p.x,q.y,q.z),0.0))+min(max(p.x,max(q.y,q.z)),0.0),
      length(max(vec3(q.x,p.y,q.z),0.0))+min(max(q.x,max(p.y,q.z)),0.0)),
      length(max(vec3(q.x,q.y,p.z),0.0))+min(max(q.x,max(q.y,p.z)),0.0));
}

float sdSphere( vec3 p, float s )
{
  return length(p)-s;
}

float map(vec3 p)
{
    // space repetition
    vec3 r = p;
    // r = mod(r, sin(iTime /2.)) - (sin(iTime / 2.) / 2.); 
    // r.z+= iTime;
    r.x += sin(iTime*0.2)*1.5;
    // float y =  abs(sin(iTime)) + .6;
    float y =  1.7;
    // float y;
    // y += 1.;
    r = mod(r, y) - (y/2.); 
    // r.y += 0.2;
    return sdBoxFrame(r, vec3(.3), .02);
}

vec3 pallete (float t)
{
    vec3 a = vec3(.8, .3, .4);
    vec3 b = vec3(.2, .4, .4);
    vec3 c = vec3(.5, .5, .5);
    vec3 d = vec3(.3, .5, .5);
    return a + b*cos(6.28318*(c*t+d));
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 uv = (fragCoord * 2.0 - iResolution.xy) / iResolution.y;
    fragColor = vec4(uv,0, 1.);

    // raytracing
    vec3 ro = vec3(0, 0, iTime);
    vec3 rd = normalize(vec3(uv, 1));
    float t = 0.;
    vec3 col = vec3(0.);


    // camera rotation
    // rd.xz *= rot2D(iTime);        
    // ro.xz *= rot2D(iTime);        

    int i;
    for (i;i<100;i++)
    {
        vec3 p = ro + rd*t;
        // camera distortion
        p.xy *= rot2D(t * 0.1);
        p.xy += sin(t * .4);

        float d = map(p);
        t += d;

        if (d < 0.01) break;
        if (t > 100.) break;
    }

        col = pallete(t* 0.2 + float(i) *0.02); 
        fragColor = vec4(col, 1.);
}
