extends PlayerStateBase

### FALL STATE ###

onready var character_node = get_parent().get_parent()

func update(_host, _delta):
	if character_node.is_on_floor():
		return "Idle"