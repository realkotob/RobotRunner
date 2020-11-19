extends Node

var chunck_scene = preload("res://Scenes/InfiniteMode/Chunck.tscn")

const chunk_tile_size := Vector2(41, 21)

var noise : OpenSimplexNoise
var bin_noise_map : Array

var noise_h_stretch_factor : float = 4
var nb_chunck : int = 0

onready var astar = AStar.new()

export var debug : bool = false



#### ACCESSORS ####



#### BUILT-IN ####



#### LOGIC ####


# Generate a chunck of map, from a simplex noise, at the size of the playable area
func generate_level_chunck():
	generate_rdm_noise()
	bin_noise_map = noise_to_bin()
	
	if debug :
		print_bin_array(bin_noise_map)


func generate_rdm_noise():
	noise = OpenSimplexNoise.new()
	
	noise.set_seed(randi())
	noise.set_octaves(4)
	noise.set_period(8.0)


# Generate a 2D array containing binary values based on a simplex noise
# a value < 0 will fill the cell with a 0, a value > 0 will fill the cell with a 1 
func noise_to_bin() -> Array:
	#warning-ignore:unassigned_variable
	var bin_map : Array
	
	for i in range(chunk_tile_size.y):
		#warning-ignore:unassigned_variable
		var line_array : Array
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
	generate_level_chunck()
	var chunck_container_node : Node2D = owner.find_node("ChunckContainer")
	
	var new_chunck = chunck_scene.instance()
	new_chunck.set_position(GAME.TILE_SIZE * Vector2(chunk_tile_size.x, 0) * nb_chunck)
	new_chunck.set_name("LevelChunck" + String(nb_chunck))
	
	nb_chunck += 1
	
	if chunck_container_node.get_child_count() > 1:
		chunck_container_node.get_child(0).queue_free()
	
	chunck_container_node.add_child(new_chunck)
	
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
