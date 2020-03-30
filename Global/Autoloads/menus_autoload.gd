extends Node

onready var game_over_scene = preload("res://Scenes/GUI/Menus/GameOverScene/GameOver.tscn")
onready var pause_menu_scene = preload("res://Scenes/GUI/Menus/PauseMenu/PauseMenu.tscn")
onready var option_menu_scene = preload("res://Scenes/GUI/Menus/OptionsMenu/OptionsMenu.tscn")
onready var title_screen_scene = preload("res://Scenes/GUI/Menus/ScreenTitle/ScreenTitle.tscn")

# Triggers the game over scene
func gameover():
	var _err = get_tree().change_scene_to(game_over_scene)
