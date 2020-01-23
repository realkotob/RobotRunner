extends StaticBody2D

signal button_trigger

onready var animation_node = get_node("Animation")
onready var area2D_node = get_node("Area2D")
onready var collision_shape_node = get_node("CollisionShape2D")
onready var robot_array = get_tree().get_nodes_in_group("Players")

var door_node_array : Array
var collision_shape_initial_pos : Vector2

func _ready():
	collision_shape_initial_pos = collision_shape_node.position

func setup():
	var _err
	
	# Connect signals
	for door in door_node_array:
		_err = connect("button_trigger", door, "on_button_trigger")
	_err = area2D_node.connect("body_entered", self, "on_body_entered")
	_err = animation_node.connect("frame_changed", self, "on_frame_change")


func on_body_entered(body):
	if body in robot_array:
		animation_node.play("default")

func on_animation_finished():
	emit_signal("button_trigger")
	collision_shape_node.set_disabled(true)

func on_frame_change():
	var new_pos = collision_shape_initial_pos
	new_pos.y += (animation_node.get_frame() * 2) + 2
	collision_shape_node.set_position(new_pos)