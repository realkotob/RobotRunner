extends RigidBody2D

onready var animation_node = get_node("Animation")
onready var collision_node = get_node("CollisionShape2D")

func _ready():
	pass # Replace with function body.

func on_button_trigger():
	animation_node.play("default")
	collision_node.set_disabled(true)