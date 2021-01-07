extends LevelChunck
class_name CompositeChunck

var room_scenes : Dictionary = {
	"TopLeft" : [preload("res://Scenes/Levels/InfiniteMode/ChunckRooms/CompositeRoom/Rooms/Test1.tscn")],
	"TopRight": [preload("res://Scenes/Levels/InfiniteMode/ChunckRooms/CompositeRoom/Rooms/Test2.tscn")]
}

#### ACCESSORS ####

func is_class(value: String): return value == "CompositeChunck" or .is_class(value)
func get_class() -> String: return "CompositeChunck"


#### BUILT-IN ####


#### VIRTUALS ####



#### LOGIC ####

## FUNCTION OVERRIDE ##
func initialize_chunck():
	var last_room = generate_rooms()
	
	if last_room != null:
		yield(last_room, "ready")
	
	set_chunck_bin(ChunckBin.new(self, 0))
	
	initialize_player_placement()
	
	for room in unplaced_rooms:
		place_room(room)
	
	generate_self()


## FUNCTION OVERRIDE ##
func generate_rooms() -> Node:
	var last_room = null
	var room_categories = room_scenes.values()
	for room_array in room_categories:
		var rdm_id = randi() % room_array.size()
		var room_scene = room_array[rdm_id]
		var room = room_scene.instance()
		last_room = room
		room.chunck = self
		$Rooms.call_deferred("add_child", room)
		unplaced_rooms.append(room)
	return last_room


#### INPUTS ####



#### SIGNAL RESPONSES ####
