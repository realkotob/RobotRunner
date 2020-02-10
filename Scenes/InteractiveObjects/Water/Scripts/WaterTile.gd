extends InteractAreaBase


class_name Water
const CLASS_NAME = "Water"

onready var iceblock_scene = load("res://Scenes/InteractiveObjects/BreakableObjects/IceBlock/M/MIceBlock.tscn")
onready var floating_line_node = get_node("FloatingLine")
onready var water_area = get_node_or_null("CollisionShape2D")
onready var particules_node = get_node("Particles2D")

var M_IceBlocks_node : Node2D

# Return true is the given string is the name of the class 
# (Necesary in 3.2 because Godot check the very parent class instead of the current class)
func is_class(value : String):
	return value == CLASS_NAME


# Return a string of the name of the class 
# (Necesary in 3.2 because Godot check the very parent class instead of the current class)
func get_class():
	return CLASS_NAME


# Make every ice block floating while they are in the water area
func on_body_entered(body):
	if body.is_class("IceBlock"):
		body_floating(body, true)
		
	if body is RigidBody2D or body is KinematicBody2D:
		particules_node.global_position.x = body.global_position.x
		particules_node.set_emitting(true)


# Whenever a body exits the area of this interact object, set his interact reference to null
func on_body_exited(body):
	if body.is_class("IceBlock"):
		body_floating(body, false)


# Create an ice block on interaction, the position of the hit box has to be inside the water area to truly happen
func interact(global_pos : Vector2):
	if water_area != null:
		if is_position_in_area(global_pos, water_area):
			M_IceBlocks_node = iceblock_scene.instance()
			
			add_child(M_IceBlocks_node)
			M_IceBlocks_node.set_global_position(global_pos)
			body_floating(M_IceBlocks_node, true)


# Return true if the given position is inside the given area, false if not
func is_position_in_area(pos: Vector2, collision_shape : CollisionShape2D) -> bool:
	var shape_pos = collision_shape.get_global_position()
	var shape_ext = collision_shape.get_shape().get_extents()
	
	return pos.y > shape_pos.y - shape_ext.y && pos.y < shape_pos.y + shape_ext.y && pos.x > shape_pos.x - shape_ext.x && pos.x < shape_pos.x + shape_ext.x


# Setup the floating on the given body
func body_floating(body : PhysicsBody2D, float_or_not : bool):
	body.is_floating = float_or_not
	
	if float_or_not == true:
		body.floating_line_y = floating_line_node.global_position.y
