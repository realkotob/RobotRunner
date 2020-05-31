extends PlayerStateBase

#### SHOCK STATE ####

var physic_node

func enter_state(_host):
	physic_node.set_physics_process(false)


func exit_state(_host):
	physic_node.set_physics_process(true)

