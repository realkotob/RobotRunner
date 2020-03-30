extends Node

onready var game_over_scene = preload("res://Scenes/GUI/Menus/GameOverScene/GameOver.tscn")
onready var pause_menu_scene = preload("res://Scenes/GUI/Menus/PauseMenu/PauseMenu.tscn")

# Triggers the game over scene
func gameover():
#	var game_over_node = MENUS.game_over_scene.instance()
#	game_over_node.game_node = self
#	add_child(game_over_node)
	var _err = get_tree().change_scene_to(game_over_scene)
