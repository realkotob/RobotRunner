extends SubMenuBase
class_name MenuOptions

func cancel():
	navigate_sub_menu(MENUS.pause_menu_scene.instance())

func _on_menu_option_chose(option):
	match(option.name):
		"Graphics": pass
		"Sounds": 
			var _err = navigate_sub_menu(MENUS.sounds_menu_scene.instance())
		"Inputs": 
			var _err = navigate_sub_menu(MENUS.controls_menu_scene.instance())
