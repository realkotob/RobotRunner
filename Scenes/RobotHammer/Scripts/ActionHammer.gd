extends PlayerStateBase

onready var hit_box = get_node("../../Area2D/CollisionShape2D")

func enter_state(_host):
	hit_box.set_disabled(false)

func exit_state(_host):
	hit_box.set_disabled(true)
	
func update(_host, _delta):
	return "Idle"
