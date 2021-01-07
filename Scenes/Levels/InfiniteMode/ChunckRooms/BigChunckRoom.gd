extends ChunckRoom
class_name BigChunckRoom

#### ACCESSORS ####

func is_class(value: String): return value == "BigChunckRoom" or .is_class(value)
func get_class() -> String: return "BigChunckRoom"

#### BUILT-IN ####



#### LOGIC ####

func _init():
	min_room_size = Vector2(30, 20)
	max_room_size = ChunckBin.chunck_tile_size - Vector2(2, 2)


# Enlarge the entry and the exit of the room, so its easier to reach by jumping
func enlarge_entry_exit(tile_wide: int = randi() % 2 + 3):
	for couple in entry_exit_couple_array:
		var entry_abs_cell = _cell_rel_to_abs(couple[0]) + Vector2.LEFT
		var exit_abs_cell = _cell_rel_to_abs(couple[1]) + Vector2.RIGHT
		var bin_map = chunck.chunck_bin.bin_map
		
		for i in range(tile_wide):
			for j in range(2):
				# Enlarge entry
				if entry_abs_cell.y - 1 > 1 && entry_abs_cell.x - j >= 0:
					bin_map[entry_abs_cell.y - i][entry_abs_cell.x - j] = 0
				
				# Enlarge exit
				if exit_abs_cell.y < ChunckBin.chunck_tile_size.y - 1 && \
					exit_abs_cell.x + j < ChunckBin.chunck_tile_size.x:
					bin_map[exit_abs_cell.y - i][exit_abs_cell.x + j] = 0


#### SIGNAL RESPONSES ####

func _on_automata_crossed(entry: Vector2, exit: Vector2):
	._on_automata_crossed(entry, exit)
	
	if entry_exit_couple_array.size() == 2:
		generate_platforms()
		place_platforms()
		enlarge_entry_exit()


func on_every_automata_finished():
	generate_liquid("Lava")
