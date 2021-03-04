extends SceneFinder
class_name Resource_Loader

var thread : Thread = null
var resource_array : Array = []

signal thread_finished

#### ACCESSORS ####



#### BUILT-IN ####

func _ready():
	thread = Thread.new()
	
	var err = thread.start(self, "load_resources")
	if debug:
		if err == ERR_CANT_CREATE:
			print("Thread can't be created")
		else:
			print("Thread created sucesfully")




#### LOGIC ####


func load_resources(_userdata):
	for scene in target_array:
		resource_array.append(load(scene))
		yield(get_tree(), "idle_frame")
	if debug:
		print("Resource loading finished")
	
	thread.wait_to_finish()
	emit_signal("thread_finished")
	thread = null


#### VIRTUALS ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
