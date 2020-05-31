extends StatesMachine

# Define the list of possible states, and give the path to the corresponding node for each state
# The states are distinguished by the name of their corresponding node
# The default state is always the first in the tree

var inputs_node : Node 
var action_hitbox_node : Node
var animation_node : AnimatedSprite
var SFX_node : Node

var previous_anim_node
var curent_anim_node

func _ready():
	set_physics_process(false)


func setup():
	# Give the needed references to the children
	for state in states_map:
		if "inputs_node" in state:
			state.inputs_node = inputs_node
		
		if "action_hitbox_node" in state:
			state.action_hitbox_node = action_hitbox_node
		
		if "SFX_node" in state:
			state.SFX_node = SFX_node
		
		if state.has_method("setup"):
			state.setup()
	
	set_physics_process(true)
	set_state(states_map[0])
