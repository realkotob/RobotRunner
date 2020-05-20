extends MenuOptionsBase

func on_pressed():
	var sounds_menu_node = MENUS.sounds_menu_scene.instance()
	owner.get_parent().add_child(sounds_menu_node)
	owner.queue_free()
