extends MenuBase
class_name ScreenTitleMenu

#### ACCESSORS ####

func is_class(value: String):
	return value == "" or .is_class(value)

func get_class() -> String:
	return ""

#### BUILT-IN ####

func _ready():
	var _err = RESOURCE_LOADER.connect("thread_finished", self, "on_thread_finished")
	
	load_default_buttons_state()
	set_buttons_disabled(true)


#### LOGIC ####



#### VIRTUALS ####



#### INPUTS ####



#### SIGNAL RESPONSES ####

func on_thread_finished():
	set_buttons_default_state()
