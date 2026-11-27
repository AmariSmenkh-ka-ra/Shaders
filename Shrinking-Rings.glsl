void mainImage(out vec4 fragColor, in vec2 fragCoord ){
    vec2 uv = (fragCoord * 2.0 - iResolution.xy) / iResolution.y;

    vec3 col = vec3(0.0, 2.0, 2.0);

    float d = length(uv);
    d = sin(d * 8.0 + iTime)/8.0;
    // d = abs(d);
    d = smoothstep(0.0, 0.1, d);
    d = 0.02 / d;
    
    col *= d;
    fragColor = vec4( col, 1.0);
}
