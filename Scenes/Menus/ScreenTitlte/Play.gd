extends MenuOptionsBase

# Give mainscene path, so it can be changed later (or loaded?)
onready var strMainScene = "res://Scenes/Main/Main.tscn"

func options_action():
	# Player Selection -> New Game
	var _err = get_tree().change_scene(strMainScene)