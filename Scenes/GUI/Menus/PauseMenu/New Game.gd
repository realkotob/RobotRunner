extends MenuOptionsBase

func on_pressed():
	if(get_tree().paused):
		#Player Selection -> New Game
		get_tree().paused = false
		var _err = get_tree().reload_current_scene()

