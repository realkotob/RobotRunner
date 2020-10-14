extends ActorStateBase

#### IDLE STATE ####

func enter_state(host):	
	if owner.is_path_empty():
		.enter_state(host)
		owner.set_direction(0)
	else:
		owner.set_state("Move")
