extends Path2D

onready var xion_cloud_node = $XionCloud

var path : PoolVector2Array = []

func _ready():
	var path_len = get_curve().get_point_count()
	for i in range(path_len):
		path.append(get_curve().get_point_position(i))

#func _physics_process(delta):
#	path_follow_node.set_unit_offset(path_follow_node.get_unit_offset() + (cloud_speed / 1000) * delta)


# Move the cloud, until it's arrived to the next point
func _physics_process(delta):
	if len(path) > 0:
		var target_point_world = path[len(path) - 1]
		var arrived_to_next_point = xion_cloud_node.move_to(target_point_world, delta)
		
		# If the cloud is arrived to the next point, remove this point from the path and take the next for destination
		if arrived_to_next_point == true:
			path.remove(len(path) - 1)
	else:
		set_physics_process(false)
