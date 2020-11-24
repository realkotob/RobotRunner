extends Node
class_name ChunckChecker

onready var astar = AStar2D.new()

enum GEN_STATE{
	SUCCESS,
	TOO_FEW_STARTING_POINT,
	TOO_FEW_EXITS,
	TOO_FEW_PATHS
}


#### ACCESSORS ####



#### BUILT-IN ####



#### LOGIC ####


func is_chunck_valid(new_chunck_bin: Array, next_starting_points : Array = [],
					 nb_player: int = 2) -> int:
	
	var starting_points = get_correct_starting_points(new_chunck_bin, next_starting_points)
	
	# Check if there is at least one starting points per player
	if starting_points.size() < nb_player:
		return GEN_STATE.TOO_FEW_STARTING_POINT
	
	var valid_starting_points = erase_invalid_starting_point(starting_points, new_chunck_bin)
	
	var exits = find_every_exit_points(new_chunck_bin)
	
	# Check if there is at least on valid exit per player
	if exits.size() < nb_player:
		return GEN_STATE.TOO_FEW_EXITS
	
	astar.clear()
	feed_astar(new_chunck_bin)
	connect_astar_points(new_chunck_bin)
	
	var entries_w_valid_path = get_nb_entries_w_valid_path(valid_starting_points, exits, new_chunck_bin)
	if entries_w_valid_path >= nb_player:
		return GEN_STATE.SUCCESS
	else:
		return GEN_STATE.TOO_FEW_PATHS


# Count the number of starting point of the chunck that have at least one path to one exit
func get_nb_entries_w_valid_path(entries_array: Array, exits_array: Array, chunck: Array) -> int:
	var nb_entry_with_path : int = 0
	var nb_tiles_in_chunck = get_nb_tiles(chunck)
	
	for entry in entries_array:
		for exit in exits_array:
			var entry_id = get_cell_id(entry, nb_tiles_in_chunck)
			if !astar.has_point(entry_id):
				print("ERROR: astar doesn't have the entry point wanted (id: " + String(entry_id) + 
						"position: " + String(entry) +")")
				continue
			
			var exit_id = get_cell_id(exit, nb_tiles_in_chunck)
			if !astar.has_point(exit_id):
				print("ERROR: astar doesn't have the exit point wanted (id: " + String(exit_id) + 
						"position: " + String(exit) +")")
				continue
			
			var path = astar.get_id_path(entry_id, exit_id)
			if !path.empty():
				nb_entry_with_path += 1
				break
	
	return nb_entry_with_path


# Feed the astar with every walkable empty tile (ie with a ground underneath it)
func feed_astar(chunck_bin: Array):
	var nb_tiles = get_nb_tiles(chunck_bin)
	for i in range(chunck_bin.size()):
		for j in range(chunck_bin[i].size()):
			var point = Vector2(j, i)
			if is_point_walkable(point, chunck_bin):
				var point_id = get_cell_id(point, nb_tiles)
				astar.add_point(point_id, point)


# Connect all points that are connectables in the astar entity
func connect_astar_points(chunck_bin: Array):
	var points_array = astar.get_points()
	
	for point in points_array:
		for to_point in points_array:
			if point == to_point or !astar.has_point(point) or !astar.has_point(to_point):
				continue
			
			var point_pos = astar.get_point_position(point)
			var to_point_pos = astar.get_point_position(to_point)
			
			if are_points_connectable(chunck_bin, point_pos, to_point_pos):
				astar.connect_points(point, to_point)


# Check if two points are connectables 
# (ie if the two points are walkable or jumpable from each other)
func are_points_connectable(chunck_bin: Array, point1: Vector2, point2: Vector2) -> bool:
	if are_points_adjacents(point1, point2):
		return true
	
	if !are_point_at_jump_distance(point1, point2):
		return false
	
	return are_points_jumpable(chunck_bin, point1, point2)


func is_point_walkable(point: Vector2, chunck_bin: Array) -> bool:
	if point.y + 1 >= chunck_bin.size():
		return false
	
	return chunck_bin[point.y][point.x] == 0 && chunck_bin[point.y + 1][point.x] == 1 &&\
			(point.y - 1 == 0 or chunck_bin[point.y - 1][point.x] == 0)


# Check every cell underneath the given one, and return true if there is at least one ground tile
func is_point_above_ground(point: Vector2, chunck_bin: Array) -> bool:
	for i in range(point.y + 1, chunck_bin.size(), 1):
		if chunck_bin[i][point.x] == 1:
			return true
	return false


func are_points_adjacents(point1: Vector2, point2: Vector2) -> bool:
	return point1.y == point2.y and (point1.x + 1 == point2.x or point1.x - 1 == point2.x) 

func are_point_at_jump_distance(point1 : Vector2, point2: Vector2) -> bool:
	return (point1.x < point2.x && point1.y - 2 > point2.y) or \
			(point2.x < point1.x && point2.y - 2 > point1.y)


func are_points_jumpable(chunck_bin: Array, point1: Vector2, point2: Vector2) -> bool:
	var points_h_order : Array = get_points_by_h_order(point1, point2)
	var points_v_order : Array = get_points_by_v_order(point1, point2)
	
	if points_h_order.empty():
		return false
	
	var h_dist = points_h_order[1].x - points_h_order[0].x
	var v_dist = points_v_order[0].y - points_v_order[1].y
	
	# Check for a impossible vertical jump (right-most tile is too high)
	if points_h_order[0].y > points_h_order[1].y && h_dist > 2:
		return false
	
	# Check if the jump is possible, jump-distance-wise
	if h_dist > 7:
		return false
	
	# Check if there is enough empty space above the cells to make the jump
	for i in range(v_dist + 1):
		for j in range(h_dist):
			var current_x = points_h_order[0].x + j
			var current_y = points_v_order[0].y - 1 + i
			if chunck_bin[current_y][current_x] == 1:
				# Exeption cases: Check if the current cell is underneath the highmost cell
				# In that case, the tile is dissmised because it wont affect the ability to maske the jump
				if current_x == points_v_order[0].x && current_y > points_v_order[0].y:
					continue
				else:
					return false
	return true


# Sort point by their position in the x axis, the left most shall be the firsts
func get_points_by_h_order(point1 : Vector2, point2: Vector2) -> Array:
	if point1.x < point2.x:
		return [point1, point2]
	elif point1.x == point2.x:
		return []
	else:
		return [point2, point1]


# Sort point by their position in the x axis, the left most shall be the firsts
func get_points_by_v_order(point1 : Vector2, point2: Vector2) -> Array:
	if point1.y < point2.y:
		return [point1, point2]
	elif point1.y == point2.y:
		return []
	else:
		return [point2, point1]


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

# Take PoolVector2Array of starting points an returns a similar array with only walkable points in it
func erase_invalid_starting_point(points_array: PoolVector2Array, chunck_bin: Array) -> PoolVector2Array:
	var valid_points := PoolVector2Array()
	for point in points_array:
		if is_point_walkable(point, chunck_bin):
			valid_points.append(point)
	
	return valid_points 


# Takes a binary representation of a chunck as a 2D array 
# 0 representing empty space
# 1 Representing walls
# Returns an PoolVector2Array of valid starting points
func get_correct_starting_points(bin_map: Array, 
	 starting_points_array : PoolVector2Array) -> PoolVector2Array:
	
	var valid_points := PoolVector2Array()
	for point in starting_points_array:
		if is_point_above_ground(point, bin_map) && bin_map[point.y][point.x] == 0:
			valid_points.append(point)
	
	return valid_points


# Find every valid exits and returns their positions in the bin_map in a PoolVector2Array
func find_every_exit_points(bin_map: Array) -> PoolVector2Array:
	var exits_array := PoolVector2Array()
	for i in range(bin_map.size()):
		var last_column_id = bin_map[i].size() - 1
		var current_cell_pos = Vector2(last_column_id, i)
		
		# Add any empty position with a ground underneath it
		if is_point_walkable(current_cell_pos, bin_map):
			exits_array.append(current_cell_pos)
	
	return exits_array

#### VIRTUALS ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
