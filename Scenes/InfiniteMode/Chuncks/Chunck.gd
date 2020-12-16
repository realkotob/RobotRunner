extends Node2D
class_name LevelChunck

var interactive_object_dict : Dictionary = {
	"RedTeleporter": preload("res://Scenes/InteractiveObjects/Teleports/Types/RedTeleporter.tscn"),
	"BlueTeleporter": preload("res://Scenes/InteractiveObjects/Teleports/Types/BlueTeleporter.tscn"),
	"GreenTeleporter": preload("res://Scenes/InteractiveObjects/Teleports/Types/GreenTeleporter.tscn"),
	"IceBlock": preload("res://Scenes/InteractiveObjects/BreakableObjects/IceBlock/M/MIceBlock.tscn"),
	"EarthBlock": preload("res://Scenes/InteractiveObjects/BreakableObjects/EarthBlock/M/MEarthBlock.tscn")
}

const max_nb_room : int = 3

onready var walls_tilemap = $Walls
onready var new_chunck_area = $NewChunckGenArea

signal chunck_gen_finished
signal new_chunck_reached
signal every_automata_finished

var chunck_bin : ChunckBin = null setget set_chunck_bin, get_chunck_bin

var first_chunck : bool = false
var is_ready : bool = false
var starting_points : Array = []
var next_start_pos_array := PoolVector2Array()

var nb_automata : int = 2
var object_to_add : Array = []

var players_disposition : Dictionary = {
	"top": null,
	"bottom": null
}


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
	var _err = new_chunck_area.connect("body_entered", self, "on_body_entered")
	is_ready = true
	
	var last_room = generate_rooms()
	
	if last_room != null:
		yield(last_room, "ready")
	
	initialize_player_placement()
	create_automatas()


#### LOGIC ####

func generate_self():
	place_rooms()
	place_wall_tiles()
	walls_tilemap.update_bitmask_region(Vector2.ZERO, ChunckBin.chunck_tile_size)
	SlopePlacer.place_slopes(walls_tilemap)
	
	generate_objects()
#	room_debug_visualizer()
	emit_signal("chunck_gen_finished")


func create_automatas() -> void:
	for point in starting_points:
		var automata = ChunckAutomata.new(chunck_bin, point)
		automata.name = "automata"
		automata.chunck = self
		call_deferred("add_child", automata)


func generate_rooms() -> Node:
	var rng = 1 if first_chunck else randi() % 4
	var room : Node = null
	if rng == 0:
		room = BigChunckRoom.new()
		room.name = "BigRoom"
		room.chunck = self
		$Rooms.call_deferred("add_child", room)
	else:
		var nb_room = randi() % max_nb_room
		for i in range(nb_room):
			var next_room_half = SmallChunckRoom.ROOM_HALF.TOP_HALF
			
			if i == 0:
				room = SmallChunckRoom.new()
			else:
				var last_room_half = room.get_room_half()
				if last_room_half == next_room_half:
					next_room_half = SmallChunckRoom.ROOM_HALF.BOTTOM_HALF
			
			room = SmallChunckRoom.new(next_room_half)
			room.name = "SmallRoom"
			room.chunck = self
			$Rooms.call_deferred("add_child", room)
	return room


# Place the rooms in the chunck by carving modifing the chunck bin accordingly to the room bin
func place_rooms():
	for room in $Rooms.get_children():
		
		# If no automata has entered this room, ignore it
		if room.entry_exit_couple_array.empty():
			continue
		
		var room_rect : Rect2 = room.get_room_rect()
		for i in range(room_rect.size.y):
			for j in range(room_rect.size.x):
				var pos = Vector2(j, i) + room_rect.position
				if room.bin_map.empty():
					continue
				else:
					var room_cell = room.bin_map[i][j]
					chunck_bin.bin_map[pos.y][pos.x] = room_cell
		
		object_to_add += room.interactive_objects


# Place the tiles in the tilemap according the the bin_map value
func place_wall_tiles():
	var wall_tile_id = walls_tilemap.get_tileset().find_tile_by_name("AutotileWall")
	var chunck_tile_size = ChunckBin.chunck_tile_size
	var bin_noise_map = chunck_bin.bin_map
	walls_tilemap.clear()
	
	for i in range(chunck_tile_size.y):
		for j in range(chunck_tile_size.x):
			var current_pos = Vector2(j, i)
			if bin_noise_map[i][j] == 1:
				walls_tilemap.set_cellv(current_pos, wall_tile_id)


# Initialize the player disposition dictionary
func initialize_player_placement():
	var players_array = get_tree().get_nodes_in_group("Players")
	
	for player in players_array:
		var player_pos = player.get_global_position()
		var bottom = is_pos_in_bottom_half(player_pos)
		
		if bottom:
			players_disposition["bottom"] = weakref(player)
		else:
			players_disposition["top"] = weakref(player)


# Verify if the given cell is outside the chunck or not
func is_cell_outside_chunck(cell: Vector2) -> bool:
	return cell.x < 0 or cell.y < 0 or\
	cell.x >= chunck_bin.chunck_tile_size.x or cell.y >= chunck_bin.chunck_tile_size.y


# Returns true if the given position is in the bottom half of the chunck
# False if the pos is in the top half
func is_pos_in_bottom_half(pos: Vector2) -> bool:
	return pos.y > (ChunckBin.chunck_tile_size.y * GAME.TILE_SIZE.y) / 2


# Returns the rect of the room the given is in
# Returns an empty Rect2 if the given pos isn't in a room
func find_room_form_cell(cell: Vector2) -> ChunckRoom:
	for room in $Rooms.get_children():
		var room_rect = room.get_room_rect()
		if room_rect.has_point(cell): 
			return room
	return null


# Genrerate the interactive objects in the chunck 
func generate_objects():
	for element in object_to_add:
		if element is Node2D:
			call_deferred("add_child", element)
		elif element is Array:
			call_deferred("add_child", element[0])
			yield(element[0], "tree_entered")
			
			for i in range(element.size()):
				if i == 0: continue
				element[0].call_deferred("add_child", element[i])


# Add an object to the object_to_add array postioned at the given cell
func stack_object_at_cell(obj_key: String, cell: Vector2):
	if !obj_key in interactive_object_dict.keys():
		print("The request object: " + obj_key + " is not in the interactive_objects_dict")
		return
	
	var obj = interactive_object_dict[obj_key].instance()
	obj.set_position(cell * GAME.TILE_SIZE)
	
	if obj.has_method("awake"):
		obj.awake()
	
	object_to_add.append(obj)


# Place a block at the given cell, and adapt the block type to the expected player 
func place_block(cell: Vector2):
	var cell_pos = cell * GAME.TILE_SIZE
	var pos_in_bottom_half = is_pos_in_bottom_half(cell_pos)
	var key = "bottom" if pos_in_bottom_half else "top"
	var player_weakref = players_disposition[key]
	
	if player_weakref == null:
		return
	
	var player = player_weakref.get_ref()
	
	var breakable_objs = player.breakable_type_array
	var block_type = "IceBlock" if "IceBlock" in breakable_objs else "EarthBlock"
	
	stack_object_at_cell(block_type, cell)

#### VIRTUALS ####



#### INPUTS ####



#### DEBUG ####

# Display the room as a red semi transparant rectangle
func room_debug_visualizer():
	var tile_size = GAME.TILE_SIZE
	
	for room in $Rooms.get_children():
		var room_color_rect = ColorRect.new()
		var room_rect = room.get_room_rect()
		room_color_rect.name = "RoomColorRect"
		room_color_rect.set_frame_color(Color.red)
		room_color_rect.set_position(room_rect.position * tile_size)
		room_color_rect.set_size(room_rect.size * tile_size)
		room_color_rect.color.a = 0.5
		
		call_deferred("add_child", room_color_rect)
		
		# Display entries and exits
		for couple in room.entry_exit_couple_array:
			var entry_cell = couple[0]
			var exit_cell = couple[1]
			
			var entry_room_color_rect = ColorRect.new()
			entry_room_color_rect.name = "EntryColorRect"
			entry_room_color_rect.set_position(room_color_rect.get_position() + (entry_cell * tile_size))
			entry_room_color_rect.set_size(tile_size)
			entry_room_color_rect.set_frame_color(Color.azure)
			entry_room_color_rect.color.a = 0.5
			
			var exit_room_color_rect = ColorRect.new()
			exit_room_color_rect.name = "ExitColorRect"
			exit_room_color_rect.set_position(room_color_rect.get_position() + (exit_cell * tile_size))
			exit_room_color_rect.set_size(tile_size)
			entry_room_color_rect.set_frame_color(Color.violet)
			entry_room_color_rect.color.a = 0.5
			 
			call_deferred("add_child", entry_room_color_rect)
			call_deferred("add_child", exit_room_color_rect)



#### SIGNAL RESPONSES ####


func on_body_entered(body: PhysicsBody2D):
	if body is Player:
		emit_signal("new_chunck_reached")
		new_chunck_area.queue_free()


func on_bin_map_changed():
	pass

func on_automata_moved(_automata: ChunckAutomata, _to: Vector2):
	pass

func on_automata_forced_move_finished(_automata: ChunckAutomata, _pos: Vector2):
	pass


func on_automata_finished(final_pos: Vector2):
	next_start_pos_array.append(Vector2(0, final_pos.y))
	nb_automata -= 1
	
	if nb_automata == 0:
		emit_signal("every_automata_finished")
		generate_self()


func on_automata_block_placable(cell: Vector2):
	if !first_chunck:
		place_block(cell)
