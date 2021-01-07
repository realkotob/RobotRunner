extends Node2D
class_name ChunckGenerator

var chunck_scene_dict : Dictionary = {
	"Normal" : preload("res://Scenes/Levels/InfiniteMode/Chuncks/Chunck.tscn"),
	"Cross" : preload("res://Scenes/Levels/InfiniteMode/Chuncks/CrossChunck.tscn"),
	"BigRoom" : preload("res://Scenes/Levels/InfiniteMode/Chuncks/BigRoomChunck.tscn")
}

var nb_chunck : int = 0
var is_generating : bool = false

var last_chunck_scene : PackedScene = null

export var debug_dict : Dictionary = {
	"only_normal_chunck" : false,
	"forced_chunck_type" : ""
}

export var debug : bool = false

signal first_chunck_ready

#### ACCESSORS ####

func is_class(value: String): return value == "ChunckGenerator" or .is_class(value)
func get_class() -> String: return "ChunckGenerator"


#### BUILT-IN ####

func _ready() -> void:
	if GAME.get_current_seed() == 0:
		randomize()
		EVENTS.emit_signal("seed_change_query", randi())
	
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


# Generate a random chunck
# You can't have the same chunck two times in a row, unless its a Normal chunck 
func generate_chunck(first: bool = false) -> LevelChunck:
	if first:
		return chunck_scene_dict["Normal"].instance()
	
	# Forced chunck type for debug purpose
	if debug:
		if debug_dict["only_normal_chunck"]:
			return chunck_scene_dict["Normal"].instance()
		elif debug_dict["forced_chunck_type"] in chunck_scene_dict.keys():
			return chunck_scene_dict[debug_dict["forced_chunck_type"]].instance()
	
	# Pick a random special chunck, but different from the last one if it wasn't a normal one
	var possible_chunck = chunck_scene_dict.values().duplicate()
	if last_chunck_scene != chunck_scene_dict["Normal"]:
		possible_chunck.erase(last_chunck_scene)
	
	var rdm_id = randi() % possible_chunck.size()
	var chose_chunck_scene = possible_chunck[rdm_id]
	
	var chunck = chose_chunck_scene.instance()
	last_chunck_scene = chose_chunck_scene
	
	return chunck


# Retruns the last chunck created
func get_last_chunck() -> Node:
	var nb_chuncks = get_child_count()
	if nb_chuncks == 0: return null
	else: return get_child(nb_chuncks - 1)


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
	var first_chunck : bool = get_child_count() == 0
	
	if first_chunck:
		starting_points = get_starting_points_cell_pos()
	else:
		var last_child_id = get_child_count()
		var last_chunck = get_child(last_child_id - 1)
		starting_points = last_chunck.next_start_pos_array
	
	var chunck_tile_size = ChunckBin.chunck_tile_size
	
	var new_chunck = generate_chunck(nb_chunck == 0)
	new_chunck.starting_points = starting_points
	new_chunck.set_position(GAME.TILE_SIZE * Vector2(chunck_tile_size.x, 0) * nb_chunck)
	new_chunck.set_name("LevelChunck" + String(nb_chunck))
	new_chunck.invert_player_placement = invert_player_pos
	
	if nb_chunck == 0:
		new_chunck.first_chunck = true
	
	nb_chunck += 1
	
	if get_child_count() > 2:
		var chunck_to_delete = get_child(0)
		chunck_to_delete.queue_free()
		yield(chunck_to_delete, "tree_exited")
	
	call_deferred("add_child", new_chunck)
	
	if !new_chunck.is_ready:
		yield(new_chunck, "ready")
	
	var _err = new_chunck.connect("new_chunck_reached", self, "on_new_chunck_reached")
	
	is_generating = false
	
	if first_chunck:
		emit_signal("first_chunck_ready")
	
	return new_chunck


#### VIRTUALS ####


#### INPUTS ####


#### SIGNAL RESPONSES ####

func on_new_chunck_reached(invert_player_pos: bool):
	if !is_generating:
		place_level_chunck(invert_player_pos)


func _on_automata_crossed(_entry: Vector2, _exit: Vector2):
	pass
