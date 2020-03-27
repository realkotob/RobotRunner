extends Node

var xion : int = 0 setget set_xion, get_xion
var materials : int = 0 setget set_materials, get_materials

signal xion_changed

func set_xion(value: int):
	xion = value
	
	# Notify the HUD that the xion value has changed
	emit_signal("xion_changed", value)


func get_xion() -> int:
	return xion
	

func set_materials(value: int):
	materials = value
	

func get_materials() -> int:
	return materials
