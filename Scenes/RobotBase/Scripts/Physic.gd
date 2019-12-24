extends Node

var attributes_node : Node
var character_node : KinematicBody2D
var direction_node : Node
var animation_node : AnimatedSprite
var hit_box_node : Area2D

const GRAVITY : int = 30

func _physics_process(_delta):
	var dir = direction_node.get_move_direction()
	var spd = attributes_node.speed
	
	attributes_node.velocity.x = dir * spd
	
	if abs(attributes_node.velocity.x) > 10.0:
		animation_node.flip_h = attributes_node.velocity.x < 0.0
	hit_box_node.get_child(0).position *= dir
	
	attributes_node.velocity.y += GRAVITY
	attributes_node.velocity = character_node.move_and_slide(attributes_node.velocity, Vector2.UP)