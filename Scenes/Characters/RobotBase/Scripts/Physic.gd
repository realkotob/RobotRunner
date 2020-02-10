extends Node

export (int, 0, 200) var push = 2

var attributes_node : Node
var character_node : KinematicBody2D
var direction_node : Node
var animation_node : AnimatedSprite
var hit_box_node : Area2D
var block_counter_node : Area2D

const GRAVITY : int = 30

func _physics_process(_delta):
	var dir = direction_node.get_move_direction()
	var spd = attributes_node.speed
	
	# Compute velocity
	attributes_node.velocity.x = dir * spd
	
	# Flip the sprite in the right direction
	if abs(attributes_node.velocity.x) > 10.0:
		animation_node.flip_h = attributes_node.velocity.x < 0.0
		flip_hit_box()
	
	# Apply movement
	attributes_node.velocity.y += GRAVITY
	attributes_node.velocity = character_node.move_and_slide(attributes_node.velocity, Vector2.UP, false, 4, PI/4, false)
	
	# Apply force to bodies it hit
	for index in character_node.get_slide_count():
		var collision = character_node.get_slide_collision(index)
		if collision.collider.is_in_group("MovableBodies"):
			collision.collider.apply_central_impulse(-collision.normal * push)

# Flip the hit box shape
func flip_hit_box():
	var hit_box_shape_x_pos = hit_box_node.get_child(0).position.x
	hit_box_node.get_child(0).position.x = abs(hit_box_shape_x_pos) * direction_node.get_face_direction()
