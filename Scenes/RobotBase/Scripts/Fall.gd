extends PlayerStateBase

### FALL STATE ###

var character_node : KinematicBody2D

func update(_host, _delta):
	if character_node.is_on_floor():
		return "Idle"