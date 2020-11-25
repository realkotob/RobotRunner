extends Object
class_name ChunckBin

const chunck_tile_size := Vector2(40, 23)

var bin_map : Array setget set_bin_map, get_bin_map
var entry_exit_couple_array : Array = []

signal bin_map_changed

#### ACCESSORS ####

func is_class(value: String): return value == "" or .is_class(value)
func get_class() -> String: return ""

func set_bin_map(map: Array): 
	if map != null:
		bin_map = map
		emit_signal("bin_map_changed")

func get_bin_map() -> Array: return bin_map

#### BUILT-IN ####

func _init():
	generate_filled_bin_map()

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


func erase_automata_pos(pos: Vector2):
	bin_map[pos.y][pos.x] = 0
	if pos.y - 1 >= 0:
		bin_map[pos.y - 1][pos.x] = 0

	if pos.x + 1 < chunck_tile_size.x:
		bin_map[pos.y][pos.x + 1] = 0
		if pos.y - 1 >= 0:
			bin_map[pos.y - 1][pos.x + 1] = 0


func refine_chunck():
	for i in range(chunck_tile_size.y):
		for j in range(chunck_tile_size.x):
			if i == 0 or j == 0 or i == chunck_tile_size.y - 1 or j == chunck_tile_size.x -1:
				continue
			var wall_neighbours : int = count_wall_neighbours(Vector2(j, i)) 
			if bin_map[i][j] == 1 && wall_neighbours <= 1:
				bin_map[i][j] = 0


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


#### VIRTUALS ####



#### INPUTS ####



#### SIGNAL RESPONSES ####

func on_automata_moved(to_pos: Vector2):
	erase_automata_pos(to_pos)

func on_automata_finished(_pos: Vector2):
	refine_chunck()
	emit_signal("bin_map_changed")
