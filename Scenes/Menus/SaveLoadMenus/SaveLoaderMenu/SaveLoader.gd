extends MenuBase
class_name SaveLoader

#### ACCESSORS ####

func is_class(value: String):
	return value == "" or .is_class(value)

func get_class() -> String:
	return ""

#### BUILT-IN ####

#### LOGIC ####

func load_save(slot_id : int):
	GameSaver.load_settings(slot_id)
	GameSaver.load_level_from_saveslot()
	queue_free()

#### VIRTUALS ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
func _on_menu_option_chose(option: MenuOptionsBase):
	match(option.get_name()):
		"BackToMenu":
			navigate_sub_menu(MENUS.title_screen_scene.instance())
		_:
			load_save(option.get_index()+1)

