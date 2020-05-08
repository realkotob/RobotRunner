extends MenuBase
class_name SubMenuBase 

func _unhandled_input(event):
	if event is InputEvent:
		if event.is_action_pressed("ui_cancel"):
			get_tree().paused = false
			queue_free()
