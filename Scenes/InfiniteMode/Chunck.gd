extends Node2D
class_name LevelChunck

const max_nb_room : int = 3

onready var walls_tilemap = $Walls

signal chunck_gen_finished
signal new_chunck_reached

var chunck_bin : ChunckBin = null setget set_chunck_bin, get_chunck_bin

var is_ready : bool = false
var next_start_pos_array := PoolVector2Array()

enum SLOPE_TYPE{
	ASCENDING,
	DESCENDING,
	CEILING_ASC,
	CEILING_DES
}

#### ACCESSORS ####

func is_class(value: String): return value == "LevelChunck" or .is_class(value)
func get_class() -> String: return "LevelChunck"

func set_chunck_bin(value: ChunckBin):
	if value != null:
		chunck_bin = value
		var _err = chunck_bin.connect("bin_map_changed", self, "on_bin_map_changed")

func get_chunck_bin() -> ChunckBin: return chunck_bin

#### BUILT-IN ####

func _ready():
	var _err = $Area2D.connect("body_entered", self, "on_body_entered")
	is_ready = true
	
	place_wall_tiles()
	var _last_room = generate_rooms()
	
#	DEBUG
#	if last_room != null:
#		yield(last_room, "ready")
#		room_debug_visualizer()

#### LOGIC ####

func generate_rooms() -> Node:
	var rng = randi() % 4
	var room : Node = null
	if rng == 0:
		room = BigChunckRoom.new()
		$Rooms.call_deferred("add_child", room)
	else:
		var nb_room = randi() % max_nb_room
		for i in range(nb_room):
			var next_room_half = SmallChunckRoom.ROOM_HALF.TOP_HALF
			
			if i == 0:
				room = SmallChunckRoom.new()
			else:
				var last_room_half = room.get_room_half()
				if last_room_half == next_room_half:
					next_room_half = SmallChunckRoom.ROOM_HALF.BOTTOM_HALF
			
			room = SmallChunckRoom.new(next_room_half)
			$Rooms.call_deferred("add_child", room)
		
	return room

# Display the room as a red semi transparant rectangle
func room_debug_visualizer():
	for room in $Rooms.get_children():
		var color_rect = ColorRect.new()
		var room_rect = room.get_room_rect()
		color_rect.set_frame_color(Color.red)
		color_rect.set_position(room_rect.position * GAME.TILE_SIZE)
		color_rect.set_size(room_rect.size * GAME.TILE_SIZE)
		color_rect.color.a = 0.5
		
		call_deferred("add_child", color_rect)


func place_rooms():
	for room in $Rooms.get_children():
		var room_rect : Rect2 = room.get_room_rect()
		for i in range(room_rect.size.y):
			for j in range(room_rect.size.x):
				var pos = Vector2(j, i) + room_rect.position
				chunck_bin.bin_map[pos.y][pos.x] = 0

# Place the tiles in the tilemap according the the bin_map value
func place_wall_tiles():
	var wall_tile_id = walls_tilemap.get_tileset().find_tile_by_name("AutotileWall")
	var chunck_tile_size = ChunckBin.chunck_tile_size
	var bin_noise_map = chunck_bin.bin_map
	walls_tilemap.clear()
	
	for i in range(chunck_tile_size.y):
		for j in range(chunck_tile_size.x):
			var current_pos = Vector2(j, i)
			if bin_noise_map[i][j] == 1:
				walls_tilemap.set_cellv(current_pos, wall_tile_id)


func place_slopes():
	var chunck_tile_size = ChunckBin.chunck_tile_size
	var slope_atlas = walls_tilemap.get_tileset().find_tile_by_name("SlopesAtlas")
	
	for i in range(chunck_tile_size.y):
		for j in range(chunck_tile_size.x):
			var cell = Vector2(j, i)
			match get_cell_stair_type(cell):
				-1 : continue
				SLOPE_TYPE.ASCENDING: 
					walls_tilemap.set_cell(cell.x, cell.y, slope_atlas,
											false, false, false, Vector2.ZERO)
					if is_cell_wall(cell + Vector2(-1, 1)) && is_cell_wall(cell + Vector2(0, 2)):
						walls_tilemap.set_cell(cell.x, cell.y + 1, slope_atlas,
											false, false, false, Vector2(1, 0))
				SLOPE_TYPE.DESCENDING: 
					walls_tilemap.set_cell(cell.x, cell.y, slope_atlas,
											false, false, false, Vector2(1, 2))
					if is_cell_wall(cell + Vector2(1, 1)) && is_cell_wall(cell + Vector2(0, 2)):
						walls_tilemap.set_cell(cell.x, cell.y +1, slope_atlas,
											false, false, false, Vector2(1, 3))
				_ : continue



func get_cell_stair_type(cell: Vector2) -> int:
	if !is_cell_wall(cell): return -1
	
	if is_cell_in_staircase(cell, true): return SLOPE_TYPE.ASCENDING
	if is_cell_in_staircase(cell, false): return SLOPE_TYPE.DESCENDING
	
	return -1


func is_cell_in_staircase(cell: Vector2, ascending: bool) -> bool:
	if !is_cell_stair(cell, ascending): return false
	if ascending:
		return (is_cell_stair(cell + Vector2(-1, 1), true) && \
		!is_cell_stair(cell + Vector2.RIGHT, false)) or is_cell_slope(cell + Vector2(1, -1))
	else:
		return (is_cell_stair(cell + Vector2(1, 1), false) && \
		!is_cell_stair(cell + Vector2.LEFT, false)) or is_cell_slope(cell + Vector2(-1, -1))


func is_cell_slope(cell: Vector2) -> bool:
	var slope_atlas = walls_tilemap.get_tileset().find_tile_by_name("SlopesAtlas")
	var tile_id = walls_tilemap.get_cell(cell.x, cell.y)
	return tile_id == slope_atlas


func is_cell_stair(cell: Vector2, ascending: bool) -> bool:
	if !is_cell_floor(cell): return false
	if ascending:
		return !is_cell_wall(cell + Vector2.LEFT) && is_cell_wall(cell + Vector2.RIGHT) && \
			is_cell_wall(cell + Vector2.DOWN)
	else:
		return is_cell_wall(cell + Vector2.LEFT) && \
			!is_cell_wall(cell + Vector2.RIGHT) && is_cell_wall(cell + Vector2.DOWN)


func is_cell_floor(cell: Vector2):
	if is_cell_outside_chunck(cell + Vector2.UP): return false
	return is_cell_wall(cell) && !is_cell_wall(cell + Vector2.UP)


func is_cell_wall(cell: Vector2) -> bool:
	var bin_noise_map = chunck_bin.bin_map
	if is_cell_outside_chunck(cell): return false
	return bin_noise_map[cell.y][cell.x] == 1


func is_cell_outside_chunck(cell: Vector2) -> bool:
	return cell.x < 0 or cell.y < 0 or\
	cell.x >= chunck_bin.chunck_tile_size.x or cell.y >= chunck_bin.chunck_tile_size.y

#### VIRTUALS ####



#### INPUTS ####



#### SIGNAL RESPONSES ####


func on_body_entered(body: PhysicsBody2D):
	if body is Player:
		emit_signal("new_chunck_reached")
		$Area2D.queue_free()


func on_bin_map_changed():
	place_wall_tiles()
	place_rooms()
	walls_tilemap.update_bitmask_region(Vector2.ZERO, ChunckBin.chunck_tile_size)
	place_slopes()


func on_automata_finished(final_pos: Vector2):
	next_start_pos_array.append(Vector2(0, final_pos.y))
	emit_signal("chunck_gen_finished")
