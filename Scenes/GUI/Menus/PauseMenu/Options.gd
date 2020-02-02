extends MenuOptionsBase

onready var title_screen = "res://Scenes/GUI/Menus/ScreenTitle/ScreenTitle.tscn"

func options_action():
	get_tree().change_scene(title_screen)
	get_tree().paused = false
