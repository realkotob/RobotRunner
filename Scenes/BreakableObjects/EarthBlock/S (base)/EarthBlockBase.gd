extends StaticBody2D

onready var animation_node = get_node("Sprite")

func _ready():
	add_to_group("EarthBlock")

func destroy():
	animation_node.play()

func _on_animation_finished():
	queue_free()