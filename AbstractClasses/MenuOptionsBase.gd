extends Button

class_name MenuOptionsBase

var menu_node = Control

signal focus_changed(entity, focus)
signal option_chose(menu_option)

const NORMAL := Color.white
const DISABLED := Color(0.25, 0.25, 0.25, 1)
const SELECTED := Color.red

var focused : bool = false setget set_focused, is_focused

#### ACCESSSORS ####

func set_focused(value: bool):
	if value != focused:
		focused = value
		if focused:
			set_self_modulate(SELECTED)
		else:
			set_self_modulate(NORMAL)
		emit_signal("focus_changed", self, focused)

func is_focused() -> bool: return focused


#### LOGIC ####

func setup():
	var _err = connect("pressed", self, "on_pressed")
	_err = connect("mouse_entered", self, "on_mouse_entered")
	
	if disabled:
		set_self_modulate(DISABLED)



func on_pressed():
	emit_signal("option_chose", self)


func on_mouse_entered():
	if !is_disabled():
		set_focused(true)
