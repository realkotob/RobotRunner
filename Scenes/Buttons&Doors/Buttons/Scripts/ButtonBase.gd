extends Area2D

signal button_trigger

onready var animation_node = get_node("Animation")
onready var door_node = get_node("../Door")

func _ready():
	var _err
	_err = connect("button_trigger", door_node, "on_button_trigger")
	_err = connect("body_entered", self, "on_body_entered")

func on_body_entered(_body):
	animation_node.play("default")

func on_animation_finished():
	emit_signal("button_trigger")