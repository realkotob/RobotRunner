extends Node

class_name StatesMachine

# Define the list of possible states, and give the path to the corresponding node for each state
# The states are distinguished by the name of their corresponding node
# The default state is always the first in the tree

var inputs_node : Node 
var attributes_node : Node 
var character_node : KinematicBody2D
var layer_change_node : Node
var hit_box_node : Node
var animation_node : AnimatedSprite
var direction_node

onready var states_map = get_children()

onready var current_state : Object
onready var previous_state : Object

onready var idle_node = get_node("Idle")
onready var move_node = get_node("Move")
onready var jump_node = get_node("Jump")
onready var fall_node = get_node("Fall")
onready var action_node = get_node("Action")

var previous_anim_node
var curent_anim_node

var state_name

func setup():
	setup_idle_node()
	setup_move_node()
	setup_jump_node()
	setup_fall_node()
	setup_action_node()

	state_name = states_map[0].name
	set_state(get_node(state_name))

# Call for the current state process
func _physics_process(delta):
	var new_state_name = current_state.update(self, delta)
	if new_state_name:
		set_state(get_node(new_state_name))

# Set a new state
func set_state(new_state):
	
	# If the argument provided is of type string, convert it into a state in the state map
	if new_state is String:
		new_state = get_node(new_state)
	
	# Discard the method if the new_state is the current_state
	if new_state == current_state:
		return
	
	# Use the exit state function of the current state
	if current_state != null:
		current_state.exit_state(self)
	
	# Change the current state, and the previous state
	previous_state = current_state
	current_state = new_state
	state_name = current_state.name
	
	
	# Connect/Disconnect input signals
	connect_inputs_current_state()
	disconnect_inputs_previous_state()
	
	# Use the enter_state function of the current state
	if new_state != null:
		current_state.enter_state(self)

# Connect the input signals to the current state
func connect_inputs_current_state():
	if current_state != null && inputs_node != null:
		var _err
		_err = inputs_node.connect("JumpPressed", current_state, "on_JumpPressed")
		_err = inputs_node.connect("JumpReleased", current_state, "on_JumpReleased")
		_err = inputs_node.connect("ActionPressed", current_state, "on_ActionPressed")
		_err = inputs_node.connect("ActionReleased", current_state, "on_ActionReleased")
		_err = inputs_node.connect("UpPressed", current_state, "on_UpPressed")
		_err = inputs_node.connect("UpReleased", current_state, "on_UpReleased")
		_err = inputs_node.connect("DownPressed", current_state, "on_DownPressed")
		_err = inputs_node.connect("DownReleased", current_state, "on_DownReleased")
		_err = inputs_node.connect("LeftPressed", current_state, "on_LeftPressed")
		_err = inputs_node.connect("LeftReleased", current_state, "on_LeftReleased")
		_err = inputs_node.connect("RightPressed", current_state, "on_RightPressed")
		_err = inputs_node.connect("RightReleased", current_state, "on_RightReleased")
		_err = inputs_node.connect("LayerUpPressed", current_state, "on_LayerUpPressed")
		_err = inputs_node.connect("LayerUpReleased", current_state, "on_LayerUpReleased")
		_err = inputs_node.connect("LayerDownPressed", current_state, "on_LayerDownPressed")
		_err = inputs_node.connect("LayerDownReleased", current_state, "on_LayerDownReleased")

# Disconnect the input signals to the current state
func disconnect_inputs_previous_state():
	if previous_state != null && inputs_node != null:
		inputs_node.disconnect("JumpPressed", previous_state, "on_JumpPressed")
		inputs_node.disconnect("JumpReleased", previous_state, "on_JumpReleased")
		inputs_node.disconnect("ActionPressed", previous_state, "on_ActionPressed")
		inputs_node.disconnect("ActionReleased", previous_state, "on_ActionReleased")
		inputs_node.disconnect("UpPressed", previous_state, "on_UpPressed")
		inputs_node.disconnect("UpReleased", previous_state, "on_UpReleased")
		inputs_node.disconnect("DownPressed", previous_state, "on_DownPressed")
		inputs_node.disconnect("DownReleased", previous_state, "on_DownReleased")
		inputs_node.disconnect("LeftPressed", previous_state, "on_LeftPressed")
		inputs_node.disconnect("LeftReleased", previous_state, "on_LeftReleased")
		inputs_node.disconnect("RightPressed", previous_state, "on_RightPressed")
		inputs_node.disconnect("RightReleased", previous_state, "on_RightReleased")
		inputs_node.disconnect("LayerUpPressed", previous_state, "on_LayerUpPressed")
		inputs_node.disconnect("LayerUpReleased", previous_state, "on_LayerUpReleased")
		inputs_node.disconnect("LayerDownPressed", previous_state, "on_LayerDownPressed")
		inputs_node.disconnect("LayerDownReleased", previous_state, "on_LayerDownReleased")

func get_state_name():
	return state_name

# Flip the animation of the character, based on his direction
func flip_animation():
	if attributes_node.velocity.x < 0:
		curent_anim_node.set_flip_h(true)
		previous_anim_node.set_flip_h(true)
	elif attributes_node.velocity.x > 0:
		curent_anim_node.set_flip_h(false)
		previous_anim_node.set_flip_h(false)


func setup_idle_node():
	idle_node.character_node = character_node
	idle_node.states_node = self
	idle_node.layer_change_node = layer_change_node
	idle_node.animation_node = animation_node
	idle_node.setup()


func setup_move_node():
	move_node.character_node = character_node
	move_node.states_node = self
	move_node.layer_change_node = layer_change_node
	move_node.attributes_node = attributes_node
	move_node.animation_node = animation_node
	move_node.setup()


func setup_jump_node():
	jump_node.character_node = character_node
	jump_node.states_node = self
	jump_node.attributes_node = attributes_node
	jump_node.animation_node = animation_node


func setup_fall_node():
	fall_node.character_node = character_node
	fall_node.animation_node = animation_node
	fall_node.states_node = self


func setup_action_node():
	action_node.hit_box_node = hit_box_node
	action_node.state_node = self
	action_node.animation_node = animation_node
	action_node.direction_node = direction_node
	action_node.setup()