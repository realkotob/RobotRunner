extends MenuBase

class_name SaveLoader

####### REMINDER #######
# This is the SaveLoader script
# It will get the signal of a loaded save and load all necessary resources
# Signal which will be emetted by SAVE_1/2/3 buttons (MenuOptionsBase)

signal save_loaded

#### ACCESSORS ####

func is_class(value: String):
	return value == "" or .is_class(value)

func get_class() -> String:
	return ""

#### BUILT-IN ####

func _ready():
	var _err = connect("save_loaded",self,"_on_save_loaded")

#### LOGIC ####



#### VIRTUALS ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
func _on_menu_option_chose(option: MenuOptionsBase):
	var _err = null
	
	if option.get("save_id"):
		_err = emit_signal("save_loaded",option.save_id)
	
	
func _on_save_loaded(save_id : int):
	print("A save has been loaded [ID:",save_id,"]")
