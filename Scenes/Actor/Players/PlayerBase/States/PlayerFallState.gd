extends ActorStateBase
class_name PlayerFallState

### FALL STATE ###

onready var tolerance_timer_node = $ToleranceTimer
onready var jump_buffer_timer_node = $JumpBufferTimer

var inputs_node : Node

var jump_tolerance : bool = false
var jump_buffered : bool = false

func _ready():
	yield(owner, "ready")
	
	inputs_node = owner.get_node("Inputs")
	
	var _err = animated_sprite.connect("animation_finished", self, "on_animation_finished")
	_err = tolerance_timer_node.connect("timeout", self, "on_tolerence_timeout")
	_err = jump_buffer_timer_node.connect("timeout", self, "on_jump_buffer_timeout")


func update(_delta):
	if owner.is_on_floor():
		if jump_buffered:
			return "Jump"
		else:
			return "Idle"


# Start the cool down at the entery of the state
func enter_state():
	owner.current_snap = Vector2.ZERO
	var previous_state : String = states_machine.previous_state.name
	
	# Start the time during which the jump is tolerated
	if previous_state == "Move" || previous_state == "Idle":
		tolerance_timer_node.start()
		jump_tolerance = true
	
	# Triggers the StartFalling animation if it exists
	if "StartFalling" in animated_sprite.get_sprite_frames().get_animation_names():
		animated_sprite.play("StartFalling")
	else:
		animated_sprite.play(self.name)


# Reset the jump tolerance and jump buffered bools to ensure no unwanted behaviours
func _exit_state():
	jump_tolerance = false
	jump_buffered = false


# Define the actions the player can do in this state
func _input(event):
	
	if !owner.active:
		return
	
	if event is InputEventKey:
		if states_machine.get_state() == self:
			if event.is_action_pressed(inputs_node.get_input("Action")):
				states_machine.set_state("Action")
				
			elif event.is_action_pressed(inputs_node.get_input("Teleport")):
				owner.emit_signal("layer_change")
			
			# The jump is tolerated only if the jump tolerence timer is still running
			if event.is_action_pressed(inputs_node.get_input("Jump")):
				if jump_tolerance == true:
					states_machine.set_state("Jump")
				else:
					jump_buffer_timer_node.start()
					jump_buffered = true


# Triggers the fall animation when the start falling is over
func on_animation_finished():
	if states_machine.get_state() == self:
		if animated_sprite.get_animation() == "StartFalling":
				animated_sprite.play(self.name)


# When the tolerence time is finished, reset the jump_tolerance to false
func on_tolerence_timeout():
	jump_tolerance = false


# When the jump buffer time is finished, reset the jump_buffer to false
func on_jump_buffer_timeout():
	jump_buffered = false
