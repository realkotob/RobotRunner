extends Node

onready var children_array = get_children()

func _ready():
	play()


# Start playing every layers of music
func play():
	for child in children_array:
		child.play()


# Start playing every layers of music
func stop():
	for child in children_array:
		child.stop()


# Interpolate the volume of the given stream
func interpolate_stream_volume(stream_name : String, dest_volume: float, weight : float):
	var stream = get_node_or_null(stream_name)
	
	if stream != null:
		var current_volume = stream.get_volume_db()
		stream.set_volume_db(lerp(current_volume, dest_volume, weight))
