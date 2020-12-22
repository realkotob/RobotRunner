extends LineEdit
class_name SeedField
tool

signal focus_changed(entity, focus)
signal submit(seed_value)

var focused : bool = false setget set_focused, is_focused

export var default_text = "" setget set_default_text

#### ACCESSORS ####

func is_class(string: String): return string == "TextField" or .is_class(string)
func get_class() -> String: return "TextField"

func set_focused(new_value: bool):
	if new_value != focused:
		focused = new_value
		emit_signal("focus_changed", focused)

func is_focused() -> bool: return focused

func set_default_text(value: String):
	default_text = value
	set_text(default_text)

#### BUILT-IN ####


func _ready() -> void:
	var _err = connect("text_entered", self, "_on_text_entered")
	_err = connect("text_changed", self, "_on_text_changed")
	_err = connect("focus_entered", self, "_on_focus_entered")
	_err = connect("focus_exited", self, "_on_focus_exited")
	_err = connect("gui_input", self, "_on_gui_input")


#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####


#### SIGNAL RESPONSES ####

func _on_text_changed(new_text: String):
	for i in len(new_text):
		var character = new_text[i]
		if !character.is_valid_integer():
			delete_char_at_cursor()


func _on_text_entered(new_text: String) -> void:
	set_visible(false)
	emit_signal("submit", int(new_text))


func _on_focus_entered():
	if get_text() == default_text:
		clear()
	set_focused(true)

func _on_focus_exited():
	set_text(default_text)
	set_focused(false)

func _on_gui_input(event: InputEvent):
	if event.is_action_pressed("ui_cancel") && is_focused():
		get_parent().grab_focus()
