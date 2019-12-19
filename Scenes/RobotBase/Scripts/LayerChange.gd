extends Node

var character_node : Node
var teleport_node : Area2D = null


# If the player is on a teleport point and enter layer change, teleport him to the assigned teleport destiation
# If argument up is true, teleport him the layer upward, if false, teleport him downward
func on_layer_change(up : bool):
	if teleport_node != null:
		teleport_node.teleport_layer(character_node, up)