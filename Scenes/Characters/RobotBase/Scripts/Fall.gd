extends PlayerStateBase

### FALL STATE ###

var character_node : KinematicBody2D
var inputs_node : Node

onready var fall_timer_node = get_node("FallTimer")
var fall_timer_init_value : float


func setup():
	var _err = fall_timer_node.connect("timeout", self, "on_fall_timer_timeout")
	fall_timer_init_value = fall_timer_node.get_wait_time()


func update(_host, _delta):
	if character_node.is_on_floor():
		return "Idle"


# Start the cool down at the entery of the state
func enter_state(host):
	if host.previous_state.name != "Action":
		fall_timer_node.start()
	else:
		animation_node.play(self.name)


# Reset the falling timer cooldown, and stop it
func exit_state(_host):
	fall_timer_node.stop()
	fall_timer_node.set_wait_time(fall_timer_init_value)


func _input(event):
	if state_node.get_current_state() == self:
		if event.is_action_pressed(inputs_node.input_map["Action"]):
			state_node.set_state("Action")


# When the cooldown is over; play the animation
func on_fall_timer_timeout():
	animation_node.play(self.name)
