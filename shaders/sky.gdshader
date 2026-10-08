shader_type canvas_item;

uniform float wind_speed = 16.0;
uniform vec4 down_color: source_color = vec4(1);
uniform vec4 up_color: source_color = vec4(1);
uniform vec4 cloud_color: source_color = vec4(1);

vec2 random(vec2 uv){
    uv = vec2( dot(uv, vec2(127.1,311.7) ),
               dot(uv, vec2(269.5,183.3) ) );
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
	// Called for every vertex the material is visible on.
}

void fragment() {
	float perspective_scale = mix(8.0, 64.0, UV.y);
	vec2 off_uv = UV / vec2(1, 0.0625);
	float noise = noise(perspective_scale * off_uv + ((TIME * wind_speed) / 16.0));
	
	COLOR = mix(down_color, up_color, UV.y);
	
	if (UV.y < 0.0625) {
		if (noise > 0.7) {
			COLOR = cloud_color;
		} else if (noise > 0.69) {
			COLOR = mix(cloud_color, COLOR, 0.5);
		} else {
			COLOR = COLOR;
		}
	} else {
		COLOR = COLOR;
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
