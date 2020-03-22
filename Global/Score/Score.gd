extends Node

var xion : int = 0 setget set_xion, get_xion
var materials : int = 0 setget set_materials, get_materials

func set_xion(value: int):
	xion = value

func get_xion() -> int:
	return xion

func set_materials(value: int):
	materials = value

func get_materials() -> int:
	return materials
