extends Node2D
class_name LevelChunck

var chunck_bin : ChunckBin = null setget set_chunck_bin, get_chunck_bin

signal new_chunck_reached

var is_ready : bool = false

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
	var origin_tile = walls_tilemap.world_to_map(self.global_position)
	var wall_tile_id = walls_tilemap.get_tileset().find_tile_by_name("AutotileWall")
	var chunck_tile_size = ChunckBin.chunck_tile_size
	var bin_noise_map = chunck_bin.bin_map
	walls_tilemap.clear()
	
	for i in range(bin_noise_map.size()):
		for j in range(bin_noise_map[i].size()):
			var current_pos = origin_tile + Vector2(j, i)
			if bin_noise_map[i][j] == 1:
				walls_tilemap.set_cellv(current_pos, wall_tile_id)
	
	walls_tilemap.update_bitmask_region(origin_tile, origin_tile + chunck_tile_size)



#### VIRTUALS ####



#### INPUTS ####



#### SIGNAL RESPONSES ####


func on_body_entered(body: PhysicsBody2D):
	if body is Player:
		emit_signal("new_chunck_reached")
		$Area2D.queue_free()


func on_bin_map_changed():
	place_wall_tiles()
