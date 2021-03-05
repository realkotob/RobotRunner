tool
extends Sprite
class_name LevelNode

enum EDITOR_SELECTED{
	UNSELECTED,
	BIND_ORIGIN,
	BIND_DESTINATION
}

var destinations_array := Array()
var editor_select_state : int = EDITOR_SELECTED.UNSELECTED setget set_editor_select_state, get_editor_select_state

signal add_bind_query(origin, dest)

#### ACCESSORS ####

func is_class(value: String): return value == "LevelNode" or .is_class(value)
func get_class() -> String: return "LevelNode"

func set_editor_select_state(value: int):
	if value != editor_select_state && (value >= 0 && value < EDITOR_SELECTED.size()):
		editor_select_state = value
		
		match(editor_select_state):
			EDITOR_SELECTED.UNSELECTED: 
				$ColorRect.set_frame_color(Color.transparent)
				print("frame color to transparent")
			EDITOR_SELECTED.BIND_ORIGIN: $ColorRect.set_frame_color(Color.blue)
			EDITOR_SELECTED.BIND_DESTINATION: $ColorRect.set_frame_color(Color.red)

func get_editor_select_state() -> int: return editor_select_state


#### BUILT-IN ####

func _ready() -> void:
	if !Engine.editor_hint:
		$ColorRect.queue_free()
	else:
		connect("add_bind_query", owner, "_on_add_bind_query")


#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
