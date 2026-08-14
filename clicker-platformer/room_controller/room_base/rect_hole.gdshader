shader_type canvas_item;
void fragment() {
    if (FRAGCOORD.x < 50.0 && FRAGCOORD.y < 50.0) {
        discard;
    }
    COLOR = vec4(1.0, 0.0, 0.0, 1.0); // Red color
}
