extends Node2D
class_name LevelChunck

var chunck_bin : ChunckBin = null setget set_chunck_bin, get_chunck_bin

signal chunck_gen_finished
signal new_chunck_reached

var is_ready : bool = false
var next_start_pos_array := PoolVector2Array()

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
	
	place_wall_tiles()

#### LOGIC ####

# Place the tiles in the tilemap according the the bin_map value
func place_wall_tiles():
	var walls_tilemap = $Walls
	var wall_tile_id = walls_tilemap.get_tileset().find_tile_by_name("AutotileWall")
	var chunck_tile_size = ChunckBin.chunck_tile_size
	var bin_noise_map = chunck_bin.bin_map
	walls_tilemap.clear()
	
	for i in range(bin_noise_map.size()):
		for j in range(bin_noise_map[i].size()):
			var current_pos = Vector2(j, i)
			if bin_noise_map[i][j] == 1:
				walls_tilemap.set_cellv(current_pos, wall_tile_id)
	
	walls_tilemap.update_bitmask_region(Vector2.ZERO, chunck_tile_size)


#### VIRTUALS ####



#### INPUTS ####



#### SIGNAL RESPONSES ####


func on_body_entered(body: PhysicsBody2D):
	if body is Player:
		emit_signal("new_chunck_reached")
		$Area2D.queue_free()


func on_bin_map_changed():
	place_wall_tiles()

func on_automata_finished(final_pos: Vector2):
	next_start_pos_array.append(Vector2(0, final_pos.y))
	emit_signal("chunck_gen_finished")
