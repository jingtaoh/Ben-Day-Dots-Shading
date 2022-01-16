#iChannel0 "images/yellow-s.jpg"
#iChannel1 "images/magenta-s.jpg"
#iChannel2 "images/cyan-s.jpg"
#iChannel3 "images/black-s.jpg"

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
  vec2 uv =
      fragCoord / iResolution.xy; // Normalized pixel coordinates (from 0 to 1)

  vec3 col_y = texture(iChannel0, uv).rgb;
  vec3 col_r = texture(iChannel1, uv).rgb;
  vec3 col_b = texture(iChannel2, uv).rgb;
  vec3 col_k = texture(iChannel3, uv).rgb;
  
  vec3 col = col_y * col_r * col_b * col_k;

  fragColor = vec4(col, 1.); // Output to screen
}
