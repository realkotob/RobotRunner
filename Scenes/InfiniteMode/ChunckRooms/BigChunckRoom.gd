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


#### SIGNAL RESPONSES ####

func on_automata_entered(entry: Vector2, exit: Vector2):
	.on_automata_entered(entry, exit)
	
	if entry_exit_couple_array.size() == 2:
		place_platforms()
