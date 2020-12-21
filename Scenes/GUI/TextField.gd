extends LineEdit
class_name TextField

signal focus_changed(entity, focus)
signal submit(new_text)

var focused : bool = false setget set_focused, is_focused

#### ACCESSORS ####

func is_class(value: String): return value == "TextField" or .is_class(value)
func get_class() -> String: return "TextField"

func set_focused(value: bool):
	if value != focused:
		focused = value
		emit_signal("focus_changed", focused)

func is_focused() -> bool: return focused



#### BUILT-IN ####



#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
