extends MenuOptionsBase

onready var children_array = get_children()

func on_pressed():
	var input_menu_node = MENUS.controls_menu_scene.instance()
	owner.get_parent().add_child(input_menu_node)
	owner.queue_free()
