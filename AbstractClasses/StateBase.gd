extends Node

class_name StateBase

onready var states_node = get_parent()

func update(_host : Node, _delta : float):
	pass

func enter_state(_host : Node):
	pass

func exit_state(_host : Node):
	pass
