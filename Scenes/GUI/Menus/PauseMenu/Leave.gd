extends MenuOptionsBase

func on_pressed():
	if get_tree().paused:
		get_tree().quit()
