extends Node
class_name ChunckChecker

onready var astar = AStar2D.new()
 
#### ACCESSORS ####



#### BUILT-IN ####



#### LOGIC ####


func is_chunck_valid(new_chunck_bin: Array, next_starting_points : Array = [],
					 nb_player: int = 2) -> bool:
	
	var valid_starting_points = get_correct_starting_points(new_chunck_bin, next_starting_points)
	
	# Check if there is at least one starting points per player
	if valid_starting_points.size() < nb_player:
		return false
	
	var exits = find_every_exit_points(new_chunck_bin)
	
	# Check if there is at least on valid exit per player
	if exits.size() < nb_player:
		return false
	
#	astar.clear()
#	feed_astar(new_chunck_bin)
	
	return true


# Feed the astar with every walkable empty tile (ie with a ground under it)
func feed_astar(chunck_bin: Array):
	var nb_tiles = get_nb_tiles(chunck_bin)
	for i in range(chunck_bin.size()):
		for j in range(chunck_bin[i].size()):
			if i + 1 >= chunck_bin.size():
				continue
			if chunck_bin[i][j] == 0 && chunck_bin[i + 1][j] == 1:
				var point = Vector2(j, i)
				var point_id = get_cell_id(point, nb_tiles)
				astar.add_point(point_id, point)


# Return the id of a cell, based on the size of the chunck and the pos of the cell
func get_cell_id(cell_pos: Vector2, nb_tiles: int) -> int:
	return int(abs(cell_pos.x + nb_tiles * cell_pos.y))


func get_nb_tiles(chunck_bin : Array) -> int:
	return chunck_bin.size() * chunck_bin[0].size()


# Returns the cell position of the hypothetique starting 
# points of the next chunck based on the last one
func get_next_starting_points(last_chunck_bin: Array) -> PoolVector2Array:
	var last_chunck_exits = find_every_exit_points(last_chunck_bin)
	var new_starting_points := PoolVector2Array()
	
	for exit in last_chunck_exits:
		new_starting_points.append(Vector2(0, exit.y))
	
	return new_starting_points


# Takes a binary representation of a chunck as a 2D array 
# 0 representing empty space
# 1 Representing walls
# Returns an PoolVector2Array of valid starting points
func get_correct_starting_points(bin_map: Array, 
	 starting_points_array : PoolVector2Array) -> PoolVector2Array:
	
	var valid_points := PoolVector2Array()
	for point in starting_points_array:
		if bin_map[point.y][point.x] == 0:
			valid_points.append(point)
	
	return valid_points


# Find every valid exits and returns their positions in the bin_map in a PoolVector2Array
func find_every_exit_points(bin_map: Array) -> PoolVector2Array:
	var exits_array := PoolVector2Array()
	for i in range(bin_map.size()):
		var last_elem_id = bin_map[i].size() - 1
		var last_elem = bin_map[i][last_elem_id]
		
		# Check if we are on the last tile (bottom right tile)
		if i + 1 > bin_map.size() - 1:
			continue
		
		# Get the element underneath the current one
		var underneath_elem = bin_map[i + 1][last_elem_id]
		
		# Add any empty position with a ground underneath it
		if last_elem == 0 && underneath_elem == 1:
			exits_array.append(Vector2(last_elem_id, i))
	
	return exits_array

#### VIRTUALS ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
