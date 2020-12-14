extends StateBase

const ANTICIP_DIST : float = 170.0
const ANTICIP_TRIGGER_RATIO : float = 0.3

var camera : Camera2D
var screen_size : Vector2

#### FOLLOW CAMERA STATE ####


func _ready():
	yield(owner, "ready")
	camera = owner
	screen_size = get_viewport().get_size() / 2


# This state is used to follow the players
# It computes the average position of all the players, and move the camera towards it
# Progressivly, so the camera feels smooth
func update(_host, _delta):
	var players_array = camera.get_players_array()
	
	# Move the camera speed towards the average postion
	# With a horiziontal/vertical restriction
	if len(players_array) > 0:
		
		# Compute the dest of the camera
		var average_pos : Vector2 = camera.compute_average_pos(players_array)
		var border_dir = get_border_approched(average_pos)
		var dest = average_pos + border_dir * ANTICIP_DIST
		
		# Move the camera
		if camera.get_global_position().distance_to(dest) > 3.0:
			camera.start_moving(dest)
		
		# Zoom/Dezoom if necesary
		var max_dist = screen_size * 0.6
		var players_distance = compute_player_distance(players_array)
		var dest_zoom := Vector2.ONE
		
		if players_distance.length() > max_dist.length():
			var distance_ratio = players_distance.length() / max_dist.length()
			distance_ratio = clamp(distance_ratio, 1.0, 2.0)
			dest_zoom = Vector2(distance_ratio, distance_ratio)
		
		if camera.zoom != dest_zoom:
			camera.start_zooming(dest_zoom)


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


# 1) Check if at least one player is in the anticipation zone
# 2) Find which player is the nearest form the border of the screen if it
# wasn't zoomed and/or anticipated and returns its the nearest border

# Returns an array of borders being approched
func get_border_approched(ply_average_pos: Vector2) -> Vector2:
	var border_player_couples := Array()
	var players_array = owner.get_players_array()
	
	for player in players_array:
		var player_pos = player.get_global_position()
		
		if player_pos.x > ply_average_pos.x + (screen_size.x / 2) - screen_size.x * ANTICIP_TRIGGER_RATIO && \
		player.last_direction == 1:
			border_player_couples.append([Vector2.RIGHT, player])
		
		elif player_pos.y < ply_average_pos.y - (screen_size.y / 2) + screen_size.y * ANTICIP_TRIGGER_RATIO && \
		player.last_direction == -1:
			border_player_couples.append([Vector2.LEFT, player])
	
	if border_player_couples.size() == 0: return Vector2.ZERO
	elif border_player_couples.size() == 1: return border_player_couples[0][0]
	else: return find_nearest_border(border_player_couples, ply_average_pos)


# Find the direction of the nearest border of the theorical screen
# (If the camera wasn't dezoomed of anticipated) form the average player position
func find_nearest_border(couples_array: Array, play_avg_pos: Vector2) -> Vector2:
	var dist_array := Array()
	for couple in couples_array:
		var player = couple[1]
		var border_dir = couple[0]
		var player_pos = player.get_global_position()
		
		if is_pos_outside_theorical_screen(player_pos, play_avg_pos):
			return border_dir
		
		var border_pos = play_avg_pos.x + (screen_size.x / 2)
		if border_dir == Vector2.RIGHT:
			border_pos = play_avg_pos.x - (screen_size.x / 2)
		
		dist_array.append(abs(player_pos - border_pos))
	
	var nearest_border_id = find_smallest_value_id(dist_array)
	return couples_array[nearest_border_id][0]


# Retrun true if the given pos is outside the theorical space of the screen
# If the camera had no zoom and no anticipation offset
func is_pos_outside_theorical_screen(pos: Player, play_avg_pos: Vector2) -> bool:
	return pos.x > play_avg_pos.x + screen_size.x / 2 or pos.x < play_avg_pos.x - screen_size.x / 2 or \
		pos.y > play_avg_pos.y + screen_size.y / 2 or pos.y < play_avg_pos.y - screen_size.y / 2


# Returns the id of the smallest value in the array
func find_smallest_value_id(array: Array) -> int:
	var smallest_value : float = INF
	var smallest_value_id : int = -1
	for i in range(array.size()):
		if array[i] < smallest_value:
			smallest_value = array[i]
			smallest_value_id = i
	return smallest_value_id


# Convert a global position to a relative position to the camera origin (center)
func global_to_relative(global : Vector2) -> Vector2:
	return global - owner.get_global_position()
