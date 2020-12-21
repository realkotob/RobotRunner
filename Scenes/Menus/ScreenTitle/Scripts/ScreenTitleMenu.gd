extends MenuBase
class_name ScreenTitleMenu

onready var infinite_level_scene = preload("res://Scenes/Levels/InfiniteMode/InfiniteLevel.tscn")
onready var seed_field = $HBoxContainer/V_OptContainer/InfiniteMode/LineEdit

#### ACCESSORS ####

func is_class(value: String): return value == "ScreenTitleMenu" or .is_class(value)
func get_class() -> String: return "ScreenTitleMenu"

#### BUILT-IN ####

func _ready():
	var _err = RESOURCE_LOADER.connect("thread_finished", self, "on_thread_finished")
	_err = seed_field.connect("text_changed", self, "on_seed_field_text_changed")
	load_default_buttons_state()
	set_buttons_disabled(true)


#### LOGIC ####



#### VIRTUALS ####



#### INPUTS ####



#### SIGNAL RESPONSES ####

func on_thread_finished():
	set_buttons_default_state()

func on_seed_field_text_changed(new_text: String):
	EVENTS.emit_signal("seed_change_query" ,int(new_text))


func on_menu_option_chose(option: MenuOptionsBase):
	var option_name = option.name
	
	match(option_name):
		"NewGame": var _err = GAME.goto_level(1)
		"Scores": pass
		"InfiniteMode": var _err = get_tree().change_scene_to(infinite_level_scene)
		"Quit": get_tree().quit()
