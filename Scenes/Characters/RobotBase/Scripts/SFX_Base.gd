extends Node2D

onready var particules_nodes_array = get_children()

func _ready():
	set_play(false)

# Play the FX in the right direction
func set_fx_direction(direction : int):
	if direction != 0:
		for node in particules_nodes_array:
			node.position.x = -abs(node.position.x) * direction
			node.process_material.direction.x = -abs(node.process_material.direction.x) * direction


# Start/Stop the emition of particules
func set_play(value : bool, _global_pos := Vector2.ZERO):
	for node in particules_nodes_array:
		node.set_emitting(value)


# Reset the texture at frame 0
func reset_every_SFX():
	for node in particules_nodes_array:
		if node.get_texture() != null:
			node.get_texture().set_frame_texture(0, self)
