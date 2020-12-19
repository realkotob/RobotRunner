extends Node
class_name SlopePlacer

enum SLOPE_TYPE{
	ASCENDING,
	DESCENDING,
	CEILING_ASC,
	CEILING_DES
}

#### REFACTO NEEDED ####
#### TO BE FULLY DECOUPLED FROM THE tilemap ####


#### ACCESSORS ####

func is_class(value: String): return value == "SlopePlacer" or .is_class(value)
func get_class() -> String: return "SlopePlacer"


#### BUILT-IN ####



#### VIRTUALS ####



#### LOGIC ####


# Replace the staircases with slopes
static func place_slopes(tilemap: TileMap):
	var chunck_tile_size = ChunckBin.chunck_tile_size
	var slope_atlas = tilemap.get_tileset().find_tile_by_name("SlopesAtlas")
	
	for i in range(chunck_tile_size.y):
		for j in range(chunck_tile_size.x):
			var cell = Vector2(j, i)
			match get_cell_stair_type(tilemap, cell):
				-1 : continue
				SLOPE_TYPE.ASCENDING: 
					tilemap.set_cell(cell.x, cell.y, slope_atlas,
									false, false, false, Vector2.ZERO)
					if is_cell_wall(tilemap, cell + Vector2(-1, 1)) && \
							is_cell_wall(tilemap, cell + Vector2(0, 2)):
						tilemap.set_cell(cell.x, cell.y + 1, slope_atlas,
									false, false, false, Vector2(1, 0))
				SLOPE_TYPE.DESCENDING: 
					tilemap.set_cell(cell.x, cell.y, slope_atlas,
									false, false, false, Vector2(1, 2))
					if is_cell_wall(tilemap, cell + Vector2(1, 1)) && \
							 is_cell_wall(tilemap, cell + Vector2(0, 2)):
						tilemap.set_cell(cell.x, cell.y +1, slope_atlas,
									false, false, false, Vector2(1, 3))
				_ : continue


# Take a cell, and return its slope type as defined in the SLOPE_TYPE enum
# Return -1 if the cell isn't a stair
static func get_cell_stair_type(tilemap, cell: Vector2) -> int:
	if !is_cell_wall(tilemap, cell): return -1
	
	if is_cell_in_staircase(tilemap, cell, true): return SLOPE_TYPE.ASCENDING
	if is_cell_in_staircase(tilemap, cell, false): return SLOPE_TYPE.DESCENDING
	
	return -1


# Returns true if the cell is in a staircase
# ie it must be a stair itself and there must be a stair before of after it
static func is_cell_in_staircase(tilemap: TileMap, cell: Vector2, ascending: bool) -> bool:
	if !is_cell_stair(tilemap, cell, ascending): return false
	if ascending:
		return (is_cell_stair(tilemap, cell + Vector2(-1, 1), true) && \
		!is_cell_stair(tilemap, cell + Vector2.RIGHT, false)) or is_cell_slope(tilemap, cell + Vector2(1, -1))
	else:
		return (is_cell_stair(tilemap, cell + Vector2(1, 1), false) && \
		!is_cell_stair(tilemap, cell + Vector2.LEFT, false)) or is_cell_slope(tilemap, cell + Vector2(-1, -1))


# Returns true if the given cell is a slope
static func is_cell_slope(tilemap: TileMap, cell: Vector2) -> bool:
	var slope_atlas = tilemap.get_tileset().find_tile_by_name("SlopesAtlas")
	var tile_id = tilemap.get_cell(int(cell.x), int(cell.y))
	return tile_id == slope_atlas


# Verify if the given cell is a stair or not
static func is_cell_stair(tilemap: TileMap, cell: Vector2, ascending: bool) -> bool:
	if !is_cell_floor(tilemap, cell): return false
	if ascending:
		return !is_cell_wall(tilemap, cell + Vector2.LEFT) && \
			is_cell_wall(tilemap, cell + Vector2.RIGHT) && \
			is_cell_wall(tilemap, cell + Vector2.DOWN)
	else:
		return is_cell_wall(tilemap, cell + Vector2.LEFT) && \
			!is_cell_wall(tilemap, cell + Vector2.RIGHT) && \
			is_cell_wall(tilemap, cell + Vector2.DOWN)


# Verify if the given cell is a floor or not
static func is_cell_floor(tilemap: TileMap, cell: Vector2):
	return is_cell_wall(tilemap, cell) && !is_cell_wall(tilemap, cell + Vector2.UP)


# Verify if the given cell is a wall cell or not 
# (If their is any kind of wall tile on the cell, including slopes)
static func is_cell_wall(tilemap: TileMap, cell: Vector2) -> bool:
	return cell in tilemap.get_used_cells()



#### INPUTS ####



#### SIGNAL RESPONSES ####
