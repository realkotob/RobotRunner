extends Node

onready var children_array = get_children()

onready var screen_size : Vector2 = get_viewport().get_size()
onready var danger_distance : float = screen_size.x / 2

var playing : bool = false setget set_playing, is_playing

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS


func set_playing(value: bool):
	playing = value

func is_playing() -> bool:
	return playing

# Adapt the differents music layers volumes based on the distance of the players from
# The cloud
func adapt_music(xion_cloud: Node, players_array: Array, player_in_danger: bool):
	var closest_player : Player = null
	
	if xion_cloud == null:
		return
	
	if len(players_array) > 1:
		closest_player = get_closest_player(xion_cloud, players_array)
	
	if closest_player == null:
		return
	
	var dist_to = get_distance_to(closest_player, xion_cloud)
	
	# Triggers the medium stream when one of the players is close enough from the cloud
	if dist_to <= danger_distance:
		interpolate_stream_volume("Medium", index_volume_on_distance(dist_to) , 0.1)
	else: # If the closest player is to far from the cloud, fade_out the medium stream
		interpolate_stream_volume("Medium", -80.0, 0.1)
	
	# If a player is in danger, triggers the hard stream
	if player_in_danger:
		interpolate_stream_volume("Hard", 0.0, 0.1)
	else:
		interpolate_stream_volume("Hard", -80.0, 0.01)



# Returns the distance between the two given elements
func get_distance_to(element1: Node, element2: Node) -> float:
	return element1.get_global_position().distance_to(element2.get_global_position())


# Return the closest player from the element
func get_closest_player(element: Node, players_array: Array) -> Player:
	var smaller_distance : float = INF
	var current_distance : float = 0.0
	var closest_player : Player = players_array[0]
	
	if len(players_array) > 1:
		for player in players_array:
			current_distance = get_distance_to(element, player)
			if current_distance < smaller_distance:
				smaller_distance = current_distance
				closest_player = player
	
	return closest_player


# Compute the desired volume based on the given distance
func index_volume_on_distance(dist_to : float) -> float:
	var desired_volume : float = (1.0 / 100.0) * (dist_to / 4)
	desired_volume *= desired_volume * desired_volume
	desired_volume *= -1.0
	return clamp(desired_volume, -80.0, .0)



# Start playing every layers of music
func play():
	if !is_playing():
		set_playing(true)
		for child in children_array:
			child.play()


# Start playing every layers of music
func stop():
	if is_playing():
		set_playing(false)
		for child in children_array:
			child.stop()


# Interpolate the volume of the given stream
func interpolate_stream_volume(stream_name : String, dest_volume: float, weight : float):
	var stream = get_node_or_null(stream_name)
	
	if stream != null:
		var current_volume = stream.get_volume_db()
		stream.set_volume_db(lerp(current_volume, dest_volume, weight))
