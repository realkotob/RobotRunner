extends Object
class_name ChunckPath

var path_array : PoolVector2Array = []
var entry_id : int = 0
var exit_id : int = 0

#### CONSTRUCTOR ####

func _init(entry_index: int, exit_index: int, path: PoolVector2Array):
	path_array = path
	entry_id = entry_index
	exit_id = exit_index


#### ACCESSORS ####

func is_class(value: String):
	return value == "ChunckPath" or .is_class(value)

func get_class() -> String:
	return "ChunckPath"

#### BUILT-IN ####



#### LOGIC ####



#### VIRTUALS ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
