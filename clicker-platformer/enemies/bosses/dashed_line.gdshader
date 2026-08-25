shader_type canvas_item;

uniform float dash_frequency = 0.2; // Higher values = more, smaller dashes
uniform float dash_ratio = 0.3;      // 0.5 means 50% dash, 50% gap
uniform float speed = -2.0;           // Marching speed (set to 0.0 to static)

void fragment() {
    // Slices horizontal UV space cleanly into repeating intervals
    float dash = step(dash_ratio, fract(UV.x * dash_frequency - TIME * speed));
    
    // Mix the original Line2D color properties with the transparency cuts
    COLOR = vec4(COLOR.rgb, COLOR.a * dash);
}
