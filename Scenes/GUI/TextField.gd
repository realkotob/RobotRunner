extends SpinBox
class_name SeedField

signal focus_changed(entity, focus)
signal submit(seed_value)

onready var line_edit = get_line_edit() 

var focused : bool = false setget set_focused, is_focused

#### ACCESSORS ####


func is_class(string: String): return string == "TextField" or .is_class(string)
func get_class() -> String: return "TextField"

func set_focused(new_value: bool):
	if new_value != focused:
		focused = new_value
		emit_signal("focus_changed", focused)

func is_focused() -> bool: return focused



#### BUILT-IN ####


func _ready() -> void:
	line_edit.connect("text_entered", self, "_on_text_entered")
	line_edit.connect("text_changed", self, "_on_text_changed")


#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####

func _on_text_changed(new_text: String):
	for i in len(new_text):
		var character = new_text[i]
		if !character.is_valid_integer():
			line_edit.delete_char_at_cursor()


func _on_text_entered(new_text: String) -> void:
	apply()
	set_visible(false)
	emit_signal("submit", int(new_text))

#### SIGNAL RESPONSES ####
