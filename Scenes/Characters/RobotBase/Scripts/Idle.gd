extends PlayerStateBase

signal layer_change

### IDLE STATE ###

var layer_change_node : Node
var character_node : KinematicBody2D
var state_node : Node


# Setup method
func setup():
	var _err
	_err = connect("layer_change", layer_change_node, "on_layer_change")


# Check if the character is falling, with a small cooldown, before it triggers fall state
func update(_host, _delta):
	if !character_node.is_on_floor():
		return "Fall"


# Triggers the Idle aniamtion when entering the state
func enter_state(_host):
	animation_node.play(self.name)


func on_JumpPressed():
	state_node.set_state("Jump")


func on_TeleportPressed():
	emit_signal("layer_change")


func on_ActionPressed():
	state_node.set_state("Action")


func on_LeftPressed():
	state_node.set_state("Move")


func on_RightPressed():
	state_node.set_state("Move")

