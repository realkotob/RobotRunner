extends StateBase

#### ZOOM CAMERA STATE ####

# This state is called when we need to zoom/dezoom the camera
# It will zoom/dezoom progressivly using linear interporlation
# When the transition is finished, the state change back to the previous state

var destination_zoom := Vector2.ONE

# Progressively zoom/dezoom, until it reachs the desired zoom
func update(host, _delta):
	if owner.get_zoom() == destination_zoom:
		return host.previous_state
	else:
		owner.zoom = owner.zoom.linear_interpolate(destination_zoom, 0.03)


# Reset the zoom destination to normal when leaving the state
func exit_state(_host):
	destination_zoom = Vector2.ONE
