extends MenuBase

class_name SaveConfirmMenu

onready var currentsave_container_node = $SaveInformations/CurrentSave
onready var lineedit_csavename_node = $SaveInformations/CurrentSave/HBoxContainer/SaveNameField
onready var label_csavetime_node = $SaveInformations/CurrentSave/c_savetime
onready var label_csavelevel_node = $SaveInformations/CurrentSave/c_savelevel

onready var targetsave_container_node = $SaveInformations/TargetSave
onready var label_tsavename_node = $SaveInformations/TargetSave/t_savename
onready var label_tsavetime_node = $SaveInformations/TargetSave/t_savetime
onready var label_tsavelevel_node = $SaveInformations/TargetSave/t_savelevel

var save_id : int
var savefile_array : Array
var savefile_path : String

#### ACCESSORS ####

func is_class(value: String):
	return value == "" or .is_class(value)

func get_class() -> String:
	return ""

#### BUILT-IN ####

func _ready():
	save_id = GAME._settings["system"]["slot_id"]
	savefile_array = GameSaver.find_all_saves_directories()
	savefile_path = GameSaver.find_corresponding_save_file(savefile_array, save_id)
	update_menu_labels()
	
	if "namestaken_info_node" in lineedit_csavename_node:
		lineedit_csavename_node.namestaken_info_node = $SaveInformations/CurrentSave/c_savenamestaken
	if "submitsave_button" in lineedit_csavename_node:
		lineedit_csavename_node.submitsave_button = $"HBoxContainer/V_OptContainer/Confirm Save"

#### LOGIC ####

func update_menu_labels():
	update_currentsave_informations()
	
	if savefile_path == "": #User will not overwrite any save if he confirms, hide targetsave container
		targetsave_container_node.visible = false
	else: #User will overwrite a save if he confirms ! > Display target save informations
		update_targetsave_informations()

func update_currentsave_informations():
	label_csavetime_node.text = label_csavetime_node.text + str(OS.get_datetime().get("day")) + "/" + str(OS.get_datetime().get("month"))  +  "/" + str(OS.get_datetime().get("year")) + " " + str(OS.get_datetime().get("hour")) + "h" + str(OS.get_datetime().get("minute")) + ":" + str(OS.get_datetime().get("second"))
	label_csavelevel_node.text = label_csavelevel_node.text + "Level " + str(GAME.progression.get_level() + 1)
	
func update_targetsave_informations():
	var target_cfg_save_time : Dictionary = {}
	target_cfg_save_time = GameSaver.get_save_cfg_property_value_by_name_and_cfgid("time",save_id)
	label_tsavename_node.text = label_tsavename_node.text  + savefile_path
	label_tsavetime_node.text = label_tsavetime_node.text + str(target_cfg_save_time.get("day")) + "/" + str(target_cfg_save_time.get("month"))  +  "/" + str(target_cfg_save_time.get("year")) + " " + str(target_cfg_save_time.get("hour")) + "h" + str(target_cfg_save_time.get("minute")) + ":" + str(target_cfg_save_time.get("second"))
	label_tsavelevel_node.text = label_tsavelevel_node.text + "Level " + str(GameSaver.get_save_cfg_property_value_by_name_and_cfgid("level_id",save_id))

func submit_and_save_game():
	var save_name : String = lineedit_csavename_node.text
	save_name = save_name.replacen(" ", "_")
	
	if save_name == "":
		save_name = "save" + str(save_id)

	if savefile_path != "":
		var dir = Directory.new()
		var error
		for folder in savefile_array:
			error = GAME._config_file.load(GameSaver.SAVEGAME_DIR + "/" + folder + "/settings.cfg")
			if error == OK:
				var existing_save_id : int = GAME._config_file.get_value("system","slot_id")
				
				if save_id == existing_save_id:
					if dir.open("res://saves/" + folder) == OK:
						dir.remove("res://saves/" + folder + "/settings.cfg")
						dir.remove("res://saves/" + folder + "/SavedLevel.tscn")
						dir.remove("res://saves/" + folder)
	
	GameSaver.create_dirs(GameSaver.SAVEGAME_DIR, [save_name])
	GameSaver.save_settings(GameSaver.SAVEGAME_DIR + "/" + save_name, save_name)
	copy_saved_level_tscn(save_name)

# IMPORTANT WARNING # IMPORTANT WARNING # IMPORTANT WARNING # IMPORTANT WARNING # IMPORTANT WARNING #
#############################################################################################################
### ISSUE WITH THIS METHOD WHICH WILL BE IGNORED LATER :                                                  ###
### SAVING A LEVEL AFTER REACHING A CHECKPOINT                                                            ###
### (SO AFTER THAT THE SAVED LEVEL GOT GENERATED IN Scenes/Levels/SavedLevels/tscn/LevelXX.tscn)          ###
### REBOOTING THE GAME, LOADING SAVE (= LOAD SAVEDLEVEL IN SAVEDIRECTORY/SavedLevel.tscn)                 ###
### AND SAVING AGAIN WILL BREAK THE GAME BECAUSE EVERY FOLDERS IN Scenes/Levels/SavedLevels/json + /tscn  ###
### WILL BE REMOVED AT GAME LAUNCH, SO THE SAVE FOLDER WILL ONLY CONTAIN A SINGLE CFG FILE                ###
#############################################################################################################

# Solution :
## It will be solved thanks to the future saving system :
## We will automatically save the game after a level is finished by players
## This feature can be disabled by players in option menu

# IMPORTANT WARNING # IMPORTANT WARNING # IMPORTANT WARNING # IMPORTANT WARNING # IMPORTANT WARNING # 
func copy_saved_level_tscn(save_name : String):
	var levels_save_dir = GameSaver.SAVEDLEVEL_DIR + GameSaver.SAVEDLEVEL_TSCN_DIR
	var copy_destination : String = GameSaver.SAVEGAME_DIR+ "/" + save_name + "/"
	var tscn_level_to_copy : String = GAME.find_saved_level_path(levels_save_dir, GAME.current_chapter.get_level_name(int(GameSaver.get_save_cfg_property_value_by_name_and_cfgid("level_id",save_id))))

	# If no save of the current level exists, reload the same scene
	if tscn_level_to_copy != "":
		var dir = Directory.new()
		var _err = dir.open(copy_destination)
		if _err == OK:
			var _cpyerr = dir.copy(tscn_level_to_copy, copy_destination + "SavedLevel.tscn")
			if _cpyerr != OK:
				print("Cannot copy destination. Error Code : " + str(_cpyerr))
				print("Error returned by SaveConfirm.gd Method Line 80 - Print Line 92+93")
		else:
			print("Cannot open copy destination. Error Code : " + str(_err))
			print("Error returned by SaveConfirm.gd Method Line 80 - Print Line 95+96")

#### VIRTUALS ####


#### INPUTS ####



#### SIGNAL RESPONSES ####
func _on_menu_option_chose(option) -> void:
	match(option.get_name()):
		"Cancel":
			get_tree().set_pause(false)
			queue_free()
		"Confirm Save":
			submit_and_save_game()
