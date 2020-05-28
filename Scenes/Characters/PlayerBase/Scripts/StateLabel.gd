extends Label

onready var state_node : Node = get_parent()

func _ready():
	var _err = state_node.connect("state_change", self, "on_state_change")

func on_state_change():
	text = state_node.get_state_name()
