extends Node
class_name ChunckGenerator

onready var chunck_container_node : Node2D = owner.find_node("ChunckContainer")

var normal_chunck_scene = preload("res://Scenes/Levels/InfiniteMode/Chuncks/Chunck.tscn")
var special_chunck_scene_array = [
	preload("res://Scenes/Levels/InfiniteMode/Chuncks/CrossChunck.tscn")
]

var nb_chunck : int = 0
var is_generating : bool = false

export var debug : bool = false

#### ACCESSORS ####



#### BUILT-IN ####

func _ready():
	randomize()
	place_level_chunck()
#	stress_test(10)


#### LOGIC ####

func stress_test(nb_test : int):
	print("## CHUNCK GENERATION STRESS TEST STARTED ##")
	var time_before = OS.get_ticks_msec()
	
	for _i in range(nb_test):
		place_level_chunck()
		yield(place_level_chunck(), "completed")
	
	var total_time = OS.get_ticks_msec() - time_before
	
	print("Generating " + String(nb_test) + " took " + String(total_time) + "ms")
	print("Average generation time : " + String(total_time / float(nb_test)) + "ms")
	print("## CHUNCK GENERATION STRESS TEST FINISHED ##")


# Generate a chunck of map, from a simplex noise, at the size of the playable area
# Return the number of generations it took to generate the chunck 
func generate_chunck_binary() -> ChunckBin:
	var chunck_bin = ChunckBin.new()
	
	if debug:
		chunck_bin.print_bin_map()
	
	return chunck_bin


# Generate a chunck
# Have a chance on 4 to create a Cross chunck
func generate_chunck() -> LevelChunck:
	var last_chunck = get_last_chunck()
	
	var rng = randi() % 4
	if last_chunck is SpecialChunck or last_chunck == null:
		rng = randi() % 3
	
	var chunck : LevelChunck
	var rdm_id
	
	if rng == 3:
		rdm_id = randi() % special_chunck_scene_array.size()
		chunck = special_chunck_scene_array[rdm_id].instance()
	else:
		chunck = normal_chunck_scene.instance()
	
	return chunck


# Retruns the last chunck created
func get_last_chunck() -> Node:
	var nb_chuncks = chunck_container_node.get_child_count()
	if nb_chuncks == 0: return null
	else: return chunck_container_node.get_child(nb_chuncks - 1)


# Find the starting points, convert their position as cells and returns it in a PoolVector2Array
func get_starting_points_cell_pos() -> PoolVector2Array:
	var starting_points = get_tree().get_nodes_in_group("StartingPoint")
	var starting_point_cells := PoolVector2Array()
	
	var wall_tilemap = get_tree().get_current_scene().find_node("Walls")
	
	for point in starting_points:
		var cell = wall_tilemap.world_to_map(point.get_global_position())
		starting_point_cells.append(cell)
	
	return starting_point_cells


# Place a new chunck of level
func place_level_chunck(invert_player_pos : bool = false) -> LevelChunck:
	is_generating = true
	var starting_points := PoolVector2Array()
	var first_chunck : bool = chunck_container_node.get_child_count() == 0
	
	if first_chunck:
		starting_points = get_starting_points_cell_pos()
	else:
		var last_child_id = chunck_container_node.get_child_count()
		var last_chunck = chunck_container_node.get_child(last_child_id - 1)
		starting_points = last_chunck.next_start_pos_array
	
	var chunck_bin = generate_chunck_binary()
	var chunck_tile_size = ChunckBin.chunck_tile_size
	
	var new_chunck = generate_chunck()
	new_chunck.starting_points = starting_points
	new_chunck.set_position(GAME.TILE_SIZE * Vector2(chunck_tile_size.x, 0) * nb_chunck)
	new_chunck.set_name("LevelChunck" + String(nb_chunck))
	new_chunck.invert_player_placement = invert_player_pos
	
	if nb_chunck == 0:
		new_chunck.first_chunck = true
	
	nb_chunck += 1
	
	if chunck_container_node.get_child_count() > 2:
		var chunck_to_delete = chunck_container_node.get_child(0)
		chunck_to_delete.queue_free()
		yield(chunck_to_delete, "tree_exited")
	
	new_chunck.set_chunck_bin(chunck_bin)
	chunck_container_node.call_deferred("add_child", new_chunck)
	
	if !new_chunck.is_ready:
		yield(new_chunck, "ready")
	
	var _err = new_chunck.connect("new_chunck_reached", self, "on_new_chunck_reached")
	
	is_generating = false
	return new_chunck


#### VIRTUALS ####


#### INPUTS ####


#### SIGNAL RESPONSES ####

func on_new_chunck_reached(invert_player_pos: bool):
	if !is_generating:
		place_level_chunck(invert_player_pos)
