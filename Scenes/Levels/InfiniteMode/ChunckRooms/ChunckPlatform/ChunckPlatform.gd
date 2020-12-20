extends Node
class_name ChunckPlatform

var start_cell := Vector2.ZERO setget set_start_cell, get_start_cell
var size := Vector2.ZERO setget set_size, get_size

#### ACCESSORS ####

func is_class(value: String): return value == "ChunckPlatform" or .is_class(value)
func get_class() -> String: return "ChunckPlatform"

func set_start_cell(value: Vector2): start_cell = value
func get_start_cell() -> Vector2: return start_cell

func set_size(value : Vector2): size = value
func get_size() -> Vector2: return size 

func get_plarform_rect() -> Rect2: return Rect2(start_cell, size)

#### BUILT-IN ####

func _init(plfr_cell, plfr_size) -> void:
	set_start_cell(plfr_cell)
	set_size(plfr_size)


#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
