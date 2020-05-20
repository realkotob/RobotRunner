extends BreakableObjectBase

class_name BlockBase

func _ready():
	audio_node.connect("finished", self, "on_audiostream_finished")

# Overwrite the on_destruction so the queue_free happens elsewhere
func on_destruction(_actor_destroying : Node = null):
	pass

func on_audiostream_finished():
	queue_free()
