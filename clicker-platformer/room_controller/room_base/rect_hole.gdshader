shader_type canvas_item;

// Pass these variables from your script
uniform vec2 map_min_world;      // Top-left corner of map in pixels
uniform vec2 map_max_world;      // Bottom-right corner of map in pixels
uniform vec2 camera_world_pos;  // The global position of your Camera2D
uniform vec2 screen_resolution;  // The viewport size (e.g., 1152, 648)

void fragment() {
    // 1. Calculate the offset from the screen center
    vec2 screen_center = screen_resolution / 2.0;
    vec2 offset_from_center = FRAGCOORD.xy - screen_center;
    
    // 2. Derive the exact World Space position of this screen pixel
    vec2 world_pos = camera_world_pos + offset_from_center;

    // 3. Mask out everything outside the map boundaries
    if (world_pos.x < map_min_world.x || world_pos.x > map_max_world.x ||
        world_pos.y < map_min_world.y || world_pos.y > map_max_world.y) {
        
        // Pixel is OUTSIDE the map bounds: Make it black
        COLOR = vec4(0.0, 0.0, 0.0, 1.0);
    } else {
        // Pixel is INSIDE the map bounds: Keep it clear
        COLOR = vec4(0.0, 0.0, 0.0, 0.0);
    }
}
