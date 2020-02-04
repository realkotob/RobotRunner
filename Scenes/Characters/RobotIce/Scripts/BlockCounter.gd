extends Area2D

export var breakable_group : String
var breakable_items_counter : int

func _ready():
	var _err = connect("body_entered", self, "on_body_entered")
	breakable_items_counter = 0

# Check for a collision with a breakable object, and destroy it if necesary
func on_body_entered(body):
	var breakable_objects_array : Array = get_tree().get_nodes_in_group(breakable_group)
	
	if body in breakable_objects_array:
		body.destroy()
