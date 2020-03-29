shader_type canvas_item;

uniform vec4 fog_color : hint_color = vec4(0.7, 0.0, 0.5, 1);
uniform vec2 distort_speed = vec2(-0.03, 0.03);
uniform float speed_multiplier = 0.5;
uniform float opacity = 0.5;
uniform int OCTAVES = 4;
uniform vec2 offset = vec2(50, 0);
uniform float fade_distance = 0.3;

float rand(vec2 coord){
	return fract(sin(dot(coord, vec2(56, 78)) * 1000.0) * 1000.0);
}

// Returns a noise texture
float noise(vec2 coord){
	vec2 i = floor(coord);
	vec2 f = fract(coord);
	
	// 4 corners of a rectangle surrounding our point
	float a = rand(i);
	float b = rand(i + vec2(1.0, 0.0));
	float c = rand(i + vec2(0.0, 1.0));
	float d = rand(i + vec2(1.0, 1.0));
	
	vec2 cubic = f * f * (3.0 - 2.0 * f);
	
	return mix(a, b, cubic.x) + (c - a) * cubic.y * (1.0 - cubic.x) + (d - b) * cubic.x * cubic.y;
}


float fbm(vec2 coord){
	float value = 0.1;
	float scale = 0.5;
	
	for(int i = 0; i< OCTAVES; i++){
		value += noise(coord) * scale;
		coord *= 2.0;
		scale *= 0.5;
	}
	
	return value;
}

void fragment() {
	vec2 coord = UV * 20.0;
	vec2 motion = vec2(fbm(coord + TIME * speed_multiplier)) + offset;
	
	float fog = fbm(coord + motion);
	
	vec4 color = vec4(vec3(fog_color.r, fog_color.g, fog_color.b), fog * opacity);
	
	// Handle the limit of the fog
	vec2 near_top = vec2(UV.x + fog, UV.y + fog) / 2.8;
	near_top = clamp(near_top, 0.0, 1.0);
	
	float edge_lower = 0.8;
	float edge_upper = edge_lower + fade_distance;
	
	if(near_top.x > edge_lower || near_top.x < 1.1 - edge_lower || near_top.y > edge_lower || near_top.y < 1.1 - edge_lower){
		color.a = 0.0;
	}
	
	COLOR = color;
}