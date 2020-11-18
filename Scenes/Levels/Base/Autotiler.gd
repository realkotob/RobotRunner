extends Node
class_name Autotiler

## A class for getting, when placing autotile by code, the correct texture from the autotile

export var debug : bool = false

onready var grid_node = get_parent()

#warning-ignore:integer_division

#### ACCESSORS ####

func is_class(value: String):
	return value == "" or .is_class(value)

func get_class() -> String:
	return ""

#### BUILT-IN ####


#### LOGIC ####


# update the sprites of every tile possesing an autotile
func update_grid_autotiling():
	var tiles_array = grid_node.get_tile_array()
	for tile in tiles_array:
		var tile_type = tile.get_tile_type()
		if tile_type.get_tileset() != null:
			update_tile_sprite(tile, tile_type)


# Update the sprite of a single tile
func get_tile_texture_pos(tile: Tile, new_type: TileType):
	var tileset = new_type.get_tileset()
	
	if tileset == null: 
		return
	
	var tile_bitmask = get_tile_bitmask(tile, new_type)
	var texture = get_tile_texture_by_bitmask(tileset, tile_bitmask)
	
	# If no texture was found, give the tile the default texture
	if !texture:
		var tile_id = tileset.get_tiles_ids()[0]
		var icon_coord = tileset.autotile_get_icon_coordinate(tile_id)
		var autotile_texture = tileset.tile_get_texture(tile_id)
		var tile_size = tileset.autotile_get_size(tile_id)
		
		texture = get_texture_at_coord(autotile_texture, icon_coord,tile_size)
	
	var tile_sprite_node = new_type.get_node("Sprite")
	tile_sprite_node.set_texture(texture)


# Take a tile and its new type, and return the bitmask value it should have, 
# based on the adjacent tiles 
func get_tile_bitmask(tile: Tile, new_type: TileType) -> int:
	var next_type_class = new_type.get_class()
	var adjacent_tiles = grid_node.get_adjacent_tiles(tile)
	var final_bitmask_value : int = 0
	
	for i in range(adjacent_tiles.size()):
		
		if adjacent_tiles[i] == null: continue
			
		var adjacent_type = adjacent_tiles[i].get_tile_type()
			
		# Get the bitmask based on every adjacent tiles and add it to the final 
		if adjacent_tiles[i] != tile:
			var diagonal : bool = i % 2 == 0
			
			if adjacent_type.is_class(next_type_class):
				if !diagonal or are_neighbour_tiles_same_type(adjacent_tiles, i):
					final_bitmask_value += int(pow(2, i))
					if debug:
						print("adjacent tile with id : " + String(i) + " is water")
						print("current bitmask is : " + String(final_bitmask_value))
		
		# Add the bitmask corresponding to the center tile (itself)
		else: 
			final_bitmask_value += 16
	
	if debug:
		print("Final bitmask value: " + String(final_bitmask_value))
	
	return final_bitmask_value


# Return true if every neighbour (no diagonal)
# of the given tile has the same type as the tile
func are_neighbour_tiles_same_type(tiles_array : Array, id: int) -> bool:
	var neighbours_array = []
	for i in range(tiles_array.size()):
		if i == 4: # Ignore the central tile
			continue
		
		if i != id && are_tiles_neighbour(id, i) && tiles_array[i] != null:
			neighbours_array.append(tiles_array[i])
	
	for tile in neighbours_array:
		var neighbour_type = tile.get_tile_type_name()
		var checked_tile_type = tiles_array[id].get_tile_type_name()
		if neighbour_type != checked_tile_type:
			return false
	return true


# Return true if two tiles are neighbours (no diagonal), based on their id , false if not
func are_tiles_neighbour(id1: int, id2: int) -> bool:
	return id1 + 3 == id2 or id1 - 3 == id2 or \
		(id1 + 1 == id2 && int(float(id1) / 3) == int(float(id2) / 3)) or \
		(id1 - 1 == id2 && int(float(id1) / 3) == int(float(id2) / 3))


# Take a bitmask and returns the corresponding texture in the tileset's autotile
func get_tile_texture_by_bitmask(tileset: TileSet, bitmask: int) -> AtlasTexture:
	var tiles_id_array = tileset.get_tiles_ids()
	var tile_id = tiles_id_array[0]
	
	var autotile_texture = tileset.tile_get_texture(tile_id)
	var tile_size = tileset.autotile_get_size(tile_id)
	
	for i in range(11):
		for j in range(5):
			var current_bitmask = tileset.autotile_get_bitmask(tile_id, Vector2(i, j))
			if current_bitmask == bitmask:
				return get_texture_at_coord(autotile_texture, Vector2(i, j), tile_size)
	return null


# Get the texture at the given position
func get_texture_at_coord(autotile_texture: Texture, coord : Vector2, tile_size: Vector2) -> AtlasTexture:
	var atlas_texture = AtlasTexture.new()
	atlas_texture.set_atlas(autotile_texture)
	atlas_texture.set_region(Rect2(coord * tile_size, tile_size))
	return atlas_texture


#### VIRTUALS ####



#### INPUTS ####



#### SIGNAL RESPONSES ####

func on_plant_phase_start():
	update_grid_autotiling()
