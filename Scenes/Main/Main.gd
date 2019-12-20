extends Node2D

onready var game_playing_node = get_node("GamePlaying")
onready var root_viewport = get_tree().get_root().get_viewport()

var game_over_scehe = preload("res://Scenes/GameOverScene/GameOver.tscn")
var game_over_node : Node

var scr_size = Vector2(ProjectSettings.get("display/window/size/width"), ProjectSettings.get("display/window/size/width"))


func game_over():
	game_playing_node.queue_free()
	game_over_node = game_over_scehe.instance()
	add_child(game_over_node)
#	game_over_node.get_node("Label").set_global_position(Vector2(220, 228.5))