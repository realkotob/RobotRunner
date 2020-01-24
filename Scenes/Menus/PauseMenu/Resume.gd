extends MenuOptionsBase

onready var parent = get_parent().owner

func options_action():
	if(get_tree().paused):
		parent.visible = false
		get_tree().paused = false