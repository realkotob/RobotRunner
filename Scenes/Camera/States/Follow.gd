extends StateBase

#### FOLLOW CAMERA STATE ####

# This state is used to follow the players
# It computes the average position of all the players, and move the camera towards it
# Progressivly, so the camera feels smooth


var cam_dir : String = ""

func update(_host, delta):
	adapt_camera_position(delta)


# Change the position of the camera according to the position of the players
func adapt_camera_position(delta: float):
	# Compute the camera speed
	var reel_camera_speed = clamp(owner.camera_speed * delta, 0.0, 1.0)

	var players_array = get_tree().get_nodes_in_group("Players")

	# Move the camera speed towards the average postion
	# With a horiziontal/vertical restriction
	if len(players_array) > 0:

		var average_pos : Vector2 = owner.compute_average_pos(players_array)

		# If instant is true, go all the way to the desired position
		if(cam_dir != 'updown'):
			owner.global_position.x = lerp(owner.global_position.x, average_pos.x, reel_camera_speed)
		if(cam_dir != 'leftright'):
			owner.global_position.y = lerp(owner.global_position.y, average_pos.y, reel_camera_speed)
