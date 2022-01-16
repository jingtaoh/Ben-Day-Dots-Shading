#iChannel0 "images/spider-man/black-p.png"
#iChannel1 "images/paper.jpeg"

const vec3 B = vec3(0., 0.678, 0.937);
const vec3 R = vec3(0.929, 0., 0.549);
const vec3 Y = vec3(0.996, 0.949, 0.);
const vec3 W = vec3(1.);

const float DOT_SIZE = 0.00125;

float sdCircle(vec2 uv, float r, vec2 offset) {
  float x = uv.x - offset.x;
  float y = uv.y - offset.y;

  return length(vec2(x, y)) - r;
}

float opRepeat(vec2 p, float r, vec2 c) {
  vec2 q = mod(p + 0.5 * c, c) - 0.5 * c;
  return sdCircle(q, r, vec2(0));
}

vec2 rotate(vec2 uv, float th) {
  return mat2(cos(th), sin(th), -sin(th), cos(th)) * uv;
}

vec3 drawDots(vec2 uv, vec3 col, float size, vec2 space, float th) {
  vec2 new_uv = uv - 0.5;                    // <-0.5,0.5>
  new_uv.x *= iResolution.x / iResolution.y; // fix aspect ratio
  new_uv = rotate(new_uv, th);

  float res = opRepeat(new_uv, size, space);
  res = step(0., res); // Same as res > 0. ? 1. : 0.;
  return mix(col, W, res);
}

vec3 drawLines(vec2 uv, vec3 col, float size, vec2 space, float th) {
  return drawDots(uv, col, size, space, th);
}

vec3 drawSolid(vec2 uv, vec3 col, float size, float space, float th) {
  return drawDots(uv, col, size, vec2(space), th);
}

vec4 RGBtoCMYK(vec3 rgb) {
  float K = 1.0 - max(max(rgb.r, rgb.g), rgb.b);
  return vec4((1.0 - rgb.r - K) / (1.0 - K), (1.0 - rgb.g - K) / (1.0 - K),
              (1.0 - rgb.b - K) / (1.0 - K), K);
}

vec3 CMYKtoRGB(vec4 cmyk) {
  return vec3((1.0 - cmyk.x) * (1.0 - cmyk.w), (1.0 - cmyk.y) * (1.0 - cmyk.w),
              (1.0 - cmyk.z) * (1.0 - cmyk.w));
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
  vec2 uv =
      fragCoord / iResolution.xy; // Normalized pixel coordinates (from 0 to 1)

  // light colors
  vec3 y2 = drawDots(uv, Y, DOT_SIZE, vec2(0.004), 75.);
  vec3 b2 = drawDots(uv, B, DOT_SIZE, vec2(0.004), 45.);
  vec3 r2 = drawDots(uv, R, DOT_SIZE, vec2(0.004), 105.);

  // dark colors
  vec3 y3 = drawLines(uv, Y, DOT_SIZE, vec2(0.002, 0.004), 75.);
  vec3 b3 = drawLines(uv, B, DOT_SIZE, vec2(0.002, 0.004), 45.);
  vec3 r3 = drawLines(uv, R, DOT_SIZE, vec2(0.002, 0.004), 105.);

  // solid solors
  vec3 y = drawSolid(uv, Y, DOT_SIZE, 0.002, 75.);
  vec3 b = drawSolid(uv, B, DOT_SIZE, 0.002, 45.);
  vec3 r = drawSolid(uv, R, DOT_SIZE, 0.002, 105.);

  vec3 col = texture(iChannel0, uv).rgb;
  vec4 cmyk = RGBtoCMYK(col);

  // Black: use negative
  vec3 col_k = CMYKtoRGB(vec4(vec3(0.), 1. - step(0.3, 1. - cmyk.a)));

  // Blue: divide cyan into 4 levels
  vec3 col_b = mix(mix(b, b3, step(cmyk.r, 0.6)),
                   mix(b2, W, step(cmyk.r, 0.15)), step(cmyk.r, 0.3));

  // Red: divide magenta into 4 levels
  vec3 col_r = mix(mix(r, r3, step(cmyk.g, 0.6)),
                   mix(r2, W, step(cmyk.g, 0.22)), step(cmyk.g, 0.44));

  // Yellow: divide yellow into 4 levels
  vec3 col_y = mix(mix(y, y3, step(cmyk.b, 0.6)),
                   mix(y2, W, step(cmyk.b, 0.22)), step(cmyk.b, 0.44));

  // Blend
  col = col_y * col_r * col_b * col_k * texture(iChannel1, uv).rgb;

  fragColor = vec4(col, 1.);
}

