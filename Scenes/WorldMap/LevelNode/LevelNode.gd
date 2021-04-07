tool
extends Sprite
class_name LevelNode

enum EDITOR_SELECTED{
	UNSELECTED,
	BIND_ORIGIN,
	BIND_DESTINATION
}

export var level_scene_path : String = "" setget , get_level_scene_path

export var hidden : bool = false setget set_hidden, is_hidden
export var accessible : bool = true
export var visited : bool = false setget set_visited, is_visited

var editor_select_state : int = EDITOR_SELECTED.UNSELECTED setget set_editor_select_state, get_editor_select_state

# warning-ignore:unused_signal
signal add_bind_query(origin, dest)
# warning-ignore:unused_signal
signal remove_all_binds_query(origin)
signal hidden_changed(level_node, hidden_value)


#### ACCESSORS ####

func is_class(value: String): return value == "LevelNode" or .is_class(value)
func get_class() -> String: return "LevelNode"

func set_editor_select_state(value: int):
	if value != editor_select_state && (value >= 0 && value < EDITOR_SELECTED.size()):
		editor_select_state = value
		
		match(editor_select_state):
			EDITOR_SELECTED.UNSELECTED: $ColorRect.set_frame_color(Color.transparent)
			EDITOR_SELECTED.BIND_ORIGIN: $ColorRect.set_frame_color(Color.blue)
			EDITOR_SELECTED.BIND_DESTINATION: $ColorRect.set_frame_color(Color.red)

func get_editor_select_state() -> int: return editor_select_state

func set_visited(value: bool):
	visited = value
	if visited: set_modulate(Color.darkgray)
	else: set_modulate(Color.white)

func is_visited() -> bool: return visited

func set_hidden(value: bool): 
	if value != hidden:
		hidden = value
		if Engine.editor_hint:
			if hidden:
				set_modulate(Color(1, 1, 1, 0.2))
			else:
				set_modulate(Color.white)
		else:
			set_visible(!hidden)
		emit_signal("hidden_changed", self, hidden)

func is_hidden() -> bool : return hidden

func get_level_scene_path() -> String: return level_scene_path

#### BUILT-IN ####

func _ready() -> void:
	yield(owner, "ready")
	owner.get_binds(self)
	
	var __ = connect("hidden_changed", owner, "_on_level_node_hidden_changed")
	
	if !Engine.editor_hint:
		$ColorRect.queue_free()
	else:
		__ = connect("add_bind_query", owner, "_on_add_bind_query")
		__ = connect("remove_all_binds_query", owner, "_on_remove_all_binds_query")


#### VIRTUALS ####



#### LOGIC ####


func get_binds() -> Array:
	return owner.get_binds(self)


func get_binds_count() -> int:
	return get_binds().size()



#### INPUTS ####



#### SIGNAL RESPONSES ####
