extends StaticBody2D

class_name DoorButton
const cls_name = "DoorButton"

signal button_trigger

onready var animation_node = get_node("Animation")
onready var area2D_node = get_node("Area2D")
onready var collision_shape_node = get_node("CollisionShape2D")

var players_node_array : Array
var door_node_array : Array
var collision_shape_initial_pos : Vector2

export var is_push : bool = false

func _ready():
	add_to_group("InteractivesObjects")
	collision_shape_initial_pos = collision_shape_node.position

func setup():
	var _err
	
	# Connect signals
	_err = connect("button_trigger", get_parent(), "button_triggered")
	_err = area2D_node.connect("body_entered", self, "on_body_entered")
	_err = animation_node.connect("frame_changed", self, "on_frame_change")
	_err = animation_node.connect("animation_finished", self, "on_animation_finished")

# Those 2 functions will be optional in the future
func get_class():
	return cls_name

func is_class(cls):
	return cls == get_class()

# Play the animation when a player touch the button
func on_body_entered(body):
	if body in players_node_array:
		animation_node.play()


# When the animation is finished, emit the signal, and disable the collision shape
func on_animation_finished():
	emit_signal("button_trigger")
	collision_shape_node.set_disabled(true)


# Move the shape at the same time as the sprite
func on_frame_change():
	var new_pos = collision_shape_initial_pos
	new_pos.y += (animation_node.get_frame() * 2) + 2
	collision_shape_node.set_position(new_pos)
