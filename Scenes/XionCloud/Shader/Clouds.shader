shader_type canvas_item;

uniform sampler2D noiseTexture;

uniform vec2 direction = vec2(-1.0, -1.0);

uniform float speed : hint_range(0.0, 1.0) = 0.1;
uniform float threshold : hint_range(0.0, 2.0) = 0.1;
uniform float fluffiness : hint_range(0.0, 2.0) = 0.1;
uniform float opacity : hint_range(0.0, 1.0) = 1.0;

uniform float fade_distance = 0.2;

uniform vec2 offset = vec2(0.0, 0.0);

uniform vec4 cloud_color : hint_color = vec4(1.0, 1.0, 1.0, 1.0);

// Handle the limit of the fog
vec4 clamp_cloud(vec2 uv, vec4 color, vec4 noise){
	
	if(uv.x < fade_distance || uv.x > 1.0 - fade_distance || 
	   uv.y < fade_distance || uv.y > 1.0 - fade_distance)
	{
		float dist_to_horizontal = min(uv.x, 1.0 - uv.x);
		float dist_to_vertical = min(uv.y, 1.0 - uv.y);
		float min_dist = min(dist_to_horizontal, dist_to_vertical) * 5.0;
		
		if (noise.r < threshold + (1.0 - min_dist)){
			color.a = 0.0;
		}
		//color.a = color.a * clamp(min_dist, 0.0, 1.0);
	}
	return color;
}


void fragment() {
	// Mixing two time-shifted textures to create fluffiness
	vec4 noise1 = texture(noiseTexture, mod(UV + offset + TIME * 2.5 * speed * -direction / 10.0, 0.0));
	vec4 noise2 = texture(noiseTexture, mod(UV + offset + TIME * (2.5 + fluffiness * 3.0) * speed * -direction / 10.0, 0.0));
	vec4 combinedNoise = (noise1 + noise2) / 2.0;
	
	// In case of 
	if (combinedNoise.r < threshold) {
		COLOR.a = 0.0;
	}
	else { 
		COLOR = mix(cloud_color, combinedNoise, 0.5);
		COLOR.a = combinedNoise.r;
	}
	
	COLOR = clamp_cloud(UV, COLOR, combinedNoise);
}