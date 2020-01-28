extends Node2D

onready var sprite_node = get_node("Sprite")

func _ready():
	sprite_node.set_visible(false)