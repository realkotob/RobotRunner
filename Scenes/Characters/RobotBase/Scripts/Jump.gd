extends PlayerStateBase

### JUMP STATE ###

var character_node : KinematicBody2D
var attributes_node : Node
var SFX_node : Node
var inputs_node : Node

func update(_host, _delta):
	if character_node.is_on_floor():
		return "Idle"
	elif attributes_node.velocity.y > 0:
		return "Fall"

func enter_state(_host):
	animation_node.play(self.name)
	
	# Genreate the jump dust
	SFX_node.play_SFX("JumpDust", true, character_node.global_position)
	
	# Apply the jump force
	attributes_node.velocity.y = attributes_node.jump_force


func exit_state(_host):
	SFX_node.play_SFX("JumpDust", false)
	SFX_node.reset_SFX("JumpDust")


# Define the actions the player can do in this state
func _input(event):
	if state_node.get_current_state() == self:
		if event.is_action_pressed(inputs_node.input_map["Action"]):
			state_node.set_state("Action")
