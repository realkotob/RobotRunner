extends MenuBase

class_name SlotSaver

var myInputMapper = InputMapper.new()

#### ACCESSORS ####

func is_class(value: String):
	return value == "" or .is_class(value)

func get_class() -> String:
	return ""

#### BUILT-IN ####

#### LOGIC ####

func save_game_into_slot(slot_saved_id : int, path : String):
	GameSaver.create_dirs(GameSaver.SAVEGAME_DIR, ["save" + str(slot_saved_id)])
	GameSaver.save_settings(path)

func resume_game():
	get_tree().set_pause(false)
	queue_free()

#### VIRTUALS ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
func _on_menu_option_chose(option: MenuOptionsBase):
	if option is SaveLoadButtonBase:
		save_game_into_slot(option.get_index()+1, GameSaver.SAVEGAME_DIR + "/save" + str(option.get_index()+1))
	else:
		match(option.get_name()):
			"Resume":
				resume_game()
