extends Node
class_name ChunckGenerator

var chunck_scene = preload("res://Scenes/InfiniteMode/Chunck.tscn")

const chunk_tile_size := Vector2(40, 23)

var noise : OpenSimplexNoise
var last_noise_map : Array
var bin_noise_map : Array

var noise_h_stretch_factor : float = 4
var nb_chunck : int = 0

export var debug : bool = false


#### ACCESSORS ####



#### BUILT-IN ####

func _ready():
	randomize()
#	stress_test(100)

#### LOGIC ####

func stress_test(nb_test : int):
	print("## CHUNCK GENERATION STRESS TEST STARTED ##")
	
	var time_before = OS.get_ticks_msec()
	var total_gen_nb : int = 0
	
	for i in range(nb_test):
		var first_chunck : bool = i == 0
		var gen_nb = generate_level_chunck(first_chunck)
		total_gen_nb += gen_nb
	
	var average_gen_nb : float = float(total_gen_nb) / nb_test
	var total_time = OS.get_ticks_msec() - time_before
	
	print(" ")
	print("Generating "  + String(nb_test) + " chuncks took " + String(total_time) + "ms")
	print("Average numbers of generation per chunck: " + String(average_gen_nb))
	print("Average time per generation: " + String(float(total_time) / total_gen_nb) + "ms")
	print("Average time per chunck: " + String(float(total_time) / nb_test) + "ms")
	print(" ")
	print("## CHUNCK GENERATION STRESS TEST FINISHED ##")


# Generate a chunck of map, from a simplex noise, at the size of the playable area
# Return the number of generations it took to generate the chunck 
func generate_level_chunck(is_first_chunck: bool = false) -> int:
	
	var next_starting_points = unit_chunck_gen(is_first_chunck)
	var i = 1
	
	var too_few_entries : int = 0
	var too_few_exits : int = 0
	var too_few_path : int = 0
	
	var gen_state = $ChunckChecker.is_chunck_valid(bin_noise_map, next_starting_points, 2)
	
	while gen_state != ChunckChecker.GEN_STATE.SUCCESS:
		match gen_state :
			ChunckChecker.GEN_STATE.TOO_FEW_STARTING_POINT: too_few_entries += 1
			ChunckChecker.GEN_STATE.TOO_FEW_EXITS: too_few_exits += 1
			ChunckChecker.GEN_STATE.TOO_FEW_PATHS: too_few_path += 1 
		
		next_starting_points = unit_chunck_gen(is_first_chunck)
		i += 1
		gen_state = $ChunckChecker.is_chunck_valid(bin_noise_map, next_starting_points, 2)
	
	last_noise_map = bin_noise_map
	
	if debug:
		print_bin_array(bin_noise_map)
		print(" ")
		print("Took " + String(i) +  " generations")
		print(String(too_few_entries) + " generation failed caused by too few entries")
		print(String(too_few_exits) + " generation failed caused by too few exits")
		print(String(too_few_path) + " generation failed caused by too few paths")
	
	return i


# Generate one chunck (Used to be called in a loop, until one chunck is valid)
func unit_chunck_gen(first_chunck: bool = false) -> PoolVector2Array:
	generate_rdm_noise()
	bin_noise_map = noise_to_bin()
	var next_starting_points := PoolVector2Array()
	
	if first_chunck:
		next_starting_points = get_starting_points_cell_pos()
	else:
		next_starting_points = $ChunckChecker.get_next_starting_points(last_noise_map)
	
	return next_starting_points


# Find the starting points, convert their position as cells and returns it in a PoolVector2Array
func get_starting_points_cell_pos() -> PoolVector2Array:
	var starting_points = get_tree().get_nodes_in_group("StartingPoint")
	var starting_point_cells := PoolVector2Array()
	
	var wall_tilemap = get_tree().get_current_scene().find_node("Walls")
	
	for point in starting_points:
		var cell = wall_tilemap.world_to_map(point.get_global_position())
		starting_point_cells.append(cell)
	
	return starting_point_cells


# Generate a new random noise from a random seed
func generate_rdm_noise():
	noise = OpenSimplexNoise.new()
	
	noise.set_seed(randi())
	noise.set_octaves(4)
	noise.set_period(8.0)


# Generate a 2D array containing binary values based on a simplex noise
# a value < 0 will fill the cell with a 0, a value > 0 will fill the cell with a 1 
func noise_to_bin() -> Array:
	var bin_map := Array()
	
	for i in range(chunk_tile_size.y):
		var line_array := Array()
		for j in range(chunk_tile_size.x):
			var bin_value = int(noise.get_noise_2d(i, j / noise_h_stretch_factor) < 0)
			line_array.append(bin_value)
		bin_map.append(line_array)
	
	return bin_map


# Print the givne binary array
func print_bin_array(bin_array: Array):
	for line_array in bin_array:
		var line : String = ""
		for nb in line_array:
			line += String(nb)
		print(line)


# Place a new chunck of level
func place_level_chunck():
	var chunck_container_node : Node2D = owner.find_node("ChunckContainer")
	var first_chunck : bool = chunck_container_node.get_child_count() == 0
	var __ = generate_level_chunck(first_chunck)
	
	var new_chunck = chunck_scene.instance()
	new_chunck.set_position(GAME.TILE_SIZE * Vector2(chunk_tile_size.x, 0) * nb_chunck)
	new_chunck.set_name("LevelChunck" + String(nb_chunck))
	
	nb_chunck += 1
	
	if chunck_container_node.get_child_count() > 1:
		var chunck_to_delete = chunck_container_node.get_child(0)
		chunck_to_delete.queue_free()
		if new_chunck != null:
			yield(new_chunck, "tree_exited")
	
	chunck_container_node.add_child(new_chunck)
	
	if !new_chunck.is_ready:
		yield(new_chunck, "ready")
	
	place_wall_tiles(new_chunck.get_node("Walls"))
	var _err = new_chunck.connect("new_chunck_reached", self, "on_new_chunck_reached")


# Place the tiles in the tilemap according the the bin_map value
func place_wall_tiles(tilemape_node: TileMap):
	var origin_tile = tilemape_node.world_to_map(self.global_position)
	var wall_tile_id = tilemape_node.get_tileset().find_tile_by_name("AutotileWall")
	
	for i in range(bin_noise_map.size()):
		for j in range(bin_noise_map[i].size()):
			var current_pos = origin_tile + Vector2(j, i)
			if bin_noise_map[i][j] == 1:
				tilemape_node.set_cellv(current_pos, wall_tile_id)
	
	tilemape_node.update_bitmask_region(origin_tile, origin_tile + chunk_tile_size)


#### VIRTUALS ####



#### INPUTS ####

func _input(_event):
	if Input.is_action_just_pressed("LevelChunckGen"):
		place_level_chunck()

#### SIGNAL RESPONSES ####

func on_new_chunck_reached():
	place_level_chunck()
