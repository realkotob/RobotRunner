extends Button

class_name MenuOptionsBase

var menu_node = Control

signal aimed

const NORMAL := Color(1, 1, 1, 1)
const DISABLED := Color(0.25, 0.25, 0.25, 1)
const SELECTED := Color(1, 0, 0, 1)

var selected : bool = false setget set_selected


func setup():
	var _err = connect("pressed", self, "on_pressed")
	_err = connect("mouse_entered", self, "on_mouse_entered")
	_err = connect("aimed", menu_node, "on_button_aimed")
	
	if disabled:
		set_self_modulate(DISABLED)


func set_selected(value: bool):
	selected = value
	on_selected_changed()


func on_selected_changed():
	if selected:
		set_self_modulate(SELECTED)
	else:
		set_self_modulate(NORMAL)


func on_pressed():
	pass


func on_mouse_entered():
	if !is_disabled():
		emit_signal("aimed", self, true)
