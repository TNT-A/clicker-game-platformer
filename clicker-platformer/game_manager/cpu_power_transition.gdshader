shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0) = 0.0;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
    vec2 uv = SCREEN_UV;

    // Phase 1: Vertical collapse (progress 0.0 -> 0.3)
    float shrink_y = smoothstep(0.0, 0.3, progress);
    float vertical_factor = mix(1.0, 0.001, shrink_y);

    // Phase 2: Horizontal collapse into a dot (progress 0.25 -> 0.45)
    float shrink_x = smoothstep(0.25, 0.45, progress);
    float horizontal_factor = mix(1.0, 0.001, shrink_x);

    // Scale UV coordinates from the center (0.5, 0.5)
    vec2 centered_uv = (uv - 0.5) / vec2(horizontal_factor, vertical_factor) + 0.5;

    // Default canvas background color is absolute black
    vec4 col = vec4(0.0, 0.0, 0.0, 1.0);

    // Sample texture only if within valid screen boundaries
    if (centered_uv.y >= 0.0 && centered_uv.y <= 1.0 &&
        centered_uv.x >= 0.0 && centered_uv.x <= 1.0 && shrink_x < 1.0) {
        col = texture(SCREEN_TEXTURE, centered_uv);
    }

    // Phase 3: CRT Glow Line & Central Dot Artifact
    float line_w = mix(0.5, 0.002, shrink_y);
    float line_flash = smoothstep(line_w, 0.0, abs(uv.y - 0.5));

    // Narrow down the glow horizontally into a dot shape as shrink_x advances
    float dot_w = mix(0.5, 0.002, shrink_x);
    float dot_flash = smoothstep(dot_w, 0.0, abs(uv.x - 0.5));

    // Combine line and dot intensities for the final glowing point
    float intensity = mix(0.0, 4.0, shrink_y) * mix(1.0, 2.0, shrink_x);
    col.rgb += vec3(line_flash * dot_flash * intensity);

    // Phase 4: Final blackout switch
    float black_out = smoothstep(0.42, 0.48, progress);
    col.rgb = mix(col.rgb, vec3(0.0), black_out);

    COLOR = col;
}
