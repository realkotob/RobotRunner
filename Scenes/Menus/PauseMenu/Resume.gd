extends MenuOptionsBase

signal resume

func on_pressed():
	resume_game()

# Resume the game if the player hit cancel
func _input(_event):
	if Input.is_action_just_pressed("ui_cancel"):
		resume_game()


# Notify the PauseMenu node that the player chose the option resume and unpause the game
func resume_game():
	if(get_tree().paused):
		get_tree().paused = false 
		emit_signal("resume") 
