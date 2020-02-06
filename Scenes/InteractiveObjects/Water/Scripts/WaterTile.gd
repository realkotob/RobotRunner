extends InteractAreaBase

class_name Water
const CLASS_NAME = "Water"

onready var iceblock_scene = load("res://Scenes/InteractiveObjects/BreakableObjects/IceBlock/M/MIceBlock.tscn")
onready var floating_line_node = get_node("FloatingLine")
#onready var water_area = get_node("CollisionShape2D")

var M_IceBlocks_node : Node2D

func is_class(value : String):
	return value == CLASS_NAME

func get_class():
	return CLASS_NAME


# Make every ice block floating while they are in the water area
func on_body_entered(body):
	if body.is_class("IceBlock"):
		body_floating(body, true)


# Whenever a body exits the area of this interact object, set his interact reference to null
func on_body_exited(body):
	if body.is_class("IceBlock"):
		body_floating(body, false)


# Create an ice block on interaction
func interact(_pos : Vector2):
	M_IceBlocks_node = iceblock_scene.instance()
#	M_IceBlocks_node.set_global_position(pos)
	M_IceBlocks_node.set_rigid()
	
	add_child(M_IceBlocks_node)
	body_floating(M_IceBlocks_node, true)


# Setup the floating on the given body
func body_floating(body : PhysicsBody2D, float_or_not : bool):
	body.is_floating = float_or_not
	
	if float_or_not == true:
		body.floating_line_y = floating_line_node.global_position.y
