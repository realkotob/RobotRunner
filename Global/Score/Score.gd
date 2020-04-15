extends AutoloadBase

var xion : int = 0 setget set_xion, get_xion
var materials : int = 0 setget set_materials, get_materials

var players_in_collactable_area : int = 0

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


func update_HUD_display():
	var HUD_node = get_tree().get_current_scene().find_node("HUD")
	
	var player_left_in_area : bool = players_in_collactable_area == 0
	HUD_node.set_hidden(player_left_in_area)


func on_approch_collactable():
	players_in_collactable_area += 1
	update_HUD_display()
	print_notification("A player entered the area of a collactable")


func on_approch_collactable_nomore():
	players_in_collactable_area -= 1
	if players_in_collactable_area < 0:
		players_in_collactable_area = 0
	update_HUD_display()
	print_notification("A player exited the area of a collactable")
