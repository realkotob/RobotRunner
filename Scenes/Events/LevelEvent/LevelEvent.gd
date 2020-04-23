extends Event

export var target_name : String = ""
export var target_as_group : bool = false
export var method_name : String = ""
export var arguments_array : Array = []
export var queue_free_after_trigger : bool = true

func event():
	if target_name == "" or method_name == "":
		print("ERROR : The event %s has an undefined target and/or method to call" % name)
		return
	
	var target_array : Array = []
	if target_as_group:
		target_array = get_tree().get_nodes_in_group(target_name)
	else:
		target_array.append(get_tree().get_current_scene().find_node(target_name))
	
	for target in target_array:
		if target.has_method(method_name):
			var call_def_funcref := funcref(target, "call_deferred")
			arguments_array.push_front(method_name)
			call_def_funcref.call_funcv(arguments_array)
	
	if queue_free_after_trigger:
		queue_free()
