extends BreakableObjectBase

class_name BlockBase

onready var audio_node = $AudioStreamPlayer

func _ready():
	audio_node.connect("finished", self, "on_audiostream_finished")


# When the block is destroyed, lauch the destroy animation
func destroy(_actor_destroying: Node = null):
	awake_nearby_bodies()
	audio_node.play()
	sprite_node.set_visible(false)
	set_mode(RigidBody2D.MODE_STATIC)
	collision_shape_node.set_disabled(true)
	$Particles2D.set_emitting(true)
	SFX.scatter_sprite(self, nb_debris, explosion_impulse)
	SFX.scatter_sprite(self, int(nb_debris / 6), explosion_impulse * 0.7)


func on_audiostream_finished():
	queue_free()
