extends AnimatedSprite

func _ready():
	var _err = connect("animation_finished", self, "on_animation_finished")


func on_animation_finished():
	queue_free()
