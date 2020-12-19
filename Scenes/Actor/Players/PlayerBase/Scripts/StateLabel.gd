extends Label

onready var state_node : Node = get_parent()

func _ready():
	var _err = state_node.connect("state_changed", self, "on_state_changed")

func on_state_changed(new_state: StateBase):
	text = new_state.name
