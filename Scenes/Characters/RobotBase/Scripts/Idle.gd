extends PlayerStateBase

signal layer_change

### IDLE STATE ###

var layer_change_node : Node
var character_node : KinematicBody2D
var SFX_node : Node
var inputs_node : Node

# Setup method
func setup():
	var _err
	_err = connect("layer_change", layer_change_node, "on_layer_change")


# Check if the character is falling, with a small cooldown, before it triggers fall state
func update(_host, _delta):
	if !character_node.is_on_floor():
		return "Fall"
	
	
	# Chage state to move if the player is moving horizontaly
	var horiz_movement = character_node.get_node("Attributes").get_velocity().x
	if abs(horiz_movement) > 0.0 :
		state_node.set_state("Move")


# Triggers the Idle aniamtion when entering the state
func enter_state(_host):
	animation_node.play(self.name)


# Define the actions the player can do in this state
func _input(event):
	if state_node.get_current_state() == self:
		if event.is_action_pressed(inputs_node.input_map["Jump"]):
			state_node.set_state("Jump")
		
		elif event.is_action_pressed(inputs_node.input_map["Teleport"]):
			emit_signal("layer_change")
		
		elif event.is_action_pressed(inputs_node.input_map["Action"]):
			state_node.set_state("Action")

