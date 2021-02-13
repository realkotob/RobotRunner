extends DialogueEvent


func event():
	EVENTS.emit_signal("dialogue_query", dialogue_index, cut_scene)
	if target_name != "" && method_name != "":
		var camera_node = get_tree().get_current_scene().find_node("Camera")
		camera_node.call_deferred("shake", 5.0, 1.5)
		method_call()
	queue_free()
