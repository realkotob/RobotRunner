extends PlayerStateBase

### JUMP STATE ###

var character_node : KinematicBody2D
var attributes_node : Node
var state_node : Node

func update(_host, _delta):
	if character_node.is_on_floor():
		return "Idle"
	elif attributes_node.velocity.y > 0:
		return "Fall"


func enter_state(_host):
	animation_node.play(self.name)
	attributes_node.velocity.y = attributes_node.jump_force


func on_ActionPressed():
	state_node.set_state("Action")