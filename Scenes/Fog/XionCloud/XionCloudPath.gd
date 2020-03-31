extends Path2D

onready var xion_cloud_node = $XionCloud

var path : PoolVector2Array = []

export var cloud_active : bool = true

func _ready():
	var path_len = get_curve().get_point_count()
	for i in range(path_len):
		path.append(get_curve().get_point_position(i))
	
	set_visible(cloud_active)
	set_physics_process(cloud_active)


# Move the cloud, until it's arrived to the next point
func _physics_process(delta):
	if len(path) > 0:
		var target_point_world = path[0]
		var arrived_to_next_point = xion_cloud_node.move_to(target_point_world, scale, delta)
		
		# If the cloud is arrived to the next point, remove this point from the path and take the next for destination
		if arrived_to_next_point == true:
			path.remove(0)
	else:
		set_physics_process(false)
