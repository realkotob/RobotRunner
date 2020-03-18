extends Button

class_name MenuOptionsBase

var menu_node = Control

signal aimed

func setup():
	var _err = connect("pressed", self, "on_pressed")
	_err = connect("mouse_entered", self, "on_mouse_entered")
	_err = connect("aimed", menu_node, "on_button_aimed")


func on_pressed():
	pass


func on_mouse_entered():
	if !is_disabled():
		emit_signal("aimed", self)
