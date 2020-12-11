extends MenuOptionsBase

# Give mainscene path, so it can be changed later (or loaded?)
onready var strMainScene = "res://Scenes/Main/Game.tscn"

const START_LEVEL_INDEX : int = 1

# Player Selection -> New Game
func on_pressed():
	var _err = GAME.goto_level(START_LEVEL_INDEX)
	GAME.delete_all_level_temp_saves(false)
