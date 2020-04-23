extends StaticBody2D

class_name Door

#### BASE CLASS FOR DOORS ####

const cls_name = "Door"

onready var animation_node = get_node_or_null("Animation")
onready var collision_node = get_node_or_null("CollisionShape2D")
onready var audio_node = get_node_or_null("AudioStreamPlayer")

export var is_open : bool = false


# Those 2 functions will be optional in godot 4.0 hopefully
func get_class():
	return cls_name


func is_class(cls):
	return cls == get_class()


func open_door():
	if animation_node != null:
		animation_node.play("default")
	
	if collision_node != null:
		collision_node.set_disabled(true)
	
	if audio_node != null:
		audio_node.play()

