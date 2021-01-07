extends MenuBase

class_name SaveLoader

####### REMINDER #######
# This is the SaveLoader script
# It will get the signal of a loaded save and load all necessary resources
# Signal which will be emetted by SAVE_1/2/3 buttons (MenuOptionsBase)

#### ACCESSORS ####

func is_class(value: String):
	return value == "" or .is_class(value)

func get_class() -> String:
	return ""

#### BUILT-IN ####

func _ready():
	var _err = connect("save_loaded",self,"_on_save_loaded")

#### LOGIC ####

func load_save(save_to_load_id : int):
	print("A save has been loaded [ID:",save_to_load_id,"]")

#### VIRTUALS ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
func _on_menu_option_chose(option: MenuOptionsBase):
	load_save(option.get_index()+1)
