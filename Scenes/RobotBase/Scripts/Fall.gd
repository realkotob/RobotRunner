extends PlayerStateBase

### FALL STATE ###

var states_node : Node
var character_node : KinematicBody2D

func update(_host, _delta):
	if character_node.is_on_floor():
		return "Idle"

func on_ActionPressed():
	states_node.set_state("Action")