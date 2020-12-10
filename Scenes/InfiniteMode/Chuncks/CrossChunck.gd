extends LevelChunck
class_name CrossChunck

var automata_teleported : Array = []

#### ACCESSORS ####

func is_class(value: String): return value == "CrossChunck" or .is_class(value)
func get_class() -> String: return "CrossChunck"


#### BUILT-IN ####

func _ready():
	pass

#### VIRTUALS ####



#### LOGIC ####

func generate_self():
	place_wall_tiles()

#### INPUTS ####



#### SIGNAL RESPONSES ####

func on_automata_moved(automata: ChunckAutomata, to: Vector2):
	if automata in automata_teleported:
		return
	
	var chunck_thrid = ChunckBin.chunck_tile_size.x / 4
	
	if to.x >= chunck_thrid:
		automata_teleported.append(automata)
		
		var dest_cell = Vector2(int(chunck_thrid * 3), to.y)
		automata.set_bin_map_pos(dest_cell)
		
		var group := Node2D.new()
		group.set_name("G")
		var entry_teleporter = interactive_object_dict["RedTeleporter"].instance()
		var exit_teleporter = interactive_object_dict["RedTeleporter"].instance()
		
		entry_teleporter.set_position(to * GAME.TILE_SIZE)
		exit_teleporter.set_position(dest_cell * GAME.TILE_SIZE)
		
		object_to_add.append([group, entry_teleporter, exit_teleporter])
