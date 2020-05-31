extends ActorStateBase

func enter_state(_host):
	owner.set_visible(false)


func exit_state(_host):
	owner.set_visible(true)
