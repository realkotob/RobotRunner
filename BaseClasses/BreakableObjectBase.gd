extends RigidBody2D

class_name BreakableObjectBase

onready var animation_node = get_node_or_null("Sprite")
onready var collision_shape_node = get_node_or_null("CollisionShape2D")

func _ready():
	add_to_group("InteractivesObjects")


# Called by a character when its hitbox touches it
# By default: call the destroy method
func damage():
	destroy()


# Function called to destroy an object
# By default: simply queue free the object
func destroy():
	queue_free()
