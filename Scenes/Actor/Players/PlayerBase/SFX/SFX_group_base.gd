extends Node2D
class_name SFX_group_base

onready var SFX_nodes_array = get_children()

# Setup children
func setup():
	for SFX_node in SFX_nodes_array:
		if SFX_node.has_method("setup"):
			SFX_node.setup()


# Get the direction from the direction node
func _process(_delta):
	for SFX_node in SFX_nodes_array:
		if SFX_node.has_method("set_fx_direction"):
			SFX_node.set_fx_direction(owner.get_direction())


# When called with a String, search for a child node with this name and call his method that play/stop the SFX
func play_SFX(SFX_name: String, value: bool, global_pos := Vector2.ZERO):
	var SFX_node = get_node_or_null(SFX_name)
	if SFX_node != null:
		if SFX_node.has_method("set_play"):
			SFX_node.set_play(value, global_pos)


# Reset to zero the given SFX
func reset_SFX(SFX_name: String):
	var SFX_node = get_node_or_null(SFX_name)
	if SFX_node != null:
		if SFX_node.has_method("reset_every_SFX"):
			SFX_node.reset_every_SFX()
