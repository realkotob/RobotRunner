extends WorldMapMovingElement
class_name WorldMapSignalLight


#### ACCESSORS ####

func is_class(value: String): return value == "WorldMapSignalLight" or .is_class(value)
func get_class() -> String: return "WorldMapSignalLight"


#### BUILT-IN ####


#### VIRTUALS ####



#### LOGIC ####

func move_along_path(move_path: PoolVector2Array, interpol: bool = false):
	set_visible(true)
	.move_along_path(move_path, interpol)
	
	yield(self, "path_finished")
	queue_free()


#### INPUTS ####



#### SIGNAL RESPONSES ####
