extends Node2D
class_name WorldMapMovingElement

onready var tween_node = $Tween

var moving : bool = false setget set_moving, is_moving

signal movement_finished

#### ACCESSORS ####

func is_class(value: String): return value == "WorldMapMovingElement" or .is_class(value)
func get_class() -> String: return "WorldMapMovingElement"

func set_moving(value: bool): moving = value
func is_moving() -> bool: return moving

#### BUILT-IN ####

func _ready() -> void:
	var __ = connect("movement_finished", self, "_on_movement_finished")

#### VIRTUALS ####



#### LOGIC ####


func move(dest: Vector2):
	tween_node.interpolate_property(self, "global_position",
		get_global_position(), dest,
		1.0, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	
	tween_node.start()
	
	moving = true
	
	yield(tween_node, "tween_all_completed")
	emit_signal("movement_finished")


#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_movement_finished():
	moving = false
