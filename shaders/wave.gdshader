shader_type canvas_item;

uniform float wave_speed : hint_range(0.0, 10.0) = 6.09;
uniform float wave_frequency : hint_range(0.0, 30.0) = 30.0;
uniform float max_pixel_offset : hint_range(0.0, 8.0) = 0.537;
uniform float pixel_size : hint_range(1.0, 8.0) = 1.0;
uniform float bottom_strength : hint_range(0.0, 5.0) = 0.0;

const vec2[4] DIRECTIONS = {
	vec2(1.0, 0.0),
	vec2(0.0, 1.0),
	vec2(-1.0, 0.0),
	vec2(0.0, -1.0)
};

void fragment() {
    vec2 texture_size = vec2(textureSize(TEXTURE, 0));
    vec2 pixel_pos = UV * texture_size;
    pixel_pos = floor(pixel_pos / pixel_size) * pixel_size;
    vec2 pixel_uv = pixel_pos / texture_size;

    float heat_strength = pow(1.0 - UV.y, bottom_strength);

    float wave = sin(
        pixel_pos.y * wave_frequency / texture_size.y
        + TIME * wave_speed
    );
    float wave2 = sin(
        pixel_pos.y * wave_frequency * 1.7 / texture_size.y
        - TIME * wave_speed * 0.7
    );
    float offset_pixels =
        round((wave + wave2 * 0.35)
        * max_pixel_offset
        * heat_strength);

    pixel_pos.x += offset_pixels;
    pixel_pos.x = clamp(pixel_pos.x, 0.0, texture_size.x - 1.0);
    pixel_uv = (floor(pixel_pos) + 0.5) / texture_size;
	
	if(TEXTURE_PIXEL_SIZE.x > 0.0) {
		COLOR = texture(TEXTURE, pixel_uv);
	} else {
		COLOR = COLOR;
	}
}
