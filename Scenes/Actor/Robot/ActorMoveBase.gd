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



func update(_host : Node, delta : float):
	if len(path) == 0:
		return "Idle"
	else:
		if move_to(path_points_array[0], owner.speed, delta) == true:
			path_points_array.pop_front()
			var last_point = path.pop_front()
			var event = last_point.event().to_lower()
			if event != "":
				owner.call_deferred(event)
			
			last_point.queue_free()


func enter_state(_host : Node):
	if owner.animated_sprite_node.get_sprite_frames().has_animation(name):
		owner.animated_sprite_node.play(name)



func exit_state(_host : Node):
	pass


# Handle the movement to the next point on the path, return true if the node is arrived
func move_to(destination : Vector2, speed: float, delta: float):
	var pos = owner.global_position
	owner.set_velocity((destination - pos).normalized() * speed * delta)
	
	if pos.distance_to(destination) <= speed * delta:
		owner.global_position = destination
	else:
		owner.global_position += owner.get_velocity()
	
	return destination == pos