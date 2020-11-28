extends ChunckRoom
class_name BigChunckRoom

#### ACCESSORS ####

func is_class(value: String): return value == "BigChunckRoom" or .is_class(value)
func get_class() -> String: return "BigChunckRoom"

#### BUILT-IN ####



#### LOGIC ####

func _init():
	min_room_size = Vector2(25, 14)
	max_room_size = Vector2(30, 20)


func place_platforms():
	for couple in entry_exit_couple_array:
		# If one exit is close enough from the ground, ignore it (Doesn't need platform)
		if couple[1].y > room_rect.size.y - 2:
			continue
		 
		var jump_max_dist : Vector2 = GAME.JUMP_MAX_DIST
		var room_size = get_room_rect().size
		
		var nb_platform = int(round(room_size.x / jump_max_dist.x))
		var last_platform_end = get_playable_entry_point(couple[0])
		var average_dist = int(room_size.x / nb_platform + 1)
		
		for _i in range(nb_platform):
			var platform_len = randi() % 2 + 2
			var platform_start = last_platform_end + Vector2(average_dist, 0)
			
			for j in range(platform_len):
				var current_x = platform_start.x + j
				if current_x > room_size.x - 2 or platform_start.y + 1 >= bin_map.size(): 
					continue
				else: 
					bin_map[platform_start.y + 1][current_x] = 1
			
			last_platform_end = platform_start + Vector2(platform_len, 0)


func get_playable_entry_point(entry: Vector2) -> Vector2:
	var point = room_rect.position + entry + Vector2.LEFT
	var chunck_bin_map = chunck.get_chunck_bin().bin_map
	var chunck_size = ChunckBin.chunck_tile_size
	
	for i in range(chunck_size.y):
		if chunck_bin_map[point.y + i][point.x] == 1:
			return entry + Vector2(0, i - 1)
	return point



#### SIGNAL RESPONSES ####

func on_automata_entered(entry: Vector2, exit: Vector2):
	.on_automata_entered(entry, exit)
	place_platforms()
