#iChannel0 "images/paper.jpeg"
#iChannel1 "images/spider-man/black-p.png"

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
  vec2 uv =
      fragCoord / iResolution.xy; // Normalized pixel coordinates (from 0 to 1)

  vec4 col = texture(iChannel0, uv);
  col *= texture(iChannel1, uv);

  fragColor = vec4(col); // Output to screen
}
