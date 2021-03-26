extends RobotJumpState
class_name PlayerJumpState

var inputs_node : Node

#### BUILT-IN ####

func _ready() -> void:
	yield(owner, "ready")
	inputs_node = owner.get_node_or_null("Inputs")



#### INPUTS ####

# Define the actions the player can do in this state
func _input(event):
	if !owner.active:
		return
	
	if states_machine.get_state() == self:
		if event.is_action_pressed(inputs_node.get_input("Action")):
			states_machine.set_state("Action")
			
		elif event.is_action_pressed(inputs_node.get_input("Teleport")):
			owner.emit_signal("layer_change")
