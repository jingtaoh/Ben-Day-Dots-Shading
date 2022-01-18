#iChannel0 "images/spider-man/spider-man.png"
#iChannel1 "images/paper.jpeg"

const vec3 B = vec3(0., 0.678, 0.937);
const vec3 R = vec3(0.929, 0., 0.549);
const vec3 Y = vec3(0.996, 0.949, 0.);
const vec3 K = vec3(0.);
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
  new_uv = rotate(new_uv, radians(180. - th));

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
  vec2 uv =
      fragCoord / iResolution.xy; // Normalized pixel coordinates (from 0 to 1)

  // light colors
  vec3 b2 = drawDots(uv, B, DOT_SIZE, vec2(0.004), 135.);
  vec3 r2 = drawDots(uv, R, DOT_SIZE, vec2(0.004), 75.);
  vec3 y2 = drawDots(uv, Y, DOT_SIZE, vec2(0.004), 105.);
  vec3 k2 = drawDots(uv, K, DOT_SIZE, vec2(0.004), 45.);

  // dark colors
  vec3 b3 = drawLines(uv, B, DOT_SIZE, vec2(0.0017, 0.004), 135.);
  vec3 r3 = drawLines(uv, R, DOT_SIZE, vec2(0.0017, 0.004), 75.);
  vec3 y3 = drawLines(uv, Y, DOT_SIZE, vec2(0.0017, 0.004), 105.);
  vec3 k3 = drawLines(uv, K, DOT_SIZE, vec2(0.0017, 0.004), 45.);

  // solid colors
  vec3 b = drawSolid(uv, B, DOT_SIZE, 0.0017, 135.);
  vec3 r = drawSolid(uv, R, DOT_SIZE, 0.0017, 75.);
  vec3 y = drawSolid(uv, Y, DOT_SIZE, 0.0017, 105.);
  vec3 k = drawSolid(uv, K, DOT_SIZE, 0.0017, 45.);

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
  vec3 col_k = mix(mix(W, k2, step(0.4, cmyk_k.a)),
                   mix(k3, k, step(0.8, cmyk_k.a)), step(0.6, cmyk_k.a));
  col_k *= outline(fragCoord, iChannel0);

  // Blue: divide cyan into 4 levels
  vec3 col_b = mix(mix(W, b2, step(0.15, cmyk_b.r)),
                   mix(b3, b, step(0.6, cmyk_b.r)), step(0.3, cmyk_b.r));

  // Red: divide magenta into 4 levels
  vec3 col_r = mix(mix(W, r2, step(0.22, cmyk_r.g)),
                   mix(r3, r, step(0.6, cmyk_r.g)), step(0.44, cmyk_r.g));

  // Yellow: divide yellow into 4 levels
  vec3 col_y = mix(mix(W, y2, step(0.22, cmyk_y.b)),
                   mix(y3, y, step(0.6, cmyk_y.b)), step(0.44, cmyk_y.b));

  // Blend 4 passes
  col = col_y * col_r * col_b * col_k;
  // Blend with paper texture
  col * texture(iChannel1, uv).rgb;

  fragColor = vec4(col, 1.);
}