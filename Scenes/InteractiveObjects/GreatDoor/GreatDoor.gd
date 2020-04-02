extends Door

#### GREAT DOOR CLASS ####

func _ready():
	animation_node.connect("animation_finished", self, "on_animation_finished")


func open_door():
	if animation_node != null:
		animation_node.play("Open")
	
	if collision_node != null:
			collision_node.set_disabled(true)
	
	if audio_node != null:
		audio_node.play()
	
	GAME.move_camera_to(position, true)


func on_animation_finished(anim_name: String):
	if anim_name == "Open":
		GAME.set_camera_on_follow()
