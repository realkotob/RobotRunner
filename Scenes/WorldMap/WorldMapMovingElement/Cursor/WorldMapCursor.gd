extends WorldMapMovingElement
class_name WorldMapCursor

var current_level : LevelNode = null setget set_current_level, get_current_level

#### ACCESSORS ####

func is_class(value: String): return value == "WorldMapCursor" or .is_class(value)
func get_class() -> String: return "WorldMapCursor"

func set_current_level(value: LevelNode): current_level = value
func get_current_level() -> LevelNode: return current_level

#### BUILT-IN ####



#### VIRTUALS ####



#### LOGIC ####


func move_to_level_node(dest_level: LevelNode):
	if dest_level == null: return
	current_level = dest_level
	move(dest_level.get_global_position())



#### INPUTS ####



#### SIGNAL RESPONSES ####
