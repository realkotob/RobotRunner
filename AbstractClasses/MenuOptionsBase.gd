extends Button
class_name MenuOptionsBase

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

#### BUILT-IN ####

func _ready() -> void:
	var _err = connect("focus_entered", self, "_on_focus_entered")
	_err = connect("focus_exited", self, "_on_focus_exited")
	_err = connect("pressed", self, "_on_pressed")
	_err = connect("gui_input", self, "_on_gui_input")
	_err = connect("mouse_entered", self, "_on_mouse_entered")
	
	if disabled:
		set_self_modulate(DISABLED)

#### LOGIC ####


func _on_gui_input(event : InputEvent): 
	if event.is_action_pressed("ui_accept") && is_focused():
		set_pressed(true)

func _on_pressed(): emit_signal("option_chose", self)


func _on_mouse_entered():
	if !is_disabled():
		grab_focus()

func _on_focus_entered():
	set_focused(true)

func _on_focus_exited():
	set_focused(false)
