extends RigidBody2D

class_name BreakableObjectBase

onready var sprite_node = get_node_or_null("Sprite")
onready var collision_shape_node = get_node_or_null("CollisionShape2D")

export (int, 5, 40) var nb_debris = 10
export (float, 10.0, 500.0) var explosion_impulse = 80.0

func _ready():
	add_to_group("InteractivesObjects")


# Called by a character when its hitbox touches it
# By default: call the destroy method
func damage(actor_damaging : Node = null):
	destroy(actor_damaging)


# Function called to destroy an object
# By default: simply queue free the object
func destroy(_actor_destroying : Node = null):
	queue_free()
