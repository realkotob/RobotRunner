extends KinematicBody2D

class_name CollactableBase

var aimed_character : Node

export var speed : int = 20

var initial_velocity := Vector2.ZERO
var velocity := Vector2.ZERO

func _physics_process(_delta):
	if aimed_character != null:
		var direction = position.direction_to(aimed_character.position)
		velocity += direction * speed
		
		var _err = move_and_slide(velocity)
		if position.distance_to(aimed_character.position) < 30:
			queue_free()

