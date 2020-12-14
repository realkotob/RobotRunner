extends Lava
class_name GrowingLava
tool

export (int, 0, 1000) var speed = 20
export var is_growing : bool = false setget set_is_growing

#### ACCESSORS ####

func is_class(value: String): return value == "GrowingLava" or .is_class(value)
func get_class() -> String: return "GrowingLava"


#### BUILT-IN ####

func _physics_process(delta):
	if is_growing:
		growing(delta)


#### LOGIC ####

func set_is_growing(value : bool):
	is_growing = value

func growing(delta):
	set_pool_size(get_pool_size() + Vector2(0, speed * delta))
