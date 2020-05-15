extends AutoloadBase

var xion : int = 0 setget set_xion, get_xion
var materials : int = 0 setget set_materials, get_materials

var players_in_collactable_area : int = 0

signal score_changed

func set_xion(value: int):
	xion = value
	
	# Notify the HUD that the xion value has changed
	emit_signal("score_changed")


func get_xion() -> int:
	return xion
	

func set_materials(value: int):
	materials = value
	
	emit_signal("score_changed")


func get_materials() -> int:
	return materials


func on_approch_collactable():
	players_in_collactable_area += 1
	var HUD_node = get_tree().get_current_scene().find_node("HUD")
	HUD_node.set_hidden(false)
	print_notification("A player entered the area of a collactable")
