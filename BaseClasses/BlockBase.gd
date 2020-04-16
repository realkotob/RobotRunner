extends BreakableObjectBase

class_name BlockBase

export (int, 5, 40) var nb_debris = 10
export (float, 10.0, 500.0) var explosion_impulse = 30.0

onready var audio_node = get_node("AudioStreamPlayer")

func _ready():
	audio_node.connect("finished", self, "on_audiostream_finished")


# When the block is destroyed, lauch the destroy animation
func destroy(_actor_destroying: Node = null):
	audio_node.play()
	sprite_node.set_visible(false)
	set_mode(RigidBody2D.MODE_STATIC)
	collision_shape_node.set_disabled(true)
	$Particles2D.set_emitting(true)
	SFX.scatter_sprite(self, nb_debris, explosion_impulse)
	SFX.scatter_sprite(self, int(nb_debris / 6), explosion_impulse * 0.7)


func on_audiostream_finished():
	queue_free()

