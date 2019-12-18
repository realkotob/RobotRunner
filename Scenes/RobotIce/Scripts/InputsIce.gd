extends Node

onready var direction_node = get_node("../Attributes/Direction")

signal JumpPressed
signal JumpReleased

signal ActionPressed
signal ActionReleased

signal UpPressed
signal UpReleased

signal DownPressed
signal DownReleased

signal RightPressed
signal RightReleased

signal LeftPressed
signal LeftReleased

signal LayerUpPressed
signal LayerUpReleased

signal LayerDownPressed
signal LayerDownReleased

func _ready():
	var _err
	_err = connect("LeftPressed", direction_node, "on_LeftPressed")
	_err = connect("RightPressed", direction_node, "on_RightPressed")
	_err = connect("LeftReleased", direction_node, "on_LeftReleased")
	_err = connect("RightReleased", direction_node, "on_RightReleased")

func _unhandled_input(event):
	if event is InputEventKey:
		match event.scancode:
			KEY_Z: 
				if event.pressed:
					emit_signal("UpPressed")
				else:
					emit_signal("UpReleased")
			KEY_S: 
				if event.pressed:
					emit_signal("DownPressed")
				else:
					emit_signal("DownReleased")
			KEY_Q:
				if event.pressed:
					emit_signal("LeftPressed")
				else:
					emit_signal("LeftReleased")
			KEY_D:
				if event.pressed:
					emit_signal("RightPressed")
				else:
					emit_signal("RightReleased")
			KEY_SPACE:
				if event.pressed:
					emit_signal("JumpPressed")
				else:
					emit_signal("JumpReleased")
			KEY_E:
				if event.pressed:
					emit_signal("ActionPressed")
				else:
					emit_signal("ActionReleased")
			KEY_R:
				if event.pressed:
					emit_signal("LayerUpPressed")
				else:
					emit_signal("LayerUpReleased")
			KEY_A:
				if event.pressed:
					emit_signal("LayerDownPressed")
				else:
					emit_signal("LayerDownReleased")