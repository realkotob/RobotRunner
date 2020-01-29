extends AnimatedSprite

func _ready():
	var _err = connect("animation_finished", get_parent(), "on_animation_finished")
