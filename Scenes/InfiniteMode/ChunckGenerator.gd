extends Node
class_name ChunckGenerator

var chunck_scene = preload("res://Scenes/InfiniteMode/Chunck.tscn")

const chunk_tile_size := Vector2(40, 23)

var noise : OpenSimplexNoise
var last_noise_map : Array
var bin_noise_map : Array

var noise_h_stretch_factor : float = 10
var nb_chunck : int = 0

export var debug : bool = false


#### ACCESSORS ####



#### BUILT-IN ####

func _ready():
	randomize()
	stress_test(10)

#### LOGIC ####

func stress_test(nb_test : int):
	print("## CHUNCK GENERATION STRESS TEST STARTED ##")
	
	var time_before = OS.get_ticks_msec()
	
	var meta_gen_data = MetaChunckGenData.new()
	meta_gen_data.nb_test = nb_test
	
	for i in range(nb_test):
		var first_chunck : bool = i == 0
		var gen_data = generate_level_chunck(first_chunck)
		meta_gen_data.generations += gen_data.generations
		meta_gen_data.too_few_entries += gen_data.too_few_entries
		meta_gen_data.too_few_exits += gen_data.too_few_exits
		meta_gen_data.too_few_path += gen_data.too_few_path

	var total_time = OS.get_ticks_msec() - time_before
	
	meta_gen_data.total_time = total_time
	meta_gen_data.print_data()
	print("## CHUNCK GENERATION STRESS TEST FINISHED ##")


# Generate a chunck of map, from a simplex noise, at the size of the playable area
# Return the number of generations it took to generate the chunck 
func generate_level_chunck(is_first_chunck: bool = false) -> ChunckGenData:
	var next_starting_points = unit_chunck_gen(is_first_chunck)
	var chunck_gen_data = ChunckGenData.new()
	
	var gen_state = $ChunckChecker.is_chunck_valid(bin_noise_map, next_starting_points, 2)
	
	while gen_state != ChunckChecker.GEN_STATE.SUCCESS:
		match gen_state :
			ChunckChecker.GEN_STATE.TOO_FEW_STARTING_POINT: chunck_gen_data.too_few_entries += 1
			ChunckChecker.GEN_STATE.TOO_FEW_EXITS: chunck_gen_data.too_few_exits += 1
			ChunckChecker.GEN_STATE.TOO_FEW_PATHS: chunck_gen_data.too_few_path += 1 
		
		next_starting_points = unit_chunck_gen(is_first_chunck)
		chunck_gen_data.generations += 1
		gen_state = $ChunckChecker.is_chunck_valid(bin_noise_map, next_starting_points, 2)
	
	last_noise_map = bin_noise_map
	
	if debug:
		print_bin_array(bin_noise_map)
		chunck_gen_data.print_data()
	
	return chunck_gen_data


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
	noise.set_period(3.0)
	noise.set_lacunarity(2.0)
	noise.set_persistence(0.5)


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
