extends ActorActionState
class_name PlayerActionState

var inputs_node : Node

#### BUILT-IN ####

func _ready() -> void:
	yield(owner, "ready")
	
	inputs_node = owner.get_node("Inputs")

#### INPUTS #### 

# Define the actions the player can do in this state
func _input(event):
	
	if !owner.active:
		return
	
	if event is InputEventKey:
		if states_machine.get_state() == self:
			
			if event.is_action_pressed(inputs_node.get_input("MoveLeft")) \
			or event.is_action_pressed(inputs_node.get_input("MoveRight")):
				if owner.is_on_floor():
					states_machine.set_state("Move")
			
			elif event.is_action_pressed(inputs_node.get_input("Jump")):
				if owner.is_on_floor():
					states_machine.set_state("Jump")


#### SIGNAL RESPONSES #### 
