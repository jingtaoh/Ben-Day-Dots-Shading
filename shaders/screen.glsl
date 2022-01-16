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
const vec3 K = vec3(0.);

const float DOT_SIZE = 0.0025;

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

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
  vec2 uv = fragCoord / iResolution.xy;

  // light colors
  vec3 y2 = drawDots(uv, Y, DOT_SIZE, vec2(0.008), 75.);
  vec3 b2 = drawDots(uv, B, DOT_SIZE, vec2(0.008), 45.);
  vec3 r2 = drawDots(uv, R, DOT_SIZE, vec2(0.008), 105.);

  // dark colors
  vec3 y3 = drawLines(uv, Y, DOT_SIZE, vec2(0.004, 0.008), 75.);
  vec3 b3 = drawLines(uv, B, DOT_SIZE, vec2(0.004, 0.008), 45.);
  vec3 r3 = drawLines(uv, R, DOT_SIZE, vec2(0.004, 0.008), 105.);

  // solid solors
  vec3 y = drawSolid(uv, Y, DOT_SIZE, 0.004, 75.);
  vec3 b = drawSolid(uv, B, DOT_SIZE, 0.004, 45.);
  vec3 r = drawSolid(uv, R, DOT_SIZE, 0.004, 105.);

  // color board
  vec3 col_B = mix(B2, mix(B3, B, step(0.66, uv.x)), step(0.33, uv.x));
  vec3 col_b = mix(b2, mix(b3, b, step(0.66, uv.x)), step(0.33, uv.x));

  vec3 col_R = mix(R2, mix(R3, R, step(0.66, uv.x)), step(0.33, uv.x));
  vec3 col_r = mix(r2, mix(r3, r, step(0.66, uv.x)), step(0.33, uv.x));

  vec3 col_Y = mix(Y2, mix(Y3, Y, step(0.66, uv.x)), step(0.33, uv.x));
  vec3 col_y = mix(y2, mix(y3, y, step(0.66, uv.x)), step(0.33, uv.x));

  vec3 col = mix(col_y,
                 mix(col_Y,
                     mix(col_r,
                         mix(col_R, mix(col_b, col_B, step(0.825, uv.y)),
                             step(0.66, uv.y)),
                         step(0.495, uv.y)),
                     step(0.33, uv.y)),
                 step(0.165, uv.y));

  fragColor = vec4(col, 1.);
}