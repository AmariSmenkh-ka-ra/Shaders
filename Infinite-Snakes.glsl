vec3 rot3D(vec3 p, vec3 axis, float angle)
{
    // rodrigues formula (research later)
    // axis must be normalized
    return mix(dot(axis, p) * axis, p, cos(angle))
                    + cross(axis, p) * sin(angle);
}
// can be used in 3D by ommitting an axis via swizzling
// the axis ommitted is the axis the object rotates around
// e.g p.xy *= rot2D(angle); rotates around y axis
mat2 rot2D (float angle)
{
    float s = sin(angle);
    float c = cos(angle);
    return mat2(c, -s, s, c);
}


float sdSphere(vec3 p, float size)
{
    return length(p) - size;
}

float sdBox(vec3 p, float size)
{
    vec3 q = abs(p) - size;
    return length(max(q, 0.0)) + min (max(q.x,max(q.y, q.z)), 0.0);
}


float smin (float a, float b, float k) // learn why this works
{
    float blend = max(k-abs(a-b), 0.0) / k;
    return min(a, b) - blend*blend*blend*k*(1.0/6.0) ;
}

float map(vec3 p) // gets the nearest distance of object to point
{ // this is where we define the layout of objects
    vec3 spherePos = vec3(0, 0, 0);
    vec3 q = p;
    q.xy *= rot2D(iTime);

    vec3 r = p;
    r.z += iTime;
    r.xy = fract(r.xy) - .5;
    r.z = mod(r.z, 0.25) - .125;

    float sphere = sdSphere(r * 15. - spherePos, 1.);
    float cube = sdBox(r * 7.0, 0.75) / 7.;
    // float ground = p.y + .75;
    return smin(sphere, cube, 3.);
    // return smin(ground, smin(sphere, cube, 2.), .3);

}


vec3 pallete (float t)
{
    vec3 a = vec3(1.048, 0.778, 0.818);
    vec3 b = vec3(.8, .6, .7);
    vec3 c = vec3(3.138, 3.138, .5);
    vec3 d = vec3(0.128, -2.022, 5.401);
    return a + b*cos(6.28318*(c*t+d));
}


void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 uv = (fragCoord * 2. - iResolution.xy) / iResolution.y;
    // fragColor = vec4(d, 0, 0, 1.);
    vec2 m = (iMouse.xy * 2. - iResolution.xy) / iResolution.y;


    // init
    vec3 ro = vec3(0, 0, -3); // ray origin
    vec3 rd = normalize(vec3(uv, 1)); // ray direction
    // normalize makes all vectors have a scale of 1
    vec3 col = vec3(0);
    float t = 0.; // total travel distance of ray

    // view rotation
    // ro.xz *= rot2D(iTime);
    rd.xz *= rot2D(sin(iTime / 2.) / 2.);
    rd.yz *= rot2D(cos(iTime / 2.) / 3.);
    ro.xz *= rot2D(sin(iTime / 2.) / 2.);

    //ray marching
    int i;
    for (i; i<80; i++)
    {
        vec3 p = ro + rd * t;

        // ray distortion
        // p.xy *= rot2D(t * 0.8) * 0.21;
        p.xy *= rot2D(t * 0.2);
        p.x += sin(t * .8);
        

        float d = map(p); // current distance of ray to scene
        t += d;
        

        //optimisation
        // col = vec3(i) / 80.; // colour based on number of iterations
        if (d < 0.01) break; // breaks if the distance of the ray to an object is really small
                                // stops calculating ray after collision
        if (t > 100.) break; // stops rays from travelling crazy distances
    }

    //colours
    // col  = vec3(t *.08); //colour based on distance travelled
    col = pallete(t * .04 + float(i)*0.005); 
    fragColor = vec4(col, 1);
}
