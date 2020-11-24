extends Node
class_name ChunckAutomata

var chunck_bin : ChunckBin = null 
var bin_map_pos := Vector2.INF setget set_bin_map_pos, get_bin_map_pos

onready var move_timer = Timer.new()

signal moved(to)

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
	add_child(move_timer)
	move_timer.set_wait_time(0.1)
	move_timer.start()
	var _err = move_timer.connect("timeout", self, "on_move_timer_timeout")


#### LOGIC ####

func move() -> void:
	var projected_pos = bin_map_pos + Vector2.RIGHT
	if is_pos_inside_chunck(projected_pos):
		set_bin_map_pos(projected_pos)
	else: queue_free()


func is_pos_inside_chunck(pos: Vector2):
	return pos.x >= 0 && pos.y >= 0 \
	&& pos.x < chunck_bin.chunck_tile_size.x && pos.y < chunck_bin.chunck_tile_size.y


#### VIRTUALS ####



#### INPUTS ####



#### SIGNAL RESPONSES ####

func on_move_timer_timeout():
	move()
