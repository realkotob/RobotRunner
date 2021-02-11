extends PlayerStateBase

#### SHOCK STATE ####

var physic_node

func enter_state():
	physic_node.set_physics_process(false)


func exit_state():
	physic_node.set_physics_process(true)

