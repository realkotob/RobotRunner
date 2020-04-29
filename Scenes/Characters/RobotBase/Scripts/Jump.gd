extends PlayerStateBase

signal layer_change

### JUMP STATE ###

var layer_change_node : Node
var SFX_node : Node
var inputs_node : Node

func setup():
	var _err
	_err = connect("layer_change", owner, "on_layer_change")
	_err = animation_node.connect("animation_finished", self, "on_animation_finished")

func update(_host, _delta):
	if owner.is_on_floor():
		return "Idle"
	elif owner.velocity.y > 0:
		return "Fall"

func enter_state(_host):
	animation_node.play(self.name)
	
	# Genreate the jump dust
	SFX_node.play_SFX("JumpDust", true, owner.global_position)
	
	# Apply the jump force
	owner.velocity.y = owner.jump_force


func exit_state(_host):
	SFX_node.play_SFX("JumpDust", false)
	SFX_node.reset_SFX("JumpDust")


func on_animation_finished():
	if state_node.get_current_state() == self:
		if animation_node.get_animation() == "Jump":
			if "MidAir" in animation_node.get_sprite_frames().get_animation_names():
				animation_node.play("MidAir")

# Define the actions the player can do in this state
func _input(event):
	if state_node.get_current_state() == self:
		if event.is_action_pressed(inputs_node.input_map["Action"]):
			state_node.set_state("Action")
			
		elif event.is_action_pressed(inputs_node.input_map["Teleport"]):
			emit_signal("layer_change")
