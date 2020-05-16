extends SFX_AnimationBase
class_name SFX_Explosion

export var shake_magnitude : float = 4.0
export var shake_duration : float = 0.3

func play_animation():
	var camera_node = get_tree().get_current_scene().find_node("Camera")
	if camera_node != null:
		camera_node.shake(4.0, 0.3)
	set_visible(true)
	play()
