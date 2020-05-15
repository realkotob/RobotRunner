extends Event

class_name CameraEventBase

export var camera_new_zoom := Vector2.ONE
export var camera_new_speed : float = -1.0
export var camera_new_zoom_speed : float = -1.0
export var follow_state : bool = false

func event():
	GAME.zoom_camera_to(camera_new_zoom, camera_new_zoom_speed)
	if follow_state:
		GAME.set_camera_on_follow()
	else:
		GAME.move_camera_to($Position2D.get_global_position(), false, camera_new_speed, INF)
	queue_free()
