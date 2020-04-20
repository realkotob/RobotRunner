extends RigidBody2D

class_name BreakableObjectBase

onready var sprite_node = get_node_or_null("Sprite")
onready var collision_shape_node = get_node_or_null("CollisionShape2D")
onready var awake_area_node = get_node_or_null("AwakeArea")

export (int, 5, 40) var nb_debris = 10
export (float, 10.0, 500.0) var explosion_impulse = 80.0

func _ready():
	add_to_group("InteractivesObjects")
	var _err = connect("sleeping_state_changed", self, "on_sleeping_state_changed")


# Called by a character when its hitbox touches it
# By default: call the destroy method
func damage(actor_damaging : Node = null):
	destroy(actor_damaging)


# Function called to destroy an object
# Warn every body in the area that this one was destroyed, and then queue free
func destroy(_actor_destroying : Node = null):
	queue_free()
	awake_nearby_bodies()


# Awake bodies in the area, so they can fall, if needed
func awake_nearby_bodies():
	var bodies_nearby = awake_area_node.get_overlapping_bodies()
	for body in bodies_nearby:
		if body is RigidBody2D && body != self:
			if body.has_method("awake"):
				body.call_deferred("awake")


# Awake this instance, generaly called by a sourrounding body been destoyed
func awake():
	if get_mode() != RigidBody2D.MODE_STATIC:
		return
	
	awake_nearby_bodies()
	set_mode(RigidBody2D.MODE_RIGID)
	set_sleeping(false)


# Set the mode back to static mode when the body is sleeping
func on_sleeping_state_changed():
	if is_sleeping():
		set_mode(RigidBody2D.MODE_STATIC)
