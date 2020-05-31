extends ActorStateBase

#### MOVE STATE ####

onready var original_pos = owner.get_global_position()
var path : Array = []


func _ready():
	yield(owner, "ready")
	if owner.path_node != null:
		path = owner.path_node.get_children()


func update(_host : Node, _delta : float):
	if path == []:
		return "Idle"
	else:
		if is_arrived(get_point_world_position(path[0])):
			var last_point = path.pop_front()
			
			# Trigger the event of the last point the free it
			var event_array = last_point.get_event()
			if event_array != [] && len(event_array) != 0:
				var method = event_array.pop_front()
				if owner.has_method(method):
					owner.callv(method, event_array)
				else:
					pass
			
			last_point.queue_free()
			
			if state_node.current_state == self:
				move_to_next_point()


func enter_state(_host : Node):
	if owner.animated_sprite_node.get_sprite_frames().has_animation(name):
		owner.animated_sprite_node.play(name)
	
	move_to_next_point()


func exit_state(_host : Node):
	owner.set_direction(Vector2.ZERO)


# Move to the next point in the path
func move_to_next_point():
	if path == []:
		return
	var dest = get_point_world_position(path[0])
	move_to(dest)


# Handle the movement to the next point on the path, return true if the node is arrived
func move_to(destination : Vector2):
	var pos = owner.global_position
	var dir = pos.direction_to(destination)
	owner.set_direction(dir)


# Returns the world position of the given point
func get_point_world_position(point: Position2D) -> Vector2:
	return original_pos + point.get_global_position()


# Check if the actor is arrived at the given position
func is_arrived(destination: Vector2) -> bool:
	return owner.global_position.distance_to(destination) < 1.0
