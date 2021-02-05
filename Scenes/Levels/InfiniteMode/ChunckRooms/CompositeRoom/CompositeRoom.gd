extends ChunckRoom
class_name CompositeRoom

onready var walls = $Walls

#### ACCESSORS ####

func is_class(value: String): return value == "CompositeRoom" or .is_class(value)
func get_class() -> String: return "CompositeRoom"


#### BUILT-IN ####

func _ready() -> void:
	var used_cells = walls.get_used_cells()
	
	for cell in used_cells:
		var rel_pos_cell = cell - room_rect.position 
		bin_map[rel_pos_cell.y][rel_pos_cell.x] = 1
	walls.queue_free()


#### VIRTUALS ####



#### LOGIC ####



# FUNCTION OVERIDE #
func generate():
	var used_cell_rect = $Walls.get_used_rect()
	set_room_rect(used_cell_rect)
	create_bin_map()


#### INPUTS ####



#### SIGNAL RESPONSES ####
