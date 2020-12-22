extends MenuBase
class_name PauseMenu

onready var resume_label_node = $HBoxContainer/V_OptContainer/Resume


#### BUILT-IN ####

func _ready() -> void:
	get_tree().set_pause(true)

#### LOGIC ####

func resume_game():
	get_tree().set_pause(false)
	queue_free()


#### VITRUAL ####

func cancel() -> void:
	resume_game()


#### INPUTS ####


#### SIGNAL RESPONSES ####

func _on_menu_option_chose(option: MenuOptionsBase):
	match(option.name):
		"Resume": 
			get_tree().set_pause(false)
			resume_game()
		"Retry": 
			get_tree().set_pause(false)
			var _err = GAME.goto_last_level()
			
		"Options": 
			var _err = navigate_sub_menu(MENUS.option_menu_scene.instance())
			
		"ScreenTitle":
			 var _err = navigate_sub_menu(MENUS.title_screen_scene.instance())
			
		"Leave": 
			get_tree().quit()
