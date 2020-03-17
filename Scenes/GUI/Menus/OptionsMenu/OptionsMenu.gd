extends MenuBase

var game_scene = "res://Scenes/Main/Game.tscn"


func _unhandled_input(event):
	if event is InputEvent:
		if event.is_action_pressed("ui_cancel"):
			get_tree().paused = false
			queue_free()


# FUNCTION OVERWRITE
# Change the color of menu option according if it is selected by a player or not
func highlight_menuopt():
	buttons_array[prev_button_index].set_self_modulate(NORMAL)
	buttons_array[button_index].set_self_modulate(SELECTED)
	
	if buttons_array[prev_button_index].has_method("on_option_unselected"):
		buttons_array[prev_button_index].on_option_unselected()
		
	if buttons_array[button_index].has_method("on_option_selected"):
		buttons_array[button_index].on_option_selected()
