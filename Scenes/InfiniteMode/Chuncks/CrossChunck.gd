extends SpecialChunck
class_name CrossChunck

var automata_arrived : Array = []
var automata_ready_to_teleport : Array = []
var chunck_quarter = ChunckBin.chunck_tile_size.x / 4

var already_teleported : bool = false

#### ACCESSORS ####

func is_class(value: String): return value == "CrossChunck" or .is_class(value)
func get_class() -> String: return "CrossChunck"


#### BUILT-IN ####

func _ready():
	pass

#### VIRTUALS ####



#### LOGIC ####


# Function overide - No room should be generated in that chunck
func generate_rooms() -> Node:
	return null


# Teleport the automatas so they invert their position
func teleport_automatas() -> void:
	automata_arrived = []
	var automata_pos_array : Array = []
	for automata in automata_ready_to_teleport:
		automata_pos_array.append(automata.get_bin_map_pos())
	
	for i in range(automata_ready_to_teleport.size()):
		var automata = automata_ready_to_teleport[i]
		var other_aut_id : int = 0 if i == 1 else 1
		var automata_pos = automata_pos_array[i]
		var other_aut_pos = automata_pos_array[other_aut_id]
		
		var dest_cell = Vector2(int(chunck_quarter * 3) - 3, other_aut_pos.y)
		automata.set_bin_map_pos(dest_cell)
		
		var group := Node2D.new()
		var tel_type : String = "RedTeleporter" if i == 0 else "BlueTeleporter"
		
		group.set_name("G")
		var entry_teleporter = interactive_object_dict[tel_type].instance()
		var exit_teleporter = interactive_object_dict[tel_type].instance()
		
		entry_teleporter.set_position(automata_pos * GAME.TILE_SIZE + GAME.TILE_SIZE / 2)
		exit_teleporter.set_position((dest_cell + Vector2.RIGHT) * GAME.TILE_SIZE + GAME.TILE_SIZE / 2)
		
		object_to_add.append([group, entry_teleporter, exit_teleporter])
	
	for automata in automata_ready_to_teleport:
		automata.forced_moves += [Vector2.RIGHT, Vector2.RIGHT]
		automata.set_stoped(false)
	
	automata_ready_to_teleport = []
	already_teleported = true


#### INPUTS ####



#### SIGNAL RESPONSES ####

func on_automata_moved(automata: ChunckAutomata, to: Vector2):
	if automata in automata_arrived or already_teleported:
		return
	
	if to.x >= chunck_quarter:
		automata_arrived.append(automata)
		automata.forced_moves += [Vector2.RIGHT, Vector2.RIGHT, Vector2.RIGHT]


func on_automata_forced_move_finished(automata: ChunckAutomata, _pos: Vector2):
	automata.set_stoped(true)
	automata_ready_to_teleport.append(automata)
	
	if automata_ready_to_teleport.size() == 2:
		teleport_automatas()

