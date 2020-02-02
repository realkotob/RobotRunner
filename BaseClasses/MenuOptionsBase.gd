extends Node

class_name MenuOptionsBase

export var _clickable : bool setget set_clickable, get_clickable

func options_action():
	pass

func set_clickable(value: bool):
	_clickable = value

func get_clickable() -> bool:
	return _clickable
