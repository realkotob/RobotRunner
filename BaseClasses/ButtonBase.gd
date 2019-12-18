extends TextureButton

class_name ButtonBase

onready var buttons_node = get_parent()
onready var blop_node = get_node("../Blop")

var grey_color = "4e4e4e"
var normal_color = "ffffff"

func _ready():
	var _err
	set_modulate(grey_color)
	_err = connect("mouse_entered", self, "on_mouse_entered")
	_err = connect("mouse_exited", self, "on_mouse_exited")
	_err = connect("button_up", buttons_node, "on_button_pressed")
	_err = connect("button_up", blop_node, "on_button_pressed")
	_err = connect("button_up", self, "on_button_pressed")


func on_mouse_entered():
	set_modulate(normal_color)

func on_mouse_exited():
	set_modulate(grey_color)

func on_button_pressed():
	set_modulate(grey_color)