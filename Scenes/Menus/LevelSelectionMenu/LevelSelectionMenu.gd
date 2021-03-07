tool
extends CanvasLayer
class_name LevelSelectionMenu

const bind_scene = preload("res://Scenes/Menus/LevelSelectionMenu/LevelNodeBind.tscn")

onready var binds_container = $Binds

#### ACCESSORS ####

func is_class(value: String): return value == "LevelSelectionMenu" or .is_class(value)
func get_class() -> String: return "LevelSelectionMenu"


#### BUILT-IN ####



#### VIRTUALS ####



#### LOGIC ####

func are_level_nodes_bounded(origin: LevelNode, dest: LevelNode) -> bool:
	for bind in binds_container.get_children():
		if bind.get_origin() == origin && bind.get_destination() == dest:
			return true
	return false


#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_add_bind_query(origin: LevelNode, dest: LevelNode):
	var bind = bind_scene.instance()
	binds_container.add_child(bind)
	bind.owner = self
	
	origin.add_bind(bind)
	
	bind.set_origin(origin)
	bind.set_destination(dest)


func _on_remove_all_binds_query(origin: LevelNode):
	for bind in binds_container.get_children():
		if bind.get_origin() == origin:
			origin.remove_bind(bind)
			bind.queue_free()
