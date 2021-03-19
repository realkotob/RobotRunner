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
	var save_path : String = str(GameSaver.load_settings(slot_id))
	var tscn_path : String = save_path + "SavedLevel.tscn"
	
	if save_path != "Null" or save_path != "":
		var file = File.new()
		var _err = file.open(tscn_path, File.READ)
		
		if _err != OK:
			print(str(_err))
			return
		
		print("line 27 method load_save line 16 of SaveLoader.gd")
		get_tree().change_scene(tscn_path)
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

