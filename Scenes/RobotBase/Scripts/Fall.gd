extends PlayerStateBase

### FALL STATE ###

var state_node : Node
var character_node : KinematicBody2D

func update(_host, _delta):
	if character_node.is_on_floor():
		return "Idle"

func on_ActionPressed():
	state_node.set_state("Action")