extends MenuOptionsBase

func options_action():
	if(get_tree().paused):
		get_tree().quit()
