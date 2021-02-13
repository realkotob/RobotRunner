extends ActorStateBase
class_name ActorIdleState

#### IDLE STATE ####

func enter_state():
	if owner.is_path_empty():
		.enter_state()
		owner.set_direction(0)
	else:
		owner.set_state("Move")
