extends Node2D

onready var camera_node = get_node("Camera")
onready var main_node = get_parent()

func _ready():
	var _err = camera_node.connect("loose_condition", self, "on_loose_condition")

func on_loose_condition():
	main_node.game_over()
