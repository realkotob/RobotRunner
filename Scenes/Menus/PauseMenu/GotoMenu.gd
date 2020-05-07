extends MenuOptionsBase

func on_pressed():
	var _err = get_tree().change_scene_to(MENUS.title_screen_scene)
	get_tree().paused = false
