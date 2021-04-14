tool
extends Node2D
class_name WorldMapMovingElement

onready var tween_node = $Tween

var moving : bool = false setget set_moving, is_moving
var current_level : LevelNode = null setget set_current_level, get_current_level

signal movement_finished
signal path_finished

#### ACCESSORS ####

func is_class(value: String): return value == "WorldMapMovingElement" or .is_class(value)
func get_class() -> String: return "WorldMapMovingElement"

func set_moving(value: bool): moving = value
func is_moving() -> bool: return moving

func set_current_level(value: LevelNode): current_level = value
func get_current_level() -> LevelNode: return current_level

#### BUILT-IN ####

func _ready() -> void:
	var __ = connect("movement_finished", self, "_on_movement_finished")


func _process(_delta: float) -> void:
	if Engine.editor_hint && current_level != null:
		set_position(current_level.get_position())

#### VIRTUALS ####



#### LOGIC ####

func move_to_level(level_node: LevelNode):
	if level_node == null or is_moving():
		 return
	
	var bind = owner.get_bind(current_level, level_node)
	var path = bind.get_point_path()
	
	# If we need move along the bind in backwards order
	if bind.origin == level_node:
		path.invert()
	
	set_current_level(level_node)
	
	move_along_path(path)


func move_along_path(path: PoolVector2Array):
	for i in range(path.size()):
		var point = path[i]
		if i == 0:
			continue
		
		move(point)
		
		yield(self, "movement_finished")
	
	emit_signal("path_finished")


func move(dest: Vector2, ease_type: int = Tween.EASE_IN_OUT):
	tween_node.interpolate_property(self, "global_position",
		get_global_position(), dest,
		0.7, Tween.TRANS_CUBIC, ease_type)
	
	tween_node.start()
	
	moving = true
	
	yield(tween_node, "tween_all_completed")
	emit_signal("movement_finished")


#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_movement_finished():
	moving = false

