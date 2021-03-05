tool
extends CanvasLayer
class_name LevelSelectionMenu

const bound_scene = preload("res://Scenes/Menus/LevelSelectionMenu/LevelNodeBound.tscn")

#### ACCESSORS ####

func is_class(value: String): return value == "LevelSelectionMenu" or .is_class(value)
func get_class() -> String: return "LevelSelectionMenu"


#### BUILT-IN ####

func _ready() -> void:
	$Levels/LevelNode.add_bind($Levels/LevelNode2)


#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_add_bind_query(origin: LevelNode, dest: LevelNode):
	var bound = bound_scene.instance()
	$Bounds.add_child(bound)
	bound.owner = self
	
	bound.set_origin(origin)
	bound.set_destination(dest)
