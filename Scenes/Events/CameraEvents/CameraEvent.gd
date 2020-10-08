extends Event

class_name CameraEventBase

export var camera_new_zoom := Vector2.ONE
export var camera_new_speed : float = -1.0
export var zoom_duration : float = 3.0
export var follow_state : bool = false

func event():
	if !event_disabled:
		GAME.zoom_camera_to(camera_new_zoom, zoom_duration)
		if follow_state:
			GAME.set_camera_on_follow()
		else:
			GAME.move_camera_to($Position2D.get_global_position(), false, camera_new_speed, INF)
		queue_free()
