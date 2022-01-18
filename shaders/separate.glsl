#iChannel0 "images/spider-man/spider-man.png"

const vec3 B = vec3(0., 0.678, 0.937);
const vec3 B3 = vec3(0.431, 0.816, 0.969);
const vec3 B2 = vec3(0.722, 0.898, 0.980);

const vec3 R = vec3(0.929, 0., 0.549);
const vec3 R3 = vec3(0.957, 0.604, 0.753);
const vec3 R2 = vec3(0.973, 0.796, 0.875);

const vec3 Y = vec3(0.996, 0.949, 0.);
const vec3 Y3 = vec3(1., 0.969, 0.604);
const vec3 Y2 = vec3(1., 0.984, 0.8);

const vec3 K = vec3(0.);
const vec3 K3 = vec3(0.6);
const vec3 K2 = vec3(0.8);

const vec3 W = vec3(1.);

vec4 RGBtoCMYK(vec3 rgb) {
  float K = 1.0 - max(max(rgb.r, rgb.g), rgb.b);
  return vec4((1.0 - rgb.r - K) / (1.0 - K), (1.0 - rgb.g - K) / (1.0 - K),
              (1.0 - rgb.b - K) / (1.0 - K), K);
}

vec3 outline(vec2 fragCoord, sampler2D tex) {
  vec4 n = texture(tex, (fragCoord + vec2(0, 1)) / iResolution.xy);
  vec4 e = texture(tex, (fragCoord + vec2(1, 0)) / iResolution.xy);
  vec4 s = texture(tex, (fragCoord + vec2(0, -1)) / iResolution.xy);
  vec4 w = texture(tex, (fragCoord + vec2(-1, 0)) / iResolution.xy);

  vec4 dy = (n - s) * .5;
  vec4 dx = (e - w) * .5;

  vec4 edge = sqrt(dx * dx + dy * dy);

  vec3 col = step(0.1, edge.rgb);

  // set black if any of the channle have value
  return (1. - step(0.1, length(col))) * W;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
  vec2 uv =
      fragCoord / iResolution.xy; // Normalized pixel coordinates (from 0 to 1)

  // Offset for misregistration
  const float offset = 0.004;

  vec3 col = texture(iChannel0, uv).rgb;
  vec3 col_neg_off = texture(iChannel0, uv - vec2(offset)).rgb;
  vec3 col_pos_off = texture(iChannel0, uv + vec2(offset)).rgb;

  vec4 cmyk_k = RGBtoCMYK(col);
  vec4 cmyk_b = RGBtoCMYK(col);
  vec4 cmyk_r = RGBtoCMYK(col_neg_off);
  vec4 cmyk_y = RGBtoCMYK(col_pos_off);

  // Black: divide black into 4 levels + outline
  vec3 col_k = mix(mix(W, K2, step(0.4, cmyk_k.a)),
                   mix(K3, K, step(0.8, cmyk_k.a)), step(0.6, cmyk_k.a));
  col_k *= outline(fragCoord, iChannel0);

  // Blue: divide cyan into 4 levels
  vec3 col_b = mix(mix(W, B2, step(0.15, cmyk_b.r)),
                   mix(B3, B, step(0.6, cmyk_b.r)), step(0.3, cmyk_b.r));

  // Red: divide magenta into 4 levels
  vec3 col_r = mix(mix(W, R2, step(0.22, cmyk_r.g)),
                   mix(R3, R, step(0.6, cmyk_r.g)), step(0.44, cmyk_r.g));

  // Yellow: divide yellow into 4 levels
  vec3 col_y = mix(mix(W, Y2, step(0.22, cmyk_y.b)),
                   mix(Y3, Y, step(0.6, cmyk_y.b)), step(0.44, cmyk_y.b));

  // Blend
  col = col_y * col_r * col_b * col_k;

  fragColor = vec4(col, 1.); // Output to screen
}
