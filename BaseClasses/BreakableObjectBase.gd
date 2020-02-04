extends RigidBody2D

class_name BreakableObjectBase

onready var animation_node = get_node("Sprite")
onready var collision_shape_node = get_node("CollisionShape2D")

func _ready():
	add_to_group("InteractivesObjects")
