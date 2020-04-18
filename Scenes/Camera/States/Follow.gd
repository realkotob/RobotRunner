extends StateBase

#### FOLLOW CAMERA STATE ####

# This state is used to follow the players
# It computes the average position of all the players, and move the camera towards it
# Progressivly, so the camera feels smooth


func update(_host, delta):
	# Compute the camera speed
	var reel_camera_speed = clamp(owner.camera_speed * delta, 0.0, 1.0)

	var players_array = get_tree().get_nodes_in_group("Players")

	# Move the camera speed towards the average postion
	# With a horiziontal/vertical restriction
	if len(players_array) > 1:

		var average_pos : Vector2 = owner.compute_average_pos(players_array)

		# If instant is true, go all the way to the desired position
		owner.global_position = owner.global_position.linear_interpolate(average_pos, reel_camera_speed)
		
		
		# Zoom/Dezoom if necesary
		var screen_width = get_viewport().get_size().y / 2
		var max_dist = screen_width * 0.9
		var players_vertical_distance = abs(players_array[0].global_position.y - players_array[1].global_position.y)
		var dest_zoom := Vector2.ONE
		
		if players_vertical_distance > max_dist:
			var distance_ratio = (players_vertical_distance / (screen_width * 0.85))
			dest_zoom = Vector2(distance_ratio, distance_ratio)
		
		if owner.zoom != dest_zoom:
			owner.zoom_to(dest_zoom)
