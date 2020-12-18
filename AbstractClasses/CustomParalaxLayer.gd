extends ParallaxLayer
class_name CustomParallaxLayer

#### ACCESSORS ####

func is_class(value: String): return value == "CustomParallaxLayer" or .is_class(value)
func get_class() -> String: return "CustomParallaxLayer"


#### BUILT-IN ####

func _enter_tree() -> void:
	set_scale(Vector2.ONE)

#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
