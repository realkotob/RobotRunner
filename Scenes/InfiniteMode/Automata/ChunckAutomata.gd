extends Node
class_name ChunckAutomata

export var debug : bool = false 

var chunck_bin : ChunckBin = null 
var chunck = null
var bin_map_pos := Vector2.INF setget set_bin_map_pos, get_bin_map_pos

var last_moves := PoolVector2Array()
var stoped : bool = false setget set_stoped, is_stoped

var forced_moves = []

onready var move_timer = Timer.new()

signal moved(automata, to)
signal finished(final_pos)
signal entered_room(entry_point, exit_point)
signal forced_move_finished(automata, pos)
signal block_placable(cell)

#### ACCESSORS ####

func is_class(value: String):
	return value == "ChunckAutomata" or .is_class(value)

func get_class() -> String:
	return "ChunckAutomata"

func set_bin_map_pos(value: Vector2):
	if value != Vector2.INF && value != bin_map_pos:
		bin_map_pos = value
		emit_signal("moved", self, bin_map_pos)

func get_bin_map_pos() -> Vector2:
	return bin_map_pos

func set_stoped(value: bool): 
	stoped = value
	if stoped == false:
		automata_carving_movement()

func is_stoped() -> bool: return stoped


#### BUILT-IN ####

func _init(chunck_binary: ChunckBin, pos: Vector2):
	chunck_bin = chunck_binary
	var _err = connect("moved", chunck_bin, "on_automata_moved")
	bin_map_pos = pos


func _ready():
	emit_signal("moved", self, bin_map_pos)
	var _err = connect("finished", chunck, "on_automata_finished")
	_err = connect("finished", chunck_bin, "on_automata_finished")
	_err = connect("moved", chunck, "on_automata_moved")
	_err = connect("forced_move_finished", chunck, "on_automata_forced_move_finished")
	_err = connect("block_placable", chunck, "on_automata_block_placable")
	
	if debug:
		add_child(move_timer)
		move_timer.set_wait_time(0.1)
		_err = move_timer.connect("timeout", self, "on_move_timer_timeout")
	else:
		automata_carving_movement()


#### LOGIC ####


func automata_carving_movement() -> void:
	var movement_finished : bool = false
	
	while(!stoped):
		movement_finished = move()
		if movement_finished:
			set_stoped(true)
		
		# Emit the signal block placable each time the conditions are met
		if last_moves.size() >= 2:
			if last_moves[-1] == Vector2.RIGHT && last_moves[-2] == Vector2.RIGHT:
				emit_signal("block_placable", get_bin_map_pos())
	
	if movement_finished:
		emit_signal("finished", bin_map_pos)
		queue_free()


# Choose a movement, the movement can either be expressed if relative value (chosen_move)
# or in absolute value (realtive to the whole chunck instead of relative to the automata pos)
# if the final_pos is not set (is equal to Vector2.INF), the relative value will be used
# if the final_pos have a value, the chosen_move should have the value of Vector2.INF
# that way, we know this move was a teleportation
func move() -> bool:
	var room : ChunckRoom = chunck.find_room_form_cell(bin_map_pos)
	var chosen_move = Vector2.INF
	var final_pos := Vector2.INF
	var room_rect := Rect2()
	
	# If the current position is in a room, teleport to the other size of the room
	# If it's a big room, stay on the same y axis, if it's a small one
	# set the y position to the bottom of the room so it is accesible from a jump
	if room != null:
		var _err = connect("entered_room", room, "on_automata_entered")
		room_rect = room.get_room_rect()
		var entry_point = Vector2(0, bin_map_pos.y)
		
		if room is SmallChunckRoom:
			var random_offset = (randi() % 3) * Vector2.UP
			final_pos = room_rect.position + room_rect.size + random_offset + Vector2.UP
		else:
			var x = room_rect.position.x + room_rect.size.x
			# Clamp the exit position so its not too close from the ceiling
			# And it can't exceed the floor of the room
			var y = clamp(bin_map_pos.y, room_rect.position.y + 4, room_rect.position.y + room_rect.size.x)
			final_pos = Vector2(x, y)
		
		emit_signal("entered_room", entry_point, final_pos)
		disconnect("entered_room", room, "on_automata_entered")
		
		forced_moves.append(Vector2.RIGHT)
	else:
		chosen_move = choose_move()
	
	# Update last moves
	last_moves.append(chosen_move)
	if last_moves.size() > 2:
		last_moves.remove(0)
	
	# Move the automata and check if the automata has finished moving (is outside the chunck)
	var projected_pos = bin_map_pos + chosen_move if final_pos == Vector2.INF else final_pos
	if is_pos_inside_chunck(projected_pos):
		set_bin_map_pos(projected_pos)
		return false
	else: 
		return true


# Choose a movement
func choose_move() -> Vector2:
	var near_celling : bool = is_near_ceiling()
	var near_floor : bool = is_near_floor()
	
	if !forced_moves.empty():
		var move = forced_moves.pop_front()
		if forced_moves.empty():
			emit_signal("forced_move_finished", self, get_bin_map_pos() + move)
		return move
	
	var possible_moves = [Vector2.RIGHT, Vector2.UP, Vector2.DOWN]
	
	if near_celling or are_two_last_moves_up() or is_last_move(Vector2.DOWN):
		possible_moves.erase(Vector2.UP)
	
	if near_floor or is_last_move(Vector2.UP):
		possible_moves.erase(Vector2.DOWN)
	
	if near_chunck_end() or bin_map_pos.x == 0:
		possible_moves = [Vector2.RIGHT]
	
	var random_id = randi() % possible_moves.size()
	return possible_moves[random_id]


# Compare the given move with the last move the automata has done.
# Returns true if it is the same
func is_last_move(move: Vector2) -> bool:
	if last_moves.empty(): return false
	return move == last_moves[last_moves.size() - 1]


# Returns true if the two last moves of the automata are UP
func are_two_last_moves_up() -> bool:
	return last_moves.size() >= 2 && last_moves[0] == Vector2.UP && last_moves[1] == Vector2.UP


# Returns true if the automata is close from the ceiling of its half
func is_near_ceiling() -> bool:
	if !is_in_bottom_half():
		return bin_map_pos.y <= 2
	else:
		return bin_map_pos.y <= chunck_bin.chunck_tile_size.y / 2 + 3


# Returns true if the automata is close from the floor of its half
func is_near_floor() -> bool:
	if !is_in_bottom_half():
		return bin_map_pos.y >= chunck_bin.chunck_tile_size.y / 2 - 2
	else:
		return bin_map_pos.y >= chunck_bin.chunck_tile_size.y - 2


# Returns true if the automata is close from the end of the floor
func near_chunck_end() -> bool:
	return bin_map_pos.x >= chunck_bin.chunck_tile_size.x - 3

# Returns true if the automata is in the bottom half
func is_in_bottom_half() -> bool:
	return bin_map_pos.y > chunck_bin.chunck_tile_size.y / 2


# Verify if the given position is inside the chunck
func is_pos_inside_chunck(pos: Vector2):
	return pos.x >= 0 && pos.y >= 0 \
	&& pos.x < chunck_bin.chunck_tile_size.x && pos.y < chunck_bin.chunck_tile_size.y


#### VIRTUALS ####



#### INPUTS ####

func _input(_event):
	if Input.is_action_just_pressed("ui_accept"):
		move_timer.start()


#### SIGNAL RESPONSES ####

func on_move_timer_timeout():
	var __ = move()
