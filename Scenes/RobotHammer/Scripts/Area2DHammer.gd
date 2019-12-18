extends Area2D

func _ready():
	var _err = connect("body_entered", self, "on_body_entered")

func on_body_entered(body):
	var breakable_objects_array : Array = get_tree().get_nodes_in_group("Breakable")
	
	if body in breakable_objects_array:
		body.queue_free()