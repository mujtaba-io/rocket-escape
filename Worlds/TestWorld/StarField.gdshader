shader_type canvas_item;

// Controls
uniform float time_scale : hint_range(0.1, 10.0) = 1.0;
uniform float pattern_density : hint_range(100.0, 1000.0) = 600.0;
uniform float fade_intensity : hint_range(10.0, 200.0) = 100.0;
uniform vec2 offset = vec2(0.2, 0.2);
uniform float scale = 2000.0;

void fragment() {
    // Convert UV coordinates to centered coordinates similar to Shadertoy
    vec2 p = (UV * 2.0 - 1.0) * scale;
    p = p/scale - offset;

    // Main pattern calculation
    float b = ceil(atan(p.x, p.y) * pattern_density);
    float h = cos(b);
    float z = h / dot(p,p);

    // Time-based animation using TIME built-in variable
    float final_color = exp(fract(z + h * b + TIME * time_scale) * -fade_intensity) / z;

    // Output the color
    COLOR = vec4(final_color,final_color,final_color, 1.0);
}