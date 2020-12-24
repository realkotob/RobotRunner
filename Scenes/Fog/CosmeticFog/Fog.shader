shader_type canvas_item;

uniform sampler2D noise1;
uniform sampler2D noise2;

uniform vec4 fog_color : hint_color = vec4(0.7, 0.0, 0.5, 1);
uniform float speed_multiplier = 0.5;
uniform float opacity = 0.5;


// Main rendering method 
void fragment() {
	vec2 coord = UV;
	float current_noise_level = texture(noise1, coord + TIME * speed_multiplier).r;
	vec2 motion = vec2(current_noise_level);
	
	float surface = (UV.x + motion.x);
	float final = texture(noise2, coord + motion).r / 2.0;
	
	COLOR = vec4(vec3(fog_color.r, fog_color.g, fog_color.b), final * opacity);
}