extends Node

onready var attributes_node = get_parent()
onready var character_node = get_parent().get_parent()
onready var direction_node = get_parent().get_node("Direction")
onready var animation_node = character_node.get_node("Animation")
onready var area2d_node = character_node.get_node("HitBox")

const GRAVITY : int = 30

func _physics_process(_delta):
	var dir = direction_node.get_direction()
	var spd = attributes_node.speed
	
	attributes_node.velocity.x = dir * spd
	
	if abs(attributes_node.velocity.x) > 10.0:
		animation_node.flip_h = attributes_node.velocity.x < 0.0
	area2d_node.get_child(0).position *= dir
	
	attributes_node.velocity.y += GRAVITY
	attributes_node.velocity = character_node.move_and_slide(attributes_node.velocity, Vector2.UP)