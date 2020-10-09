extends MenuOptionsBase

func on_pressed():
	if(get_tree().paused):
		#Player Selection -> New Game
		SCORE.set_xion(GAME.progression.get_main_xion())
		SCORE.set_materials(GAME.progression.get_main_materials())
		get_tree().paused = false
		var _err = GAME.goto_last_level()

