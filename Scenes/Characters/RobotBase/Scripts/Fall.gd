extends PlayerStateBase

signal layer_change

### FALL STATE ###

onready var tolerence_timer_node = $Timer

var layer_change_node : Node
var inputs_node : Node

var jump_tolerence : bool = false

func setup():
	var _err
	_err = connect("layer_change", owner, "on_layer_change")
	_err = animation_node.connect("animation_finished", self, "on_animation_finished")
	_err = tolerence_timer_node.connect("timeout", self, "on_tolerence_timeout")


func update(_host, _delta):
	if owner.is_on_floor():
		return "Idle"


# Start the cool down at the entery of the state
func enter_state(_host):
	owner.current_snap = Vector2.ZERO
	var previous_state : String = state_node.previous_state.name
	
	# Start the time during which the jump is tolerated
	if previous_state == "Move" || previous_state == "Idle":
		tolerence_timer_node.start()
		jump_tolerence = true
	
	# Triggers the StartFalling animation if it exists
	if "StartFalling" in animation_node.get_sprite_frames().get_animation_names():
		animation_node.play("StartFalling")
	else:
		animation_node.play(self.name)


# Define the actions the player can do in this state
func _input(event):
	if event is InputEventKey:
		if state_node.get_current_state() == self:
			if event.is_action_pressed(inputs_node.input_map["Action"]):
				state_node.set_state("Action")
				
			elif event.is_action_pressed(inputs_node.input_map["Teleport"]):
				emit_signal("layer_change")
			
			# The jump is tolerated only if the jump tolerence timer is still running
			if event.is_action_pressed(inputs_node.input_map["Jump"]):
				if jump_tolerence == true:
					state_node.set_state("Jump")


# Triggers the fall animation when the start falling is over
func on_animation_finished():
	if state_node.get_current_state() == self:
		if animation_node.get_animation() == "StartFalling":
				animation_node.play(self.name)


# When the tolerence time is finished
func on_tolerence_timeout():
	jump_tolerence = false
