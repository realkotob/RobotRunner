extends MenuOptionsBase

func on_pressed():
	var opt_menu_node = MENUS.option_menu_scene.instance()
	owner.get_parent().add_child(opt_menu_node)
	owner.queue_free()
