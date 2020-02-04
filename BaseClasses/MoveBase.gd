extends PlayerStateBase

class_name MoveBase

### MOVE STATE ###

signal layer_change

var state_node : Node
var character_node : KinematicBody2D
var layer_change_node : Node
var attributes_node : Node
var SFX_node : Node

func setup():
	var _err = connect("layer_change", layer_change_node, "on_layer_change")

func update(_host, _delta):
	if !character_node.is_on_floor():
		return "Fall"
	elif attributes_node.velocity.x == 0:
		return "Idle"

func on_JumpPressed():
	state_node.set_state("Jump")


func on_TeleportPressed():
	emit_signal("layer_change")

func on_ActionPressed():
	state_node.set_state("Action")

func enter_state(_host):
	if !character_node.is_on_floor():
		state_node.set_state("Jump")
		
	animation_node.play(self.name)
	SFX_node.play_SFX("MoveDust", true)

func exit_state(_host):
	SFX_node.play_SFX("MoveDust", false)
