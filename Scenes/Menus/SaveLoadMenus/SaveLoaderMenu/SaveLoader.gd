extends MenuBase

class_name SaveLoader

#### ACCESSORS ####

func is_class(value: String):
	return value == "" or .is_class(value)

func get_class() -> String:
	return ""

#### BUILT-IN ####

#### LOGIC ####

func load_save(save_to_load_id : int):
	print("A save has been loaded [ID:",save_to_load_id,"]")

#### VIRTUALS ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
func _on_menu_option_chose(option: MenuOptionsBase):
	if option is SaveLoadButtonBase:
		load_save(option.get_index()+1)
	else:
		match(option.get_name()):
			"BackToMenu":
				navigate_sub_menu(MENUS.title_screen_scene.instance())
