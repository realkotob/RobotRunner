extends MenuBase

#### ACCESSORS ####

func is_class(value: String):
	return value == "" or .is_class(value)

func get_class() -> String:
	return ""

#### BUILT-IN ####



#### LOGIC ####

func save_game_into_slot(slot_saved_id : int):
	print("A game has been saved into Slot ID:",slot_saved_id,"]")

#### VIRTUALS ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
func _on_menu_option_chose(option: MenuOptionsBase):
	save_game_into_slot(option.get_index()+1)
