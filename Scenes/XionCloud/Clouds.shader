shader_type canvas_item;

uniform sampler2D noiseTexture;

uniform vec2 direction = vec2(-1.0, -1.0);

uniform float speed : hint_range(0.0, 1.0) = 0.1;
uniform float first_threshold : hint_range(0.0, 2.0) = 0.1;
uniform float second_threshold : hint_range(0.0, 2.0) = 0.2;
uniform float fluffiness : hint_range(0.0, 2.0) = 0.1;
uniform float opacity : hint_range(0.0, 1.0) = 1.0;

uniform vec2 offset = vec2(0.0, 0.0);

uniform vec4 first_color : hint_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 second_color : hint_color = vec4(1.0, 1.0, 1.0, 1.0);

void fragment() {
	// Mixing two time-shifted textures to create fluffiness
	vec4 noise1 = texture(noiseTexture, mod(UV + offset + TIME * 2.5 * speed * -direction / 10.0, 0.0));
	vec4 noise2 = texture(noiseTexture, mod(UV + offset + TIME * (2.5 + fluffiness * 3.0) * speed * -direction / 10.0, 0.0));
	vec4 combinedNoise = (noise1 + noise2) / 2.0;
	
	
	// In case of 
	if (combinedNoise.r < first_threshold) {
		COLOR.a = 0.0;
	}
	else {
		if (combinedNoise.r < second_threshold){
			COLOR = first_color;
		} else {
			COLOR = second_color;
		}
		COLOR.a = combinedNoise.r;
	}
}
