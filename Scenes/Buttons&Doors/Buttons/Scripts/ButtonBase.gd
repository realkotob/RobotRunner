extends Area2D

signal button_trigger

onready var animation_node = get_node("Animation")

var door_node_array : Array

func setup():
	var _err
	for door in door_node_array:
		_err = connect("button_trigger", door, "on_button_trigger")
	_err = connect("body_entered", self, "on_body_entered")

func on_body_entered(_body):
	animation_node.play("default")

func on_animation_finished():
	emit_signal("button_trigger")