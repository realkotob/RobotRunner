extends MenuOptionsBase

#Give mainscene path, so it can be changed later (or loaded?)
onready var strMainScene = "res://Scenes/MainScene/Main.tscn"

func options_action():
	if(get_tree().paused):
		#Player Selection -> New Game
		get_tree().paused = false
		var _err = get_tree().reload_current_scene()