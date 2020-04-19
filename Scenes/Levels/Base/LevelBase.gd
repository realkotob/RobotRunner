extends Node2D

class_name Level

const CLASS : String = "Level"

onready var music_node = $Music
onready var xion_cloud_node = get_node_or_null("XionCloud")

onready var screen_size : Vector2 = get_viewport().get_size()
onready var danger_distance : float = screen_size.x / 2

var players_array : Array
var player_in_danger : bool = false

func _ready():
	set_starting_points()
	instanciate_players()
	GAME.set_current_level(self)


func _process(_delta):
	adapt_music()

func is_class(value: String) -> bool:
	return value == CLASS

func get_class() -> String:
	return CLASS


func adapt_music():
	if xion_cloud_node == null:
		return
	
	var closest_player = get_closest_player(xion_cloud_node)
	
	if closest_player == null:
		return
	
	var dist_to = get_distance_to(closest_player, xion_cloud_node)
	
	# Triggers the medium stream when one of the players is close enough from the cloud
	if dist_to <= danger_distance:
		music_node.interpolate_stream_volume("Medium", index_volume_on_distance(dist_to) , 0.1)
	else: # If the closest player is to far from the cloud, fade_out the medium stream
		music_node.interpolate_stream_volume("Medium", -80.0, 0.1)
	
	# If a player is in danger, triggers the hard stream
	if player_in_danger:
		### CHANGE THE SOUND FILE TO BE LOUDER ###
		music_node.interpolate_stream_volume("Hard", 0.0, 0.1)
	else:
		music_node.interpolate_stream_volume("Hard", -80.0, 0.01)


# Compute the desired volume based on the given distance
func index_volume_on_distance(dist_to : float) -> float:
	var desired_volume : float = (1.0 / 100.0) * (dist_to / 4)
	desired_volume *= desired_volume * desired_volume
	desired_volume *= -1.0
	return clamp(desired_volume, -80.0, .0)


func on_player_in_danger():
	player_in_danger = true


func on_player_out_of_danger():
	player_in_danger = false


# Returns the distance between the two given elements
func get_distance_to(element1: Node, element2: Node):
	return element1.get_global_position().distance_to(element2.get_global_position())


# Return the closest player from the element
func get_closest_player(element: Node):
	var smaller_distance : float = INF
	var current_distance : float = 0.0
	var closest_player : Node = null
	
	for player in players_array:
		current_distance = get_distance_to(element, player)
		if current_distance < smaller_distance:
			smaller_distance = current_distance
			closest_player = player
	
	return closest_player


# Load the last checkpoint visited and set the position accordingly,
# Also disable every uneeded checkpoint
func set_starting_points():
	var current_checkpoint = GAME.progression.checkpoint
	
	if current_checkpoint <= 0:
		return
	
	var checkpoint_array = get_node("Checkpoints").get_children()
	var starting_point_array = get_tree().get_nodes_in_group("StartingPoint")
	
	
	# Place the starting position based on the last checkpoint visited
	var new_starting_point1 = checkpoint_array[current_checkpoint - 1].get_node("NewStartingPoint1")
	var new_starting_point2 = checkpoint_array[current_checkpoint - 1].get_node("NewStartingPoint2")
	
	starting_point_array[0].set_global_position(new_starting_point1.global_position)
	starting_point_array[1].set_global_position(new_starting_point2.global_position)
	
	# Disable every checkpoint before the current one (And also the current one)
	for i in range(current_checkpoint):
		var collision_shape = checkpoint_array[i].get_node("CollisionShape2D")
		collision_shape.set_disabled(true)


# Intanciate the players inside the level
#### TO BE REFACTO -- NEED TO BE DYNAMIC ####
func instanciate_players():
	# Get the players starting positions
	var player1_start_node = get_node_or_null("StartingPointP1")
	var player2_start_node = get_node_or_null("StartingPointP2")

	# Add the players scene to the level scene a the position of the start position
	if player1_start_node != null:
		var player1_start_pos = player1_start_node.get_global_position()
		var player1_node = GAME.player1.instance()
		player1_node.global_position = player1_start_pos
		player1_node.level_node = self
		add_child(player1_node)
		players_array.append(player1_node)
		
		player1_node.setup()
		
	if player2_start_node != null:
		var player2_start_pos = player2_start_node.get_global_position()
		var player2_node = GAME.player2.instance()
		player2_node.global_position = player2_start_pos
		player2_node.level_node = self
		add_child(player2_node)
		players_array.append(player2_node)
		
		player2_node.setup()


	# Give the references to the players node to every interactive objects needing it
	var interactive_objects_array = get_tree().get_nodes_in_group("InteractivesObjects")
	for inter_object in interactive_objects_array:
		if inter_object.get("players_node_array") != null:
			inter_object.players_node_array = get_tree().get_nodes_in_group("Players")
