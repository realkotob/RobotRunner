extends RT_ActorMoveState
class_name RobotMoveState

onready var original_pos = owner.get_global_position()

#### MOVE STATE ####

func update(_delta : float):
	if owner.is_path_empty():
		return "Idle"
	
	if owner.is_arrived(get_point_world_position(owner.path[0])):
		var last_point = owner.path.pop_front()
		
		# Trigger the event of the last point the free it
		var event_array = last_point.get_event()
		if event_array != [] && len(event_array) != 0:
			var method = event_array.pop_front()
			if owner.has_method(method):
				owner.callv(method, event_array)
			else:
				if method != "":
					print("method named " + method + " can't be found in class " + owner.name)
			
		last_point.queue_free()
		
		if states_machine.current_state == self:
			move_to_next_point()


func enter_state():
	if owner.animated_sprite_node.get_sprite_frames().has_animation(name):
		owner.animated_sprite_node.play(name)
	
	move_to_next_point()


# Move to the next point in the path
func move_to_next_point():
	if owner.is_path_empty():
		return
	var dest = get_point_world_position(owner.path[0])
	move_to(dest)


# Handle the movement to the next point on the path, return true if the node is arrived
func move_to(destination : Vector2):
	var pos = owner.global_position
	var dir = sign(pos.direction_to(destination).x)
	owner.set_direction(dir)


# Returns the world position of the given point
func get_point_world_position(point: Position2D) -> Vector2:
	return original_pos + point.get_global_position()
