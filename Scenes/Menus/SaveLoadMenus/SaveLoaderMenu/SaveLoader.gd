extends MenuBase

class_name SaveLoader

#### ACCESSORS ####

func is_class(value: String):
	return value == "" or .is_class(value)

func get_class() -> String:
	return ""

#### BUILT-IN ####

#### LOGIC ####

func load_save(save_to_load_id : int, path : String):
	var file_loaded = GAME._config_file.load(path + "/settings.cfg")
	
	if file_loaded != OK:
		print("ERROR, SETTINGS.CFG COULD NOT BE FOUND")
		return
	else:
		print("A save has been loaded [ID:",save_to_load_id,"]")
		var settings = GameSaver.load_settings(path + "/settings.cfg")
		for section in GAME._config_file.get_sections():
			match(section):
				"audio":
					for audio_keys in GAME._config_file.get_section_keys(section):
						#print("%s %s" % [AudioServer.get_bus_index(audio_keys.capitalize()), GAME._config_file.get_value(section, audio_keys)])
						AudioServer.set_bus_volume_db(AudioServer.get_bus_index(audio_keys.capitalize()), GAME._config_file.get_value(section, audio_keys))
				"controls":
					print("ITS CONTROL SECTION")
				_:
					print("DEFAULT MATCH SECTION STATE")
	
	print(str(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))))
	print(str(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Sounds"))))
	
#### VIRTUALS ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
func _on_menu_option_chose(option: MenuOptionsBase):
	if option is SaveLoadButtonBase:
		load_save(option.get_index()+1, GameSaver.SAVEGAME_DIR + "/save" + str(option.get_index()+1))
	else:
		match(option.get_name()):
			"BackToMenu":
				navigate_sub_menu(MENUS.title_screen_scene.instance())
