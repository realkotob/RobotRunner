extends MenuBase
class_name ScreenTitleMenu

onready var infinite_level_scene = preload("res://Scenes/Levels/InfiniteMode/InfiniteLevel.tscn")
onready var seed_field = $HBoxContainer/V_OptContainer/InfiniteMode/SeedField

#### ACCESSORS ####

func is_class(value: String): return value == "ScreenTitleMenu" or .is_class(value)
func get_class() -> String: return "ScreenTitleMenu"

#### BUILT-IN ####

func _ready():
	var _err = RESOURCE_LOADER.connect("thread_finished", self, "on_thread_finished")
	load_default_buttons_state()
	
	if RESOURCE_LOADER.thread != null && RESOURCE_LOADER.thread.is_active():
		set_buttons_disabled(true)
	else:
		._setup()

## FUNCTION OVERRIDE ##
# This need to stay empty
func _setup():
	pass

#### LOGIC ####



#### VIRTUALS ####



#### INPUTS ####



#### SIGNAL RESPONSES ####

func on_thread_finished():
	set_buttons_default_state()
	._setup()


func _on_menu_option_chose(option: MenuOptionsBase):
	var option_name = option.name
	
	match(option_name):
		"NewGame": var _err = GAME.goto_level(1)
		"InfiniteMode": var _err = get_tree().change_scene_to(infinite_level_scene)
		"Quit": get_tree().quit()


func _on_menu_option_focus_changed(button : Button, focus: bool):
	if focus && seed_field != null:
		seed_field.set_visible(button.name == "InfiniteMode")
	._on_menu_option_focus_changed(button, focus)
