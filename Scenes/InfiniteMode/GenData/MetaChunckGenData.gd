extends ChunckGenData
class_name MetaChunckGenData

var nb_test : int = 0
var total_time : float = 0.0

#### ACCESSORS ####



#### BUILT-IN ####



#### LOGIC ####

# function overide
func print_data():
	print(" ")
	print("Generating "  + String(nb_test) + " chuncks took " + String(total_time / 1000) + "s")
	print("Average numbers of generation per chunck: " + String(float(generations) / nb_test))
	print("Average time per generation: " + String(float(total_time) / generations) + "ms")
	print("Average too_few_entries per chunck: " + String(float(too_few_entries) / nb_test))
	print("Average too_few_exits per chunck: " + String(float(too_few_exits) / nb_test))
	print("Average too_few_path per chunck: " + String(float(too_few_path) / nb_test))
	print("Average time per chunck: " + String(float(total_time) / nb_test) + "ms")
	print(" ")

#### VIRTUALS ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
