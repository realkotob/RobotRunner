tool
extends CanvasLayer
class_name LevelSelectionMenu

const bind_scene = preload("res://Scenes/WorldMap/Bind/LevelNodeBind.tscn")
const signal_light_scence = preload("res://Scenes/WorldMap/SignalLight.tscn")

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
	cursor.set_global_position(current_level.get_global_position())
	characters_container.set_current_level(current_level)
	characters_container.set_global_position(current_level.get_global_position())

#### VIRTUALS ####



#### LOGIC ####


# Returns true if the two given nodes are connected by a bind
func are_level_nodes_bounded(level1: LevelNode, level2: LevelNode) -> bool:
	for bind in binds_container.get_children():
		var bind_nodes = [bind.get_origin(), bind.get_destination()]
		if level1 in bind_nodes && level2 in bind_nodes:
			return true
	return false


# Move the cursor based on the user input
func move_cursor(dir: Vector2):
	var adequate_node = find_adequate_level(dir)
	if adequate_node == null:
		return
	
	cursor.move_to_level(adequate_node)


# Find the node targeted by the user, based on the direction of his input and returns it
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


# Get every nodes connected to the given one by a bind
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


# Returns an arrayu containing all the binds of the given node
func get_binds(level_node: LevelNode) -> Array:
	var bind_array := Array()
	for bind in binds_container.get_children():
		if bind.get_origin() == level_node or bind.get_destination() == level_node:
			bind_array.append(bind)
	
	return bind_array

# Return the bind conencting the two given nodes
func get_bind(origin: LevelNode, dest: LevelNode) -> LevelNodeBind:
	for child in binds_container.get_children():
		var bind_nodes = [child.get_origin(), child.get_destination()]
		if origin in bind_nodes && dest in bind_nodes:
			return child
	return null


func enter_current_level():
	var current_level_node = cursor.get_current_level()
	if current_level_node != null && !current_level_node.is_visited():
		var current_level_path = current_level_node.get_level_scene_path()
		
		if current_level_path == "":
			print("The LevelNode " + current_level_node.name + " doesn't have any scene path")
		
		GAME.goto_level_by_path(current_level_path)


func light_moving_through(start: LevelNode, dest: LevelNode):
	var bind = get_bind(start, dest)
	if bind == null:
		print_debug("The given start and/or dest LevelNode are neither the origin nor the destination")
		return
	
	var line_array := Array()
	bind.get_every_branching_line(start, line_array)
	
	for line in line_array:
		var points = line.get_points()
		
		if line.depth != 0 or start != line.get_start_cap_node():
			points.invert()
			if line.depth != 0:
				var main_line_points = line_array[0].get_points()
				if start != line_array[0].get_start_cap_node():
					main_line_points.invert()
				main_line_points.remove(0)
				points += main_line_points
		
		var signal_light = signal_light_scence.instance()
		var light_pos = points[0]
		add_child(signal_light)
		
		signal_light.set_global_position(light_pos)
		signal_light.move_along_path(points, false)


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
		var cursor_level_node = cursor.get_current_level()
		
		if !characters_container.is_moving() && !cursor_level_node.visited:
			light_moving_through(characters_container.current_level, cursor_level_node)
			characters_container.move_to_level(cursor_level_node)
#			yield(characters_container, "enter_level_animation_finished")
#			enter_current_level()

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


func _on_level_node_hidden_changed(level_node: LevelNode, hidden: bool):
	var level_binds = get_binds(level_node)
	for bind in level_binds:
		var hidden_bind = true if hidden else bind.origin.is_hidden() or bind.destination.is_hidden()
		bind.set_hidden(hidden_bind)


func _on_level_visited(level_node : LevelNode):
	var bounded_nodes = get_bounded_level_nodes(level_node)
	for node in bounded_nodes:
		if node.is_hidden():
			node.set_hidden(false)
