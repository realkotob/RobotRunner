extends Event

export var disabled : bool = false

func event():
	GAME.progression.checkpoint += 1


func set_disabled(value : bool):
	disabled = value
	if disabled:
		for area in triggers_area_array:
			area.get_node("CollisionShape2D").call_deferred("set_disabled", true)
