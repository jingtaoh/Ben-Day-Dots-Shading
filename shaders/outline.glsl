#iChannel0 "images/spider-man/spider-man.png"

const vec3 W = vec3(1.);

// Credit to https://www.shadertoy.com/view/td2yDm
vec3 outline(vec2 fragCoord, sampler2D tex) {
  vec4 n = texture(tex, (fragCoord + vec2(0, 1)) / iResolution.xy);
  vec4 e = texture(tex, (fragCoord + vec2(1, 0)) / iResolution.xy);
  vec4 s = texture(tex, (fragCoord + vec2(0, -1)) / iResolution.xy);
  vec4 w = texture(tex, (fragCoord + vec2(-1, 0)) / iResolution.xy);

  vec4 dy = (n - s) * .5;
  vec4 dx = (e - w) * .5;

  vec4 edge = sqrt(dx * dx + dy * dy);

  vec3 col = step(0.1, edge.rgb);

  // set to black if any of the channle have value
  return (1. - step(0.1, length(col))) * W;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
  fragColor = vec4(outline(fragCoord, iChannel0), 1.);
}