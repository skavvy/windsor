shader_type canvas_item;

uniform float wave_strength = 16.0;
uniform vec4 top_color: source_color = vec4(1.0);
uniform vec4 bottom_color: source_color = vec4(0.0);

vec2 random(vec2 uv){
    uv = vec2( dot(uv, vec2(127.1,311.7) ),
               dot(uv, vec2(269.5,183.3) 
) );
    return -1.0 + 2.0 * fract(sin(uv) * 43758.5453123);
}

float noise(vec2 uv) {
    vec2 uv_index = floor(uv);
    vec2 uv_fract = fract(uv);

    vec2 blur = smoothstep(0.0, 1.0, uv_fract);

    return mix( mix( dot( random(uv_index + vec2(0.0,0.0) ), uv_fract - vec2(0.0,0.0) ),
                     dot( random(uv_index + vec2(1.0,0.0) ), uv_fract - vec2(1.0,0.0) ), blur.x),
                mix( dot( random(uv_index + vec2(0.0,1.0) ), uv_fract - vec2(0.0,1.0) ),
                     dot( random(uv_index + vec2(1.0,1.0) ), uv_fract - vec2(1.0,1.0) ), blur.x), blur.y) + 0.5;
}

void vertex() {
	vec2 noise_offset = vec2(noise(VERTEX + cos(TIME)), noise(VERTEX + sin(TIME)));
	noise_offset.y = mix(-1.0, 2.0, noise_offset.y) * wave_strength;
	noise_offset.x = mix(-1.0, 2.0, noise_offset.x) * wave_strength;
	VERTEX = VERTEX - noise_offset;
}

void fragment() {
	COLOR = mix(top_color, bottom_color, distance(FRAGCOORD.y / 300.0, 0));
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
