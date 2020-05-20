extends Label

var state_node : Node

func setup():
	var _err = state_node.connect("state_change", self, "on_state_change")

func on_state_change():
	text = state_node.get_state_name()
