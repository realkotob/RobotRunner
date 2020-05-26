extends Node

class_name StatesMachine

# Define the list of possible states, and give the path to the corresponding node for each state
# The states are distinguished by the name of their corresponding node
# The default state is always the first in the tree

signal state_change

export var default_state : String = ""

onready var states_map = get_children()

onready var current_state : Object
onready var previous_state : Object

var state_name
var new_state_name

func _ready():
	yield(owner, "ready")
	if states_map != []:
		if default_state != "":
			set_state(default_state)
		else:
			set_state(states_map[0])


# Call for the current state process
func _physics_process(delta):
	new_state_name = current_state.update(self, delta)
	if new_state_name:
		set_state(get_node(new_state_name))


# Set a new state. The State can be either of type Node, or in type string, in that case, enter the Node name of your state
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
	
	# Use the enter_state function of the current state
	if new_state != null:
		current_state.enter_state(self)
	
	emit_signal("state_change")


# Returns the String name of the current state
func get_state_name() -> String:
	return state_name


# Returns the current state
func get_current_state() -> Object:
	return current_state

