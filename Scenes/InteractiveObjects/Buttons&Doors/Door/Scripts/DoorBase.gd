extends StaticBody2D

class_name door
const cls_name = "door"

onready var animation_node = get_node("Animation")
onready var collision_node = get_node("CollisionShape2D")
onready var audio_node = get_node("AudioStreamPlayer")

export var is_open : bool = false

func open_door():
	animation_node.play("default")
	collision_node.set_disabled(true)
	audio_node.play()

# Those 2 functions will be optional in the future
func get_class():
	return cls_name

func is_class(cls):
	return cls == get_class()
