extends Node

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


# Should be called by the parent: connect directions inputs to the direction node
func connect_direction(direction_node):
	var _err
	_err = connect("LeftPressed", direction_node, "on_LeftPressed")
	_err = connect("RightPressed", direction_node, "on_RightPressed")
	_err = connect("LeftReleased", direction_node, "on_LeftReleased")
	_err = connect("RightReleased", direction_node, "on_RightReleased")


# Map every inputs with a signal
func _input(event):
	if event is InputEventKey:
		match event.scancode:
			KEY_O: 
				if event.pressed:
					emit_signal("UpPressed")
				else:
					emit_signal("UpReleased")
			KEY_L: 
				if event.pressed:
					emit_signal("DownPressed")
				else:
					emit_signal("DownReleased")
			KEY_K:
				if event.pressed:
					emit_signal("LeftPressed")
				else:
					emit_signal("LeftReleased")
			KEY_M:
				if event.pressed:
					emit_signal("RightPressed")
				else:
					emit_signal("RightReleased")
			KEY_N:
				if event.pressed:
					emit_signal("JumpPressed")
				else:
					emit_signal("JumpReleased")
			KEY_ENTER:
				if event.pressed:
					emit_signal("ActionPressed")
				else:
					emit_signal("ActionReleased")
			KEY_I:
				if event.pressed:
					emit_signal("LayerUpPressed")
				else:
					emit_signal("LayerUpReleased")
			KEY_P:
				if event.pressed:
					emit_signal("LayerDownPressed")
				else:
					emit_signal("LayerDownReleased")