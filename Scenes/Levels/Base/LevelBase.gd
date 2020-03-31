extends Node2D

class_name LevelBase


func _ready():
	instanciate_players()


# Intanciate the players inside the level
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
		
		player1_node.setup()
		
	if player2_start_node != null:
		var player2_start_pos = player2_start_node.get_global_position()
		var player2_node = GAME.player2.instance()
		player2_node.global_position = player2_start_pos
		player2_node.level_node = self
		add_child(player2_node)
		
		player2_node.setup()


	# Give the references to the players node to every interactive objects needing it
	var interactive_objects_array = get_tree().get_nodes_in_group("InteractivesObjects")
	for inter_object in interactive_objects_array:
		if inter_object.get("players_node_array") != null:
			inter_object.players_node_array = get_tree().get_nodes_in_group("Players")
