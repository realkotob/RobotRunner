extends LevelChunck
class_name BigRoomChunck

#### ACCESSORS ####

func is_class(value: String): return value == "BigRoomChunck" or .is_class(value)
func get_class() -> String: return "BigRoomChunck"


#### BUILT-IN ####


#### VIRTUALS ####



#### LOGIC ####

func generate_rooms() -> Node:
	var room = BigChunckRoom.new()
	room.name = "BigRoom"
	room.chunck = self
	$Rooms.call_deferred("add_child", room)
	unplaced_rooms.append(room)
	return room

#### INPUTS ####



#### SIGNAL RESPONSES ####
