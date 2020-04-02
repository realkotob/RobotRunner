extends Door

#### GREAT DOOR CLASS ####

func _ready():
	animation_node.connect("animation_finished", self, "on_animation_finished")


func open_door():
	if animation_node != null:
		animation_node.play("Open")
	
	if audio_node != null:
		audio_node.play()


func on_animation_finished(anim_finished):
	if anim_finished == "Open":
		if collision_node != null:
			collision_node.set_disabled(true)
