extends MenuOptionsBase

onready var infinite_level_scene = preload("res://Scenes/Levels/InfiniteMode/InfiniteLevel.tscn")

#### ACCESSORS ####

func is_class(value: String): return value == "" or .is_class(value)
func get_class() -> String: return ""


#### BUILT-IN ####



#### VIRTUALS ####

func on_pressed():
	var _err = get_tree().change_scene_to(infinite_level_scene)


#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
