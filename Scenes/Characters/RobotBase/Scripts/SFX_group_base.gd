extends Node2D

class_name SFX_group_base

onready var SFX_nodes_array = get_children()

var direction_node : Node
var direction : int = 1


func _process(_delta):
	direction = direction_node.get_move_direction()
	for SFX_node in SFX_nodes_array:
		SFX_node.set_fx_direction(direction)

# When called with a String, search for a child node with this name and call his method that play/stop the SFX
func play_SFX(SFX_name: String, value: bool):
	var SFX_node = get_node_or_null(SFX_name)
	if SFX_node != null:
		if SFX_node.has_method("set_play"):
			SFX_node.set_play(value)


func reset_SFX(SFX_name: String):
	var SFX_node = get_node_or_null(SFX_name)
	if SFX_node != null:
		if SFX_node.has_method("reset_every_SFX"):
			SFX_node.reset_every_SFX()
