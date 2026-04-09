
float sdBox(vec3 p, float size)
{
    vec3 q = abs(p) - size;
    return length(max(q, 0.0)) + min (max(q.x,max(q.y, q.z)), 0.0);
}

float map(vec3 p)
{
    return sdBox(p, 1.);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) 
{
    vec2 uv = (fragCoord * 2. - iResolution.xy) / iResolution.y;
    vec3 ro = vec3(0,0,0);
    vec3 rd = normalize(vec3(uv,1));
    float t = 0.;
    vec3 col = vec3(0);
    
    int i;
    for (i;i<100;i++)
    {
        vec3 p = ro + rd * t;
        float d = map(p);
        t += d;


        if (t > 100.) break;
        if (d < 0.01) break;
    }

    // col = vec3(t* 0.8);
    col  = vec3(t *.08); //colour based on distance travelled
    fragColor = vec4(col, 1.);
    // fragColor = vec4(1, 0, 0, 1.);
}