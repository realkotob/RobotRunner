tool
extends CanvasLayer
class_name LevelSelectionMenu

const bind_scene = preload("res://Scenes/WorldMap/Bind/LevelNodeBind.tscn")

onready var binds_container = $Binds
onready var tween_node = $Tween

var cursor : Node2D = null
var cursor_moving : bool = false

#### ACCESSORS ####

func is_class(value: String): return value == "LevelSelectionMenu" or .is_class(value)
func get_class() -> String: return "LevelSelectionMenu"


#### BUILT-IN ####

func _ready() -> void:
	if !Engine.editor_hint:
		cursor = find_node("WorldMapCursor")


#### VIRTUALS ####



#### LOGIC ####

func are_level_nodes_bounded(origin: LevelNode, dest: LevelNode) -> bool:
	for bind in binds_container.get_children():
		if bind.get_origin() == origin && bind.get_destination() == dest:
			return true
	return false


func move_cursor(dir: Vector2):
	var adequate_node = find_adequate_level(dir)
	
	if adequate_node == null:
		return
	
	tween_node.interpolate_property(cursor, "global_position",
		cursor.get_global_position(), adequate_node.get_global_position(),
		1.0, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	
	tween_node.start()
	cursor_moving = true
	
	yield(tween_node, "tween_all_completed")
	var new_cursor = cursor.duplicate()
	var cursor_global_pos = cursor.get_global_position()
	cursor.queue_free()
	
	adequate_node.add_child(new_cursor)
	new_cursor.call_deferred("set_global_position", cursor_global_pos)
	cursor = new_cursor
	
	cursor_moving = false


func find_adequate_level(dir: Vector2) -> LevelNode:
	var current_level_node = cursor.get_parent()
	var bounded_nodes_array = get_bounded_level_nodes(current_level_node)
	var smallest_dist : float = INF
	var closest_node : LevelNode = null
	
	for level_node in bounded_nodes_array:
		var relative_pos = level_node.get_global_position() - current_level_node.get_global_position()
		
		var node_dir = current_level_node.get_global_position().direction_to(level_node.get_global_position())
		var dir_dist = dir.distance_to(node_dir)
		
		if dir_dist < smallest_dist:
			smallest_dist = dir_dist
			closest_node = level_node
	
	return closest_node


func get_bounded_level_nodes(node: LevelNode) -> Array:
	var binds_array = binds_container.get_children()
	var bounded_nodes_array := Array()
	
	for bind in binds_array:
		
		if bind.get_origin() == node:
			var dest = bind.get_destination()
			if not dest in bounded_nodes_array:
				bounded_nodes_array.append(dest)
		
		elif bind.get_destination() == node:
			var origin = bind.get_origin()
			if not origin in bounded_nodes_array:
				bounded_nodes_array.append(origin)
	
	return bounded_nodes_array

func get_binds(level_node: LevelNode) -> Array:
	var bind_array := Array()
	for bind in binds_container.get_children():
		if bind.get_origin() == level_node or bind.get_destination() == level_node:
			bind_array.append(level_node)
	
	return bind_array

#### INPUTS ####

func _input(_event: InputEvent) -> void:
	if Engine.editor_hint or cursor_moving:
		return
	
	if Input.is_action_just_pressed("ui_right"):
		move_cursor(Vector2.RIGHT)
	
	if Input.is_action_just_pressed("ui_up"):
		move_cursor(Vector2.UP)
	
	if Input.is_action_just_pressed("ui_down"):
		move_cursor(Vector2.DOWN)
	
	if Input.is_action_just_pressed("ui_left"):
		move_cursor(Vector2.LEFT)


#### SIGNAL RESPONSES ####

func _on_add_bind_query(origin: LevelNode, dest: LevelNode):
	var bind = bind_scene.instance()
	binds_container.add_child(bind)
	bind.owner = self
	
	bind.set_origin(origin)
	bind.set_destination(dest)


func _on_remove_all_binds_query(origin: LevelNode):
	for bind in binds_container.get_children():
		if bind.get_origin() == origin:
			bind.queue_free()
