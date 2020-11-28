extends Node
class_name ChunckRoom

export var min_room_size := Vector2(8, 6)
export var max_room_size := Vector2(20, 9)

var room_rect := Rect2() setget set_room_rect, get_room_rect
var bin_map : Array = []

var chunck = null

var entry_exit_couple_array := Array()

#### ACCESSORS ####

func is_class(value: String): return value == "ChunckRoom" or .is_class(value)
func get_class() -> String: return "ChunckRoom"

func set_room_rect(value: Rect2): room_rect = value
func get_room_rect() -> Rect2: return room_rect


#### BUILT-IN ####

func _ready():
	generate()

#### LOGIC ####

func generate():
	var size_x = int(rand_range(min_room_size.x, max_room_size.x + 1))
	var size_y = int(rand_range(min_room_size.y, max_room_size.y + 1))
	var room_size = Vector2(size_x, size_y)
	
	var pos_x = int(rand_range(1, ChunckBin.chunck_tile_size.x - size_x - 1))
	var pos_y = int(rand_range(1, ChunckBin.chunck_tile_size.y - size_y - 1))
	var room_pos = Vector2(pos_x, pos_y)
	
	set_room_rect(Rect2(room_pos, room_size))
	create_bin_map()


# Fill the bin map with 0, and set its size a the same size as the room
func create_bin_map():
	var room_size = get_room_rect().size
	
	for _i in range(room_size.y):
		var line_array = Array()
		for _j in range(room_size.x):
			line_array.append(0)
		bin_map.append(line_array)


# Returns the top most couple of entry and exit
func get_top_entry_exit_couple() -> Array:
	var nb_couples = entry_exit_couple_array.size()
	if nb_couples == 0: return []
	elif nb_couples == 1: return entry_exit_couple_array[0]
	
	if entry_exit_couple_array[0][0].y < entry_exit_couple_array[1][0].y:
		return entry_exit_couple_array[0]
	else: 
		return entry_exit_couple_array[1]


#### VIRTUALS ####



#### INPUTS ####



#### SIGNAL RESPONSES ####

func on_automata_entered(entry: Vector2, exit: Vector2):
	entry_exit_couple_array.append([entry, exit])
