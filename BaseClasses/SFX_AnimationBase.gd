extends AnimatedSprite

class_name SFX_AnimationBase

func _ready():
	var _err = connect("animation_finished", self, "on_animation_finished")

func play_animation():
	set_visible(true)
	play("default")

func on_animation_finished():
	set_visible(false)
	set_frame(0)