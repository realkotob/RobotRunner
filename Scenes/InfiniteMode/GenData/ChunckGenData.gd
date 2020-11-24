extends Object
class_name ChunckGenData

var too_few_entries : int = 0
var too_few_exits : int = 0
var too_few_path : int = 0 

var generations : int = 0

#### ACCESSORS ####



#### BUILT-IN ####



#### LOGIC ####

func print_data() -> void:
	print(" ")
	for variable_dict in get_script().get_script_property_list():
		var variable_name = variable_dict["name"]
		print(variable_name + " : " + String(get(variable_name)))

#### VIRTUALS ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
