extends Node2D
class_name LevelChunck

var interactive_object_dict : Dictionary = {
	"RedTeleporter": preload("res://Scenes/InteractiveObjects/Teleports/Types/RedTeleporter.tscn"),
	"BlueTeleporter": preload("res://Scenes/InteractiveObjects/Teleports/Types/BlueTeleporter.tscn"),
	"GreenTeleporter": preload("res://Scenes/InteractiveObjects/Teleports/Types/GreenTeleporter.tscn")
}

const max_nb_room : int = 3

onready var walls_tilemap = $Walls

signal chunck_gen_finished
signal new_chunck_reached
signal every_automata_finished

var chunck_bin : ChunckBin = null setget set_chunck_bin, get_chunck_bin

var first_chunck : bool = false
var is_ready : bool = false
var starting_points : Array = []
var next_start_pos_array := PoolVector2Array()

var nb_automata : int = 2

var object_to_add : Array = []

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
	
	var last_room = generate_rooms()
	
	if last_room != null:
		yield(last_room, "ready")
	
	create_automatas()


#### LOGIC ####

func generate_self():
	place_rooms()
	place_wall_tiles()
	walls_tilemap.update_bitmask_region(Vector2.ZERO, ChunckBin.chunck_tile_size)
	place_slopes()
	
	generate_objects()
#	room_debug_visualizer()
	emit_signal("chunck_gen_finished")


func create_automatas() -> void:
	for point in starting_points:
		var automata = ChunckAutomata.new(chunck_bin, point)
		automata.name = "automata"
		automata.chunck = self
		call_deferred("add_child", automata)


func generate_rooms() -> Node:
	var rng = 1 if first_chunck else 0  #randi() % 4
	var room : Node = null
	if rng == 0:
		room = BigChunckRoom.new()
		room.name = "BigRoom"
		room.chunck = self
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
			room.name = "SmallRoom"
			room.chunck = self
			$Rooms.call_deferred("add_child", room)
	return room


# Place the rooms in the chunck by carving modifing the chunck bin accordingly to the room bin
func place_rooms():
	for room in $Rooms.get_children():
		
		# If no automata has entered this room, ignore it
		if room.entry_exit_couple_array.empty():
			continue
		
		var room_rect : Rect2 = room.get_room_rect()
		for i in range(room_rect.size.y):
			for j in range(room_rect.size.x):
				var pos = Vector2(j, i) + room_rect.position
				if room.bin_map.empty():
					continue
				else:
					var room_cell = room.bin_map[i][j]
					chunck_bin.bin_map[pos.y][pos.x] = room_cell
		
		object_to_add += room.interactive_objects


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


# Replace the staircases with slopes
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


# Take a cell, and return its slope type as defined in the SLOPE_TYPE enum
# Return -1 if the cell isn't a stair
func get_cell_stair_type(cell: Vector2) -> int:
	if !is_cell_wall(cell): return -1
	
	if is_cell_in_staircase(cell, true): return SLOPE_TYPE.ASCENDING
	if is_cell_in_staircase(cell, false): return SLOPE_TYPE.DESCENDING
	
	return -1


# Returns true if the cell is in a staircase
# ie it must be a stair itself and there must be a stair before of after it
func is_cell_in_staircase(cell: Vector2, ascending: bool) -> bool:
	if !is_cell_stair(cell, ascending): return false
	if ascending:
		return (is_cell_stair(cell + Vector2(-1, 1), true) && \
		!is_cell_stair(cell + Vector2.RIGHT, false)) or is_cell_slope(cell + Vector2(1, -1))
	else:
		return (is_cell_stair(cell + Vector2(1, 1), false) && \
		!is_cell_stair(cell + Vector2.LEFT, false)) or is_cell_slope(cell + Vector2(-1, -1))


# Returns true if the given cell is a slope
func is_cell_slope(cell: Vector2) -> bool:
	var slope_atlas = walls_tilemap.get_tileset().find_tile_by_name("SlopesAtlas")
	var tile_id = walls_tilemap.get_cell(cell.x, cell.y)
	return tile_id == slope_atlas


# Verify if the given cell is a stair or not
func is_cell_stair(cell: Vector2, ascending: bool) -> bool:
	if !is_cell_floor(cell): return false
	if ascending:
		return !is_cell_wall(cell + Vector2.LEFT) && is_cell_wall(cell + Vector2.RIGHT) && \
			is_cell_wall(cell + Vector2.DOWN)
	else:
		return is_cell_wall(cell + Vector2.LEFT) && \
			!is_cell_wall(cell + Vector2.RIGHT) && is_cell_wall(cell + Vector2.DOWN)


# Verify if the given cell is a floor or not
func is_cell_floor(cell: Vector2):
	if is_cell_outside_chunck(cell + Vector2.UP): return false
	return is_cell_wall(cell) && !is_cell_wall(cell + Vector2.UP)


# Verify if the given cell is a wall cell or not 
# (If their is any kind of wall tile on the cell, including slopes)
func is_cell_wall(cell: Vector2) -> bool:
	var bin_noise_map = chunck_bin.bin_map
	if is_cell_outside_chunck(cell): return false
	return bin_noise_map[cell.y][cell.x] == 1


# Verify if the given cell is outside the chunck or not
func is_cell_outside_chunck(cell: Vector2) -> bool:
	return cell.x < 0 or cell.y < 0 or\
	cell.x >= chunck_bin.chunck_tile_size.x or cell.y >= chunck_bin.chunck_tile_size.y


# Returns the rect of the room the given is in
# Returns an empty Rect2 if the given pos isn't in a room
func find_room_form_cell(cell: Vector2) -> ChunckRoom:
	for room in $Rooms.get_children():
		var room_rect = room.get_room_rect()
		if room_rect.has_point(cell): 
			return room
	return null


# Genrerate the interactive objects in the chunck 
func generate_objects():
	for element in object_to_add:
		if element is Node2D:
			call_deferred("add_child", element)
		elif element is Array:
			call_deferred("add_child", element[0])
			yield(element[0], "tree_entered")
			
			for i in range(element.size()):
				if i == 0: continue
				element[0].call_deferred("add_child", element[i])


#### VIRTUALS ####



#### INPUTS ####



#### DEBUG ####

# Display the room as a red semi transparant rectangle
func room_debug_visualizer():
	var tile_size = GAME.TILE_SIZE
	
	for room in $Rooms.get_children():
		var room_color_rect = ColorRect.new()
		var room_rect = room.get_room_rect()
		room_color_rect.name = "RoomColorRect"
		room_color_rect.set_frame_color(Color.red)
		room_color_rect.set_position(room_rect.position * tile_size)
		room_color_rect.set_size(room_rect.size * tile_size)
		room_color_rect.color.a = 0.5
		
		call_deferred("add_child", room_color_rect)
		
		# Display entries and exits
		for couple in room.entry_exit_couple_array:
			var entry_cell = couple[0]
			var exit_cell = couple[1]
			
			var entry_room_color_rect = ColorRect.new()
			entry_room_color_rect.name = "EntryColorRect"
			entry_room_color_rect.set_position(room_color_rect.get_position() + (entry_cell * tile_size))
			entry_room_color_rect.set_size(tile_size)
			entry_room_color_rect.set_frame_color(Color.azure)
			entry_room_color_rect.color.a = 0.5
			
			var exit_room_color_rect = ColorRect.new()
			exit_room_color_rect.name = "ExitColorRect"
			exit_room_color_rect.set_position(room_color_rect.get_position() + (exit_cell * tile_size))
			exit_room_color_rect.set_size(tile_size)
			entry_room_color_rect.set_frame_color(Color.violet)
			entry_room_color_rect.color.a = 0.5
			 
			call_deferred("add_child", entry_room_color_rect)
			call_deferred("add_child", exit_room_color_rect)


#### SIGNAL RESPONSES ####


func on_body_entered(body: PhysicsBody2D):
	if body is Player:
		emit_signal("new_chunck_reached")
		$Area2D.queue_free()


func on_bin_map_changed():
	pass

func on_automata_moved(_automata: ChunckAutomata, _to: Vector2):
	pass

func on_automata_forced_move_finished(_automata: ChunckAutomata, _pos: Vector2):
	pass

func on_automata_finished(final_pos: Vector2):
	next_start_pos_array.append(Vector2(0, final_pos.y))
	nb_automata -= 1
	
	if nb_automata == 0:
		emit_signal("every_automata_finished")
		generate_self()
