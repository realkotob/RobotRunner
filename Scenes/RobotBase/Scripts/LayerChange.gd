extends Node


var position_y_array = [30, 228, 420]
export var layer : int
onready var character_node = get_parent()
#var teleport_node : Area2D = null

func on_LayerUpPressed():
	layer += 1
	if layer > 2:
		layer = 0
	character_node.position.y = position_y_array[layer]
	
func on_LayerDownPressed():
	layer -= 1
	if layer < 0:
		layer = 2
	character_node.position.y = position_y_array[layer]

# If the player is on a teleport point and enter layer change, teleport him to the assigned teleport destiation
func on_layer_change(_up : bool):
#	if teleport_node != null:
#		if up == true:
#			teleport_node.teleport_layer_up(character_node)
#		else:
#			teleport_node.teleport_layer_down(character_node)
	pass