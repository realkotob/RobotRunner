extends CanvasLayer

var pause_menu = preload("res://Scenes/GUI/Menus/PauseMenu/PauseMenu.tscn")
var pause_menu_node : Control = null

var screen_width : float = ProjectSettings.get("display/window/size/width")
var screen_height : float = ProjectSettings.get("display/window/size/height")
var screen_size := Vector2(screen_width, screen_height)

# Create an instance of the menu if it doesn't exist yet
func _input(_event):
	if Input.is_action_just_pressed("ui_cancel") && get_node_or_null("PauseMenu") == null:
		var new_pause_state = not get_tree().paused
		get_tree().paused = new_pause_state
		pause_menu_node = pause_menu.instance()
		add_child(pause_menu_node)
