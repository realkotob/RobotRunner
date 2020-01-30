extends Node

var character_node : Node
var teleport_node : Area2D = null

onready var audio_node = get_node("AudioStreamPlayer")

# If the player is on a teleport point and enter layer change, teleport him to the assigned teleport destiation
func on_layer_change():
	if teleport_node != null:
		teleport_node.teleport_layer(character_node)
		audio_node.play()