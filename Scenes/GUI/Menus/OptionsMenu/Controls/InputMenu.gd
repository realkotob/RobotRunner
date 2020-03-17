extends Control

onready var _action_list = get_node("CanvasLayer/Column/ScrollContainer/ActionList")


func _ready():
	var _err = $InputMapper.connect('profile_changed', self, 'rebuild')
	$CanvasLayer/Column/ProfilesMenu.initialize($InputMapper)
	$InputMapper.change_profile($CanvasLayer/Column/ProfilesMenu.selected)


func rebuild(input_profile, is_customizable=false):
	_action_list.clear()
	for input_action in input_profile.keys():
		var line = _action_list.add_input_line(input_action, \
			input_profile[input_action], is_customizable)
		if is_customizable:
			var _err = line.connect('change_button_pressed', self, \
				'_on_InputLine_change_button_pressed', [input_action, line])


func _on_InputLine_change_button_pressed(action_name, line):
	set_process_input(false)
	
	$CanvasLayer/KeySelectMenu.open()
	var key_scancode = yield($CanvasLayer/KeySelectMenu, "key_selected")
	$InputMapper.change_action_key(action_name, key_scancode)
	line.update_key(key_scancode)
	
	set_process_input(true)


func _input(event):
	if event.is_action_pressed('ui_cancel'):
		queue_free()
		get_tree().paused = false


func _on_PlayButton_pressed():
	queue_free()
	get_tree().paused = false
