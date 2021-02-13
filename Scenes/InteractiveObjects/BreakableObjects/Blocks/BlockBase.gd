extends BreakableObjectBase
class_name BlockBase

export var block_size := Vector2(48, 48)

#### ACCESSORS ####

func is_class(value: String):
	return value == "BlockBase" or .is_class(value)

func get_class() -> String:
	return "BlockBase"


#### BUILT-IN ####

func _ready():
	audio_node.connect("finished", self, "on_audiostream_finished")


#### LOGIC ####

# Overwrite the on_destruction so the queue_free happens elsewhere
func on_destruction(_actor_destroying : Node = null):
	pass

func on_audiostream_finished():
	queue_free()
