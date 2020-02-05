extends Area2D

export var breakable_group : String

onready var shape_node = get_node("CollisionShape2D")

func _ready():
	var _err = connect("body_entered", self, "on_body_entered")
	shape_node.disabled = true

# Check for a collision with a breakable object, and destroy it if necesary
func on_body_entered(body):
	var breakable_objects_array : Array = get_tree().get_nodes_in_group("InteractivesObjects")
	
	if body in breakable_objects_array:
		if body.has_method("destroy"):
			body.destroy()
