extends Object
class_name ChunckBin

const chunck_tile_size := Vector2(40, 23)

var chunck = null
var bin_map : Array setget set_bin_map, get_bin_map
var entry_exit_couple_array : Array = []

#### ACCESSORS ####

func is_class(value: String): return value == "" or .is_class(value)
func get_class() -> String: return ""

func set_bin_map(map: Array): bin_map = map
func get_bin_map() -> Array: return bin_map

#### BUILT-IN ####

func _init(chunck_ref):
	generate_filled_bin_map()
	chunck = chunck_ref

#### LOGIC ####

# Generate a bin_map filed with 1
func generate_filled_bin_map() -> void:
	bin_map = []
	for _i in range(chunck_tile_size.y):
		var line_array := Array()
		for _j in range(chunck_tile_size.x):
			line_array.append(1)
		bin_map.append(line_array)


# Print the given binary array
func print_bin_map():
	for line_array in bin_map:
		var line : String = ""
		for nb in line_array:
			line += String(nb)
		print(line)


# Erase the 2*2 tiles at the given automata position
func erase_automata_pos(pos: Vector2):
	for i in range(2):
		for j in range(2):
			var current_pos = pos + Vector2(j, i)
			if is_cell_outside_chunck(current_pos): 
				continue
			bin_map[current_pos.y][current_pos.x] = 0


# Removes 1 tile large walls if its not on the border of the chunck or a room wall
func refine_chunck():
	for i in range(chunck_tile_size.y):
		for j in range(chunck_tile_size.x):
			var cell = Vector2(j, i)
			
			if is_cell_a_chunck_border(cell) or is_cell_inside_room_walls(cell):
				continue
			
			var wall_neighbours : int = count_wall_neighbours(cell) 
			
			if bin_map[i][j] == 1 && wall_neighbours <= 1:
				bin_map[i][j] = 0
				
				# Suppress the tile right above this one if its also a single tile
				if i - 1 > 0 && bin_map[i - 1][j] == 1 && \
				count_wall_neighbours(cell + Vector2.UP) <= 1:
					bin_map[i - 1][j] = 0


# Check if the given cell is inside the room, including its walls
func is_cell_inside_room_walls(cell: Vector2) -> bool:
	for room in chunck.get_rooms():
		var top_left = room.get_top_left() - Vector2.ONE
		var room_walls_rect := Rect2(top_left, room.get_room_rect().size + Vector2(2, 2))
		if room_walls_rect.has_point(cell):
			return true
	return false


func count_wall_neighbours(pos: Vector2) -> int:
	var nb_wall_neighbour : int = 0
	if pos.x + 1 < chunck_tile_size.x && bin_map[pos.y][pos.x + 1] == 1:
		nb_wall_neighbour += 1
	if pos.x - 1 > 0 && bin_map[pos.y][pos.x - 1] == 1:
		nb_wall_neighbour += 1
	if pos.y + 1 < chunck_tile_size.y && bin_map[pos.y + 1][pos.x] == 1:
		nb_wall_neighbour += 1
	if pos.y - 1 > 0 && bin_map[pos.y - 1][pos.x] == 1:
		nb_wall_neighbour += 1
	return nb_wall_neighbour


# Verify if the given cell is outside the chunck or not
func is_cell_outside_chunck(cell: Vector2) -> bool:
	return cell.x < 0 or cell.y < 0 or \
	cell.x >= chunck_tile_size.x or cell.y >= chunck_tile_size.y


func is_cell_a_chunck_border(cell: Vector2) -> bool :
	return cell.x == 0 or cell.y == 0 or \
	cell.x == chunck_tile_size.x - 1 or cell.y == chunck_tile_size.y - 1


#### VIRTUALS ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
