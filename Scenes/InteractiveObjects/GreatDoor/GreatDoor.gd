extends Door

#### GREAT DOOR CLASS ####

# When set to true (default), the camera will move until it reach the position of the door
# When set to false, the camera will make an average between the average players position
# And the door position, and move to it
export var focus_on_door : bool = true

func _ready():
	animation_node.connect("animation_finished", self, "on_animation_finished")


# Triggers the opening of the door
func open_door():
	if animation_node != null:
		animation_node.play("Open")
	
	if collision_node != null:
			collision_node.set_disabled(true)
	
	if audio_node != null:
		audio_node.play()
	
	# Triggers the camera movement
	GAME.move_camera_to(position, !focus_on_door)


# Reset the camera on follow state when the animation is over
func on_animation_finished(anim_name: String):
	if anim_name == "Open":
		GAME.set_camera_on_follow()
