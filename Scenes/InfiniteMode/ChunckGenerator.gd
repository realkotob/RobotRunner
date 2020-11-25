extends Node
class_name ChunckGenerator

var chunck_scene = preload("res://Scenes/InfiniteMode/Chunck.tscn")

var noise : OpenSimplexNoise

var noise_h_stretch_factor : float = 10
var nb_chunck : int = 0

export var debug : bool = false

var automata_array : Array = []


#### ACCESSORS ####



#### BUILT-IN ####

func _ready():
	randomize()
	place_level_chunck()
#	stress_test(10)

#### LOGIC ####

func stress_test(nb_test : int):
	print("## CHUNCK GENERATION STRESS TEST STARTED ##")
	var meta_gen_data = MetaChunckGenData.new()
	var time_before = OS.get_ticks_msec()
	meta_gen_data.nb_test = nb_test
	
	for i in range(nb_test):
		var first_chunck : bool = i == 0
		var gen_data = generate_level_chunck(first_chunck)
		gen_data.free()
	
	var total_time = OS.get_ticks_msec() - time_before
	
	meta_gen_data.total_time = total_time
	meta_gen_data.print_data()
	meta_gen_data.free()
	print("## CHUNCK GENERATION STRESS TEST FINISHED ##")


# Generate a chunck of map, from a simplex noise, at the size of the playable area
# Return the number of generations it took to generate the chunck 
func generate_level_chunck(is_first_chunck: bool = false) -> ChunckBin:
	var starting_points := get_starting_points_cell_pos() if is_first_chunck else PoolVector2Array()
	var chunck_bin = ChunckBin.new()

	create_automatas(chunck_bin, starting_points)
	
	if debug:
		chunck_bin.print_bin_map()
	
	return chunck_bin


func create_automatas(chunck_bin: ChunckBin, starting_points: PoolVector2Array) -> void:
	automata_array = []
	for point in starting_points:
		var automata = ChunckAutomata.new(chunck_bin, point)
		automata_array.append(automata)


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


## Generate a 2D array containing binary values based on a simplex noise
## a value < 0 will fill the cell with a 0, a value > 0 will fill the cell with a 1 
#func noise_to_bin() -> Array:
#	var bin_map := Array()
#
#	for i in range(chunck_tile_size.y):
#		var line_array := Array()
#		for j in range(chunck_tile_size.x):
#			var bin_value = int(noise.get_noise_2d(i, j / noise_h_stretch_factor) < 0)
#			line_array.append(bin_value)
#		bin_map.append(line_array)
#
#	return bin_map



# Place a new chunck of level
func place_level_chunck():
	var chunck_container_node : Node2D = owner.find_node("ChunckContainer")
	var first_chunck : bool = chunck_container_node.get_child_count() == 0
	var chunck_bin = generate_level_chunck(first_chunck)
	var chunck_tile_size = ChunckBin.chunck_tile_size
	
	var new_chunck = chunck_scene.instance()
	new_chunck.set_position(GAME.TILE_SIZE * Vector2(chunck_tile_size.x, 0) * nb_chunck)
	new_chunck.set_name("LevelChunck" + String(nb_chunck))
	
	nb_chunck += 1
	
	if chunck_container_node.get_child_count() > 2:
		var chunck_to_delete = chunck_container_node.get_child(0)
		chunck_to_delete.queue_free()
	
	new_chunck.set_chunck_bin(chunck_bin)
	chunck_container_node.call_deferred("add_child", new_chunck)
	
	if !new_chunck.is_ready:
		yield(new_chunck, "ready")
	
	var _err = new_chunck.connect("new_chunck_reached", self, "on_new_chunck_reached")
	
	for automata in automata_array:
		new_chunck.call_deferred("add_child", automata)




#### VIRTUALS ####



#### INPUTS ####


#### SIGNAL RESPONSES ####

func on_new_chunck_reached():
	place_level_chunck()
