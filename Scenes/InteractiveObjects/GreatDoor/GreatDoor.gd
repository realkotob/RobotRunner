extends Door

#### GREAT DOOR CLASS ####

# When set to true (default), the camera will move until it reach the position of the door
# When set to false, the camera will make an average between the average players position
# And the door position, and move to it

onready var area_node = $Area2D

export var focus_on_door : bool = true
export var short_focus : bool = false

signal player_exit_level

func _ready():
	var _err = animation_node.connect("animation_finished", self, "on_animation_finished")
	_err = area_node.connect("body_entered", self, "on_area_body_entered")
	_err = connect("player_exit_level", GAME, "on_player_level_exited")


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


# Triggered when the door starts opening
# Reset the camera on follow if the exported short_focus booleen is true
func on_focus_finished():
	if short_focus == true:
		GAME.set_camera_on_follow()


# Reset the camera on follow state when the animation is over
func on_animation_finished(anim_name: String):
	if anim_name == "Open":
		GAME.set_camera_on_follow()


# Notify the game autoload that a player exited the level 
func on_area_body_entered(body : PhysicsBody2D):
	if body != null:
		if body.is_class("Player"):
			emit_signal("player_exit_level", body)
			body.queue_free()
