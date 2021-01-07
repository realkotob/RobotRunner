extends Node

class_name SaveLoader

####### REMINDER #######
# This is the SaveLoader script
# It will get the signal of a loaded save and load all necessary resources
# Signal which will be emetted by SAVE_1/2/3 buttons (MenuOptionsBase)

signal save1_loaded
signal save2_loaded
signal save3_loaded

#### ACCESSORS ####

func is_class(value: String):
	return value == "" or .is_class(value)

func get_class() -> String:
	return ""

#### BUILT-IN ####



#### LOGIC ####



#### VIRTUALS ####



#### INPUTS ####



#### SIGNAL RESPONSES ####

func on_save_loaded(save_id : int):
	print("A save has been loaded")
