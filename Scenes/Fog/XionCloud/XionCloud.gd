extends Node2D

onready var area_node = $Area2D

export var speed : float = 5.0 

func _ready():
	var _err = area_node.connect("area_entered", self, "on_area_entered")


func on_area_entered(body : Node):
	if body.is_class("Player"):
		print("A player enters the area")


# Handle the movement to the next point on the path, return true if the node is arrived
func move_to(destination : Vector2, delta: float):
	var velocity = (destination - position).normalized() * speed * delta
	
	if position.distance_to(destination) <= speed * delta:
		position = destination
	else:
		position += velocity
	
	return destination == position
