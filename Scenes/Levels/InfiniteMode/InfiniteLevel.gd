extends Level
class_name InfiniteLevel

#### ACCESSORS ####

func is_class(value: String): return value == "InfiniteLevel" or .is_class(value)
func get_class() -> String: return "InfiniteLevel"


#### BUILT-IN ####



#### VIRTUALS ####



#### LOGIC ####

func instanciate_players() -> void:
	if is_loaded_from_save:
		yield($ChunckGenerator, "first_chunck_ready")
	
	.instanciate_players()

#### INPUTS ####



#### SIGNAL RESPONSES ####
