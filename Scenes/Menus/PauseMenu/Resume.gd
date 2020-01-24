extends MenuOptionsBase

onready var parent = get_parent().owner

func options_action():
	parent.visible = false
	get_tree().paused = false