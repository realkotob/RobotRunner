extends ActorStateBase

func enter_state():
	owner.set_visible(false)


func exit_state():
	owner.set_visible(true)
