extends WorldMapMovingElement

#### ACCESSORS ####

func is_class(value: String): return value == "" or .is_class(value)
func get_class() -> String: return ""


#### BUILT-IN ####



#### VIRTUALS ####



#### LOGIC ####

func move_along_path(path: PoolVector2Array):
	set_visible(true)
	.move_along_path(path)
	
	yield(self, "path_finished")
	
	set_visible(false)


#### INPUTS ####



#### SIGNAL RESPONSES ####
