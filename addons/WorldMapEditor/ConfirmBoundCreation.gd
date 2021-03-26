tool
extends ConfirmationDialog
class_name ConfirmBoundCreation

#### ACCESSORS ####

func is_class(value: String): return value == "ConfirmBoundCreation" or .is_class(value)
func get_class() -> String: return "ConfirmBoundCreation"


#### BUILT-IN ####

func _ready() -> void:
	for option in $VBoxContainer/HBoxContainer.get_children():
		var __ = option.connect("option_chose", self, "_on_option_chose")

#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_option_chose(option: MenuOptionsBase):
	match(option.name):
		"Yes": print("yes")
		"No": print("no")
