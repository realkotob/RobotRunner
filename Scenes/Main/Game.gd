extends Node2D

const level1 = preload("res://Scenes/Levels/Level1.tscn")
const debug_level = preload("res://Scenes/Levels/LevelDebug.tscn")
const player1 = preload("res://Scenes/Characters/RobotIce/RobotIce.tscn")
const player2 = preload("res://Scenes/Characters/RobotHammer/RobotHammer.tscn")

var current_level_node : Node

var game_over_scene = preload("res://Scenes/GUI/Menus/GameOverScene/GameOver.tscn")

# Generate the level, and the players
func _ready():
	generate_current_level()


# Generate the current level, and instanciate it as child of this node the generate the players inside of it
func generate_current_level():
	#current_level_node = debug_level.instance() 
	current_level_node = level1.instance()
	add_child(current_level_node)
	instanciate_players()


# Intanciate the players inside the level
func instanciate_players():
	# Get the players starting positions
	var player1_start_node = current_level_node.get_node_or_null("StartingPointP1")
	var player2_start_node = current_level_node.get_node_or_null("StartingPointP2")
	
	# Add the players scene to the level scene a the position of the start position
	if player1_start_node != null:
		var player1_start_pos = player1_start_node.get_global_position()
		var player1_node = player1.instance()
		player1_node.global_position = player1_start_pos
		player1_node.level_node = current_level_node
		current_level_node.add_child(player1_node)
		
	
	if player2_start_node != null:
		var player2_start_pos = player2_start_node.get_global_position()
		var player2_node = player2.instance()
		player2_node.global_position = player2_start_pos
		player2_node.level_node = current_level_node
		current_level_node.add_child(player2_node)
	
	# Give the references to the players node to every interactive objects needing it
	var interactive_objects_array = get_tree().get_nodes_in_group("InteractivesObjects")
	for inter_object in interactive_objects_array:
		if inter_object.get("players_node_array") != null:
			inter_object.players_node_array = get_tree().get_nodes_in_group("Players")


# Triggers the game over scene
func on_gameover():
	var game_over_node = game_over_scene.instance()
	game_over_node.game_node = self
	add_child(game_over_node)
	
	current_level_node.queue_free()
