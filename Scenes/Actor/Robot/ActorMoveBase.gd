extends ActorStateBase

#### MOVE STATE ####

var path : Array = []
var path_points_array : Array = []

func _ready():
	yield(owner, "ready")
	if owner.path_node != null:
		path = owner.path_node.get_children()
		for point in path:
			path_points_array.append(point.global_position)


func update(_host : Node, _delta : float):
	if len(path) == 0:
		return "Idle"
	else:
		if move_to(path_points_array[0]) == true:
			path_points_array.pop_front()
			var last_point = path.pop_front()
			
			# Trigger the event of the last point the free it
			var event_array = last_point.get_event()
			if event_array != []:
				owner.callv("call_deferred", event_array)
			
			last_point.queue_free()


func enter_state(_host : Node):
	if owner.animated_sprite_node.get_sprite_frames().has_animation(name):
		owner.animated_sprite_node.play(name)


func exit_state(_host : Node):
	pass


# Handle the movement to the next point on the path, return true if the node is arrived
func move_to(destination : Vector2):
	var pos = owner.global_position
	var dir = pos.direction_to(destination)
	owner.set_direction(dir)
	owner.move()
	
	return owner.global_position.distance_to(destination) < 3.0
