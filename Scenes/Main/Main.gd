extends Node2D

onready var game_playing_node = get_node("GamePlaying")

var game_over_scehe = preload("res://Scenes/GameOverScene/GameOver.tscn")
var game_over_node : Node


# Triggers the game over 
func game_over():
	game_playing_node.queue_free()
	game_over_node = game_over_scehe.instance()
	add_child(game_over_node)