extends ChunckRoom
class_name BigChunckRoom

#### ACCESSORS ####

func is_class(value: String): return value == "BigChunckRoom" or .is_class(value)
func get_class() -> String: return "BigChunckRoom"

#### BUILT-IN ####



#### LOGIC ####

func _init():
	min_room_size = Vector2(25, 14)
	max_room_size = Vector2(30, 20)

#### VIRTUALS ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
