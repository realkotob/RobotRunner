extends StateBase

#### FOLLOW CAMERA STATE ####

# This state is used to follow the players
# It computes the average position of all the players, and move the camera towards it
# Progressivly, so the camera feels smooth
func update(_host, _delta):
	var players_array = owner.get_players_array()
	
	# Move the camera speed towards the average postion
	# With a horiziontal/vertical restriction
	if len(players_array) > 0:
	
		var average_pos : Vector2 = owner.compute_average_pos(players_array)
	
		# If instant is true, go all the way to the desired position
		if owner.get_global_position().distance_to(average_pos) > 3.0:
			owner.start_moving(average_pos)
		
		# Zoom/Dezoom if necesary
		var screen_size = get_viewport().get_size() / 2
		var max_dist = Vector2(screen_size.x * 0.7, screen_size.y * 0.7)
		var players_distance = compute_player_distance(players_array)
		var dest_zoom := Vector2.ONE
			
		# Vertical
		if players_distance.y > max_dist.y:
			var distance_ratio = (players_distance.y / max_dist.y)
			distance_ratio = clamp(distance_ratio, 1.0, 2.0)
			dest_zoom = Vector2(distance_ratio, distance_ratio)
			
		# Horizontal
		elif players_distance.x > max_dist.x:
			var distance_ratio = (players_distance.x / max_dist.x)
			distance_ratio = clamp(distance_ratio, 1.0, 2.0)
			dest_zoom = Vector2(distance_ratio, distance_ratio)
			
		if owner.zoom != dest_zoom:
			owner.start_zooming(dest_zoom)


# Compute the distance between the players
func compute_player_distance(players_array: Array) -> Vector2:
	var distance := Vector2.ZERO
	var nb_players = players_array.size()
	
	if nb_players == 1:
		return Vector2.ZERO
	
	for i in range(nb_players):
		if i == 0:
			distance = players_array[0].get_global_position()
		else:
			distance -= players_array[i].get_global_position()
	return distance
