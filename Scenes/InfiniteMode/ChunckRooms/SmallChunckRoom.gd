extends ChunckRoom
class_name SmallChunckRoom

enum ROOM_HALF{
	UNDEFINED,
	TOP_HALF,
	BOTTOM_HALF
}

var room_half : int = ROOM_HALF.UNDEFINED setget set_room_half, get_room_half

#### ACCESSORS ####

func is_class(value: String): return value == "SmallChunckRoom" or .is_class(value)
func get_class() -> String: return "SmallChunckRoom"

func set_room_half(value: int): room_half = value
func get_room_half() -> int: return room_half

#### BUILT-IN ####

func _init(half: int = ROOM_HALF.UNDEFINED):
	if half != ROOM_HALF.UNDEFINED:
		room_half = half
	else:
		room_half = randi() % 2 + 1

#### LOGIC ####

# OVERIDE
func generate():
	# The room half isn't defined, so the room takes a random position
	if room_half == ROOM_HALF.UNDEFINED:
		.generate()
		return
	
	var size_x = int(rand_range(min_room_size.x, max_room_size.x + 1))
	var size_y = int(rand_range(min_room_size.y, max_room_size.y + 1))
	var room_size = Vector2(size_x, size_y)
	
	# Default values: the room half is considered to be BOTTOM_HALF until proven wrong
	var min_y_pos = ChunckBin.chunck_tile_size.y / 2 + 2 
	var max_y_pos = ChunckBin.chunck_tile_size.y - size_y - 1
	
	# Min and max values if the room half is TOP_HALF
	if room_half == ROOM_HALF.TOP_HALF:
		max_y_pos = ChunckBin.chunck_tile_size.y / 2  - size_y
		min_y_pos = 1
	
	var pos_x = int(rand_range(1, ChunckBin.chunck_tile_size.x - size_x - 1))
	var pos_y = int(rand_range(min_y_pos, max_y_pos))
	var room_pos = Vector2(pos_x, pos_y)
	
	set_room_rect(Rect2(room_pos, room_size))
	create_bin_map()


#### VIRTUALS ####



#### INPUTS ####



#### SIGNAL RESPONSES ####

func on_every_automata_finished():
	generate_liquids()
