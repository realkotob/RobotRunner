extends PlayerStateBase

signal layer_change

### IDLE STATE ###

var layer_change_node : Node
var character_node : KinematicBody2D
var state_node : Node

onready var fall_timer_node = get_node("FallTimer")
var fall_timer_init_value : float


# Setup method
func setup():
	var _err
	_err = connect("layer_change", layer_change_node, "on_layer_change")
	_err = fall_timer_node.connect("timeout", self, "on_fall_timer_timeout")
	fall_timer_init_value = fall_timer_node.get_wait_time()


# Check if the character is falling, with a small cooldown, before it triggers fall state
func update(_host, _delta):
	if !character_node.is_on_floor() && fall_timer_node.is_stopped():
		fall_timer_node.start()


# Triggers the Idle aniamtion when entering the state
func enter_state(_host):
	animation_node.play(self.name)


# Reset the falling timer cooldown, and stop it
func exit_state(_host):
	fall_timer_node.stop()
	fall_timer_node.set_wait_time(fall_timer_init_value)


func on_JumpPressed():
	state_node.set_state("Jump")


func on_LayerUpPressed():
	emit_signal("layer_change", true)


func on_LayerDownPressed():
	emit_signal("layer_change", false)


func on_ActionPressed():
	state_node.set_state("Action")


func on_LeftPressed():
	state_node.set_state("Move")


func on_RightPressed():
	state_node.set_state("Move")


# If the fall cooldown is over: change the state to False
func on_fall_timer_timeout():
	state_node.set_state("Fall")
