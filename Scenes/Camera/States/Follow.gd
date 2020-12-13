extends StateBase

const ANTICIP_DIST : float = 100.0
const ANTICIP_TRIGGER_RATIO : float = 0.15

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
	
		var average_pos : Vector2 = camera.compute_average_pos(players_array)
	
		# Move the camera
		if camera.get_global_position().distance_to(average_pos) > 3.0:
			camera.start_moving(average_pos)
		
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


# Returns an array of borders being approched
func get_borders_approched() -> PoolVector2Array:
	var borders := PoolVector2Array()
	var players_array = owner.get_players_array()
	
	for player in players_array:
		var player_pos = global_to_relative(player.get_global_position())
		
		if player_pos > (screen_size / 2) - screen_size * ANTICIP_TRIGGER_RATIO && \
		player.get_direction() == 1:
			borders.append(Vector2.RIGHT)
		
		elif player_pos < -(screen_size / 2) + screen_size * ANTICIP_TRIGGER_RATIO && \
		player.get_direction() == -1:
			borders.append(Vector2.LEFT)
	
	return borders


# Convert a global position to a relative position to the camera origin (center)
func global_to_relative(global : Vector2) -> Vector2:
	return global - owner.get_global_position()
