tool
extends CanvasLayer
class_name LevelSelectionMenu

const bind_scene = preload("res://Scenes/WorldMap/Bind/LevelNodeBind.tscn")

onready var binds_container = $Binds
onready var tween_node = $Tween

onready var characters_container = $Characters

export var cursor_start_level_path : String = "" 

onready var cursor : Node2D = $WorldMapCursor
var cursor_moving : bool = false

var is_ready : bool = false 

#### ACCESSORS ####

func is_class(value: String): return value == "LevelSelectionMenu" or .is_class(value)
func get_class() -> String: return "LevelSelectionMenu"


#### BUILT-IN ####

func _ready() -> void:
	var current_level = get_node(cursor_start_level_path)
	
	cursor.set_current_level(current_level)
	characters_container.set_current_level(current_level)


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
	
	cursor.move_to_level(adequate_node)



func find_adequate_level(dir: Vector2) -> LevelNode:
	var current_level = cursor.get_current_level()
	var level_node_binds = get_binds(current_level)
	
	for bind in level_node_binds:
		if bind.get_path_direction_form_node(current_level) == dir:
			if current_level == bind.get_origin():
				return bind.get_destination()
			else:
				return bind.get_origin()
	
	return null



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
			bind_array.append(bind)
	
	return bind_array


func get_bind(origin: LevelNode, dest: LevelNode) -> LevelNodeBind:
	for child in binds_container.get_children():
		var bind_nodes = [child.get_origin(), child.get_destination()]
		if origin in bind_nodes && dest in bind_nodes:
			return child
	return null


func enter_level():
	var current_level_node = cursor.get_current_level()
	if current_level_node != null && !current_level_node.is_visited():
		var current_level_path = current_level_node.get_level_scene_path()
		
		if current_level_path == "":
			print("The LevelNode " + current_level_node.name + " doesn't have any scene path")
		
		GAME.goto_level_by_path(current_level_path)



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
	
	if Input.is_action_just_pressed("ui_accept"):
		var current_level_node = cursor.get_current_level()
		if !characters_container.is_moving():
			characters_container.move_to_level(current_level_node)
			
			yield(characters_container, "enter_level_animation_finished")
			enter_level()

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
