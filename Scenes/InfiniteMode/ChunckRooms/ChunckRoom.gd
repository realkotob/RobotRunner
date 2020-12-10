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


# Generate the platforms in the room
func place_platforms():
	for couple in entry_exit_couple_array:
		# If one exit is close enough from the ground, ignore it (Doesn't need platform)
		if couple[1].y > room_rect.size.y - 3:
			continue
		 
		var jump_max_dist : Vector2 = GAME.JUMP_MAX_DIST
		var room_size = get_room_rect().size
		
		var nb_platform = int(round(room_size.x / jump_max_dist.x))
		var entry_point_cell = get_playable_entry_point(couple[0])
		var average_dist = int(room_size.x / nb_platform + 1) - 2
		
		var last_platform_end : Vector2 = entry_point_cell
		var platform_avg_y = entry_point_cell.y
		
		var stair_needed : bool = entry_point_cell.y - couple[1].y > GAME.JUMP_MAX_DIST.y
		
		# Platform generation, loop through every platfroms
		for i in range(nb_platform):
			var last_platform : bool = i == nb_platform - 1
			var platform_len = randi() % 2 + 2
			var platform_x_dist = average_dist + int(round(rand_range(-1.0, 1.0)))
			var rdm_y_offset = int(round(rand_range(-1.0, 1.0)))
			
			# Assure the first platform is close enough from the starting point
			# But far enough for it not to block the way
			# it should also always be a the level of the starting point or lower
			if i == 0: 
				platform_x_dist /= 2
				platform_x_dist = clamp(platform_x_dist, 2, INF)
				rdm_y_offset = clamp(rdm_y_offset, 0 , 1.0)
			
			var dist := Vector2(platform_x_dist, - i * int(stair_needed))
			var platform_start := Vector2(last_platform_end.x, platform_avg_y + rdm_y_offset) + dist
			
			# Assure the platform position is at least 4 tiles away from the ceiling & 2 away from the floor
			platform_start = Vector2(platform_start.x, clamp(platform_start.y, 4, room_rect.size.y - 3))
			
			# Loop through the cells resprensting a unit platform
			for j in range(platform_len):
				var current_x = platform_start.x + j
				var current_y = platform_start.y + 1
				
				# Assure the last platform is close enough from the exit
				if last_platform:
					current_y = clamp(current_y, couple[1].y + 1, couple[1].y + 2)
				
				if current_x > room_size.x - 3 or platform_start.y + 1 >= bin_map.size(): 
					continue
				else: 
					bin_map[current_y][current_x] = 1
			
			last_platform_end = platform_start + Vector2(platform_len, 0)


# Convert the theorical entry point in the concrete one
# ie the point from where the player can jump
func get_playable_entry_point(entry: Vector2) -> Vector2:
	var point = _cell_rel_to_abs(entry) + Vector2.LEFT
	var chunck_bin_map = chunck.get_chunck_bin().bin_map
	var chunck_size = ChunckBin.chunck_tile_size
	
	for i in range(chunck_size.y):
		if chunck_bin_map[point.y + i][point.x] == 1:
			return entry + Vector2(0, i - 1)
	return entry


# Convert a relative cell (relative to the room) to an absolute cell (relative to the whole chunck) 
func _cell_rel_to_abs(cell: Vector2) -> Vector2:
	return cell + room_rect.position

# Convert a absolute cell (relative to the whole chunck) to a relative cell (relative to the room)
func _cell_abs_to_rel(cell: Vector2, clamp_pos: bool = false) -> Vector2:
	var rel_cell = cell - room_rect.position
	if clamp_pos:
		rel_cell = Vector2(clamp(rel_cell.x, 0, room_rect.size.x - 1),
						   clamp(rel_cell.y, 0, room_rect.size.y - 1))
	return rel_cell

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
	entry_exit_couple_array.append([_cell_abs_to_rel(entry, true), _cell_abs_to_rel(exit, true)])
