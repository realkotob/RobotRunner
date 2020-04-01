extends Node2D

onready var area_node = $Area2D
onready var path_node = get_node_or_null("CloudPath")

export var speed : float = 40.0 

var path : PoolVector2Array = []

export var cloud_active : bool = true

func _ready():
	var _err = area_node.connect("body_entered", self, "on_body_entered")
	_err = area_node.connect("body_exited", self, "on_body_exited")
	
	if path_node != null:
		var path_len = path_node.get_curve().get_point_count()
		for i in range(path_len):
			path.append(path_node.get_curve().get_point_position(i))
		
		set_physics_process(cloud_active)
	
	set_visible(cloud_active)


# Move the cloud, until it's arrived to the next point
func _physics_process(delta):
	if len(path) > 0:
		var target_point_world = path[0]
		var arrived_to_next_point = move_to(target_point_world, scale, delta)
		
		# If the cloud is arrived to the next point, remove this point from the path and take the next for destination
		if arrived_to_next_point == true:
			path.remove(0)
	else:
		set_physics_process(false)


# Triggers the overheat if a player enters the cloud
func on_body_entered(body: Node):
	if body.is_class("Player"):
		body.overheat()


# Stop the overheat animation when a player exits the cloud
func on_body_exited(body: Node):
	if body.is_class("Player"):
		body.stop_overheat()


# Handle the movement to the next point on the path, return true if the node is arrived
func move_to(destination : Vector2, path_scale: Vector2, delta: float):
	var velocity = (destination - position).normalized() * speed * delta
	var avrg_scale = (path_scale.x + path_scale.y) / 2
	
	if position.distance_to(destination) <= speed * delta / avrg_scale:
		position = destination
	else:
		position += velocity / path_scale
	
	return destination == position
