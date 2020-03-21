extends KinematicBody2D

class_name CollactableBase

var aimed_character : Node

export var speed : int = 300

var initial_velocity := Vector2.ZERO
var velocity := Vector2.ZERO

var initial_impulse : bool = true

func _physics_process(_delta):
	if aimed_character != null:
		if initial_impulse == false:
			var direction = position.direction_to(aimed_character.position)
			velocity = direction * speed
		else :
			velocity = initial_velocity
		
		var _err = move_and_slide(velocity)
		if position.distance_to(aimed_character.position) < 10:
			contact_with_player()


func contact_with_player():
	queue_free()
