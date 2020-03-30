extends Node2D

onready var area_node = $Area2D

export var speed : float = 40.0 

func _ready():
	var _err = area_node.connect("body_entered", self, "on_body_entered")
	_err = area_node.connect("body_exited", self, "on_body_exited")


# Triggers the overheat if a player enters the cloud
func on_body_entered(body: Node):
	if body.is_class("Player"):
		body.overheat()


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
