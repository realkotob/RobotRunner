extends StateBase

#### FOLLOW CAMERA STATE ####

# This state is used to follow the players
# It computes the average position of all the players, and move the camera towards it
# Progressivly, so the camera feels smooth

func update(_host, _delta):
	var players_array = get_tree().get_nodes_in_group("Players")

	# Move the camera speed towards the average postion
	# With a horiziontal/vertical restriction
	if len(players_array) > 1:

		var average_pos : Vector2 = owner.compute_average_pos(players_array)

		# If instant is true, go all the way to the desired position
		if owner.get_global_position().distance_to(average_pos) > 3.0:
			owner.start_moving(average_pos)
		
		# Zoom/Dezoom if necesary
		var screen_size = get_viewport().get_size() / 2
		var max_dist = Vector2(screen_size.x * 0.7, screen_size.y * 0.7)
		var players_v_distance = abs(players_array[0].global_position.y - players_array[1].global_position.y)
		var players_h_distance = abs(players_array[0].global_position.x - players_array[1].global_position.x)
		var dest_zoom := Vector2.ONE
			
		# Vertical
		if players_v_distance > max_dist.y:
			var distance_ratio = (players_v_distance / max_dist.y)
			distance_ratio = clamp(distance_ratio, 1.0, 2.0)
			dest_zoom = Vector2(distance_ratio, distance_ratio)
			
		# Horizontal
		elif players_h_distance > max_dist.x:
			var distance_ratio = (players_h_distance / max_dist.x)
			distance_ratio = clamp(distance_ratio, 1.0, 2.0)
			dest_zoom = Vector2(distance_ratio, distance_ratio)
			
		if owner.zoom != dest_zoom:
			owner.start_zooming(dest_zoom)
