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
	attributes_node.velocity.y = attributes_node.jump_force
	SFX_node.play_SFX("JumpDust", true)
	state_node.set_state("Jump")

func exit_state(_host):
	SFX_node.play_SFX("JumpDust", false)
	SFX_node.reset_SFX("JumpDust")


func _input(event):
	if state_node.get_current_state() == self:
		if event.is_action_pressed(inputs_node.input_map["Action"]):
			state_node.set_state("Action")
