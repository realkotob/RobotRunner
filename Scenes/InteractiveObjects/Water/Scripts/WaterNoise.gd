tool
extends Sprite

func calculate_aspect_ratio():
	material.set_shader_param("sprite_scale", scale)
