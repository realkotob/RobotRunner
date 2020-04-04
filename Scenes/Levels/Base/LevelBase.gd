extends Node2D

class_name LevelBase

onready var music_node = $Music
onready var xion_cloud_node = get_node_or_null("XionCloud")

onready var screen_size : Vector2 = get_viewport().get_size()
onready var danger_distance : float = screen_size.x / 2

var players_array : Array
var player_in_danger : bool = false


func _ready():
	instanciate_players()


func _physics_process(_delta):
	if xion_cloud_node == null:
		return
	
	var closest_player = get_closest_player(xion_cloud_node)
	
	if closest_player == null:
		return
	
	# Triggers the medium stream when one of the players is close enough from the cloud
	if get_distance_to(closest_player, xion_cloud_node) <= danger_distance:
		music_node.interpolate_stream_volume("Medium", 0.0 , 0.01)
	else: # If the closest player is to far from the cloud, fade_out the medium stream
		music_node.interpolate_stream_volume("Medium", -80.0, 0.01)
	
	if player_in_danger:
		music_node.interpolate_stream_volume("Hard", 0.0, 0.05)
	else:
		music_node.interpolate_stream_volume("Hard", -80.0, 0.05)


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
