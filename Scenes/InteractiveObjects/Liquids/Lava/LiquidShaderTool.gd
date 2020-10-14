extends Sprite
tool 

#### ACCESSORS ####



#### BUILT-IN ####



#### LOGIC ####

func _process(_delta):
	var shader = get_material()
	shader.set_shader_param("sprite_scale", scale)

#### VIRTUALS ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
