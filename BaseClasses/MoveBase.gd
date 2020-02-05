extends PlayerStateBase

class_name MoveBase

### MOVE STATE ###

signal layer_change

var character_node : KinematicBody2D
var layer_change_node : Node
var attributes_node : Node
var SFX_node : Node
var inputs_node : Node


func setup():
	var _err = connect("layer_change", layer_change_node, "on_layer_change")

func update(_host, _delta):
	if !character_node.is_on_floor():
		return "Fall"
	elif attributes_node.velocity.x == 0:
		return "Idle"


func enter_state(_host):
	if !character_node.is_on_floor():
		state_node.set_state("Jump")
		
	animation_node.play(self.name)
	SFX_node.play_SFX("MoveDust", true)


func exit_state(_host):
	SFX_node.play_SFX("MoveDust", false)


# Define the actions the player can do in this state
func _input(event):
	if state_node.get_current_state() == self:
		if event.is_action_pressed(inputs_node.input_map["Jump"]):
			SFX_node.play_SFX("JumpDust", true)
			state_node.set_state("Jump")
		
		elif event.is_action_pressed(inputs_node.input_map["Teleport"]):
			emit_signal("layer_change")
		
		elif event.is_action_pressed(inputs_node.input_map["Action"]):
			state_node.set_state("Action")
		
		elif event.is_action_pressed(inputs_node.input_map["MoveLeft"]) or event.is_action_pressed(inputs_node.input_map["MoveRight"]):
			state_node.set_state("Move")

