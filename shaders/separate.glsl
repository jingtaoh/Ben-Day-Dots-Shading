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

const vec3 W = vec3(1.);

vec4 RGBtoCMYK(vec3 rgb) {
  float K = 1.0 - max(max(rgb.r, rgb.g), rgb.b);
  return vec4((1.0 - rgb.r - K) / (1.0 - K), (1.0 - rgb.g - K) / (1.0 - K),
              (1.0 - rgb.b - K) / (1.0 - K), K);
}

vec3 CMYKtoRGB(vec4 cmyk) {
  return vec3((1.0 - cmyk.x) * (1.0 - cmyk.w), (1.0 - cmyk.y) * (1.0 - cmyk.w),
              (1.0 - cmyk.z) * (1.0 - cmyk.w));
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
  vec2 uv =
      fragCoord / iResolution.xy; // Normalized pixel coordinates (from 0 to 1)

  vec3 col = texture(iChannel0, uv).rgb;
  vec4 cmyk = RGBtoCMYK(col);

  // Black: use negative
  vec3 col_k = CMYKtoRGB(vec4(vec3(0.), 1. - step(0.3, 1. - cmyk.a)));

  // Blue: divide cyan into 4 levels
  vec3 col_b = mix(mix(B, B3, step(cmyk.r, 0.6)),
                   mix(B2, W, step(cmyk.r, 0.15)), step(cmyk.r, 0.3));

  // Red: divide magenta into 4 levels
  vec3 col_r = mix(mix(R, R3, step(cmyk.g, 0.6)),
                   mix(R2, W, step(cmyk.g, 0.22)), step(cmyk.g, 0.44));

  // Yellow: divide yellow into 4 levels
  vec3 col_y = mix(mix(Y, Y3, step(cmyk.b, 0.6)),
                   mix(Y2, W, step(cmyk.b, 0.22)), step(cmyk.b, 0.44));

  // Blend
  col = col_y * col_r * col_b * col_k;

  fragColor = vec4(col, 1.); // Output to screen
}
