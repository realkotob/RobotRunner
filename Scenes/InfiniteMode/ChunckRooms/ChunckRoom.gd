extends Node
class_name ChunckRoom

export var min_room_size := Vector2(8, 6)
export var max_room_size := Vector2(20, 9)

var room_rect := Rect2() setget set_room_rect, get_room_rect

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

#### VIRTUALS ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
