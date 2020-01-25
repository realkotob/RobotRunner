extends Node

export var speed : int setget set_speed, get_speed
export var jump_force : int setget set_jump_force, get_jump_force

var velocity : Vector2 setget set_velocity, get_velocity

const MAX_SPEED = 500

func set_speed(value : int):
	speed = value

func get_speed() -> int:
	return speed

func set_velocity(value : Vector2):
	velocity = value

func get_velocity() -> Vector2:
	return velocity

func set_jump_force(value : int):
	jump_force = value

func get_jump_force() -> int:
	return jump_force