tool
extends Path2D
class_name LevelNodeBind

onready var line : Line2D = $Line2D

export var origin_node_path : String = ""
export var destination_node_path : String = ""

var origin : Node2D setget set_origin, get_origin
var destination : Node2D setget set_destination, get_destination

var is_ready : bool = false

#### ACCESSORS ####

func is_class(value: String): return value == "LevelNodeBound" or .is_class(value)
func get_class() -> String: return "LevelNodeBound"

func set_origin(value: Node2D):
	if origin == value: 
		return
	origin = value
	if origin_node_path == "" && owner != null:
		origin_node_path = owner.get_path_to(origin)

func get_origin() -> Node2D: return origin

func set_destination(value: Node2D): 
	if destination == value: 
		return
	destination = value
	if destination_node_path == "" && owner != null:
		destination_node_path = owner.get_path_to(destination)

func get_destination() -> Node2D: return destination


#### BUILT-IN ####

func _ready() -> void:
	set_curve(Curve2D.new())
	
	if owner != null && origin_node_path != "" && destination_node_path != "":
		set_origin(owner.get_node(origin_node_path))
		set_destination(owner.get_node(destination_node_path))
	
	is_ready = true


func _process(delta: float) -> void:
	_update_line()

#### VIRTUALS ####



#### LOGIC ####


func _update_line():
	if origin == null or destination == null:
		return
	
	curve.clear_points()
	
	curve.add_point(origin.get_global_position())
	curve.add_point(destination.get_global_position())
	
	var points = curve.get_baked_points()
	line.set_points(points)


#### INPUTS ####



#### SIGNAL RESPONSES ####
