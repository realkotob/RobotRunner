extends Label

onready var state_node : Node = get_parent()

func _ready():
	var _err = state_node.connect("state_changed", self, "on_state_changed")

func on_state_changed(state_name: String):
	text = state_name
