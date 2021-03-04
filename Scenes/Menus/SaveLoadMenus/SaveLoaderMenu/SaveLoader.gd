extends MenuBase
class_name SaveLoader

#### ACCESSORS ####

func is_class(value: String):
	return value == "" or .is_class(value)

func get_class() -> String:
	return ""

#### BUILT-IN ####

#### LOGIC ####

func load_save(path : String):
	GameSaver.load_settings(path)

#### VIRTUALS ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
func _on_menu_option_chose(option: MenuOptionsBase):
	if option is SaveLoadButtonBase:
		load_save(GameSaver.SAVEGAME_DIR + "/save" + str(option.get_index()+1))
	else:
		match(option.get_name()):
			"BackToMenu":
				navigate_sub_menu(MENUS.title_screen_scene.instance())
