extends Node
class_name ChunckAutomata

export var debug : bool = false 

var chunck_bin : ChunckBin = null 
var bin_map_pos := Vector2.INF setget set_bin_map_pos, get_bin_map_pos

var last_moves := PoolVector2Array()

onready var move_timer = Timer.new()

signal moved(to)
signal finished(final_pos)

#### ACCESSORS ####

func is_class(value: String):
	return value == "ChunckAutomata" or .is_class(value)

func get_class() -> String:
	return "ChunckAutomata"

func set_bin_map_pos(value: Vector2):
	if value != Vector2.INF && value != bin_map_pos:
		bin_map_pos = value
		emit_signal("moved", bin_map_pos)

func get_bin_map_pos() -> Vector2:
	return bin_map_pos


#### BUILT-IN ####

func _init(chunck_binary: ChunckBin, pos: Vector2):
	chunck_bin = chunck_binary
	var _err = connect("moved", chunck_bin, "on_automata_moved")
	bin_map_pos = pos


func _ready():
	emit_signal("moved", bin_map_pos)
	var _err = connect("finished", get_parent(), "on_automata_finished")
	_err = connect("finished", chunck_bin, "on_automata_finished")
	
	if debug:
		add_child(move_timer)
		move_timer.set_wait_time(0.1)
		_err = move_timer.connect("timeout", self, "on_move_timer_timeout")
	else:
		var movement_finished : bool = false
		while(!movement_finished):
			movement_finished = move()
		
		emit_signal("finished", bin_map_pos)
		queue_free()


#### LOGIC ####


func move() -> bool:
	# Choose a movement
	var chosen_move = choose_move()
	
	# Update last moves
	last_moves.append(chosen_move)
	if last_moves.size() > 2:
		last_moves.remove(0)
	
	# Move the automata and check if the automata has finished moving (is outside the chunck)
	var projected_pos = bin_map_pos + chosen_move
	if is_pos_inside_chunck(projected_pos):
		set_bin_map_pos(projected_pos)
		return false
	else: 
		return true


# Choose a movement
func choose_move() -> Vector2:
	var near_celling : bool = is_near_ceiling()
	var near_floor : bool = is_near_floor()
	
	var possible_moves = [Vector2.RIGHT, Vector2.UP, Vector2.DOWN]
	
	if near_celling or are_two_last_moves_up() or is_last_move(Vector2.DOWN):
		possible_moves.erase(Vector2.UP)
	
	if near_floor or is_last_move(Vector2.UP):
		possible_moves.erase(Vector2.DOWN)
	
	if near_chunck_end() or bin_map_pos.x == 0:
		possible_moves = [Vector2.RIGHT]
	
	var random_id = randi() % possible_moves.size()
	return possible_moves[random_id]



func is_last_move(move: Vector2) -> bool:
	if last_moves.empty(): return false
	return move == last_moves[last_moves.size() - 1]


func are_two_last_moves_up() -> bool:
	return last_moves.size() >= 2 && last_moves[0] == Vector2.UP && last_moves[1] == Vector2.UP


func is_near_ceiling() -> bool:
	if !is_in_second_half():
		return bin_map_pos.y <= 2
	else:
		return bin_map_pos.y <= chunck_bin.chunck_tile_size.y / 2 + 3


func is_near_floor() -> bool:
	if !is_in_second_half():
		return bin_map_pos.y >= chunck_bin.chunck_tile_size.y / 2 - 2
	else:
		return bin_map_pos.y >= chunck_bin.chunck_tile_size.y - 2


func near_chunck_end() -> bool:
	return bin_map_pos.x >= chunck_bin.chunck_tile_size.x - 3


func is_in_second_half() -> bool:
	return bin_map_pos.y > chunck_bin.chunck_tile_size.y / 2


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
