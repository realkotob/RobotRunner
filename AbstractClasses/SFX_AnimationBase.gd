extends AnimatedSprite

class_name SFX_AnimationBase

export var shake_magnitude : float = 4.0
export var shake_duration : float = 0.3

func _ready():
	var _err = connect("animation_finished", self, "on_animation_finished")
	play_animation()


func play_animation():
	var camera_node = get_tree().get_current_scene().find_node("Camera")
	if camera_node != null:
		camera_node.shake(4.0, 0.3)
	set_visible(true)
	play()


func on_animation_finished():
	queue_free()
