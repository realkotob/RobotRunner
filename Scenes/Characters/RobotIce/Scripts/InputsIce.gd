extends Node

signal JumpPressed
signal JumpReleased

signal ActionPressed
signal ActionReleased

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
func _input(_event):
	if Input.is_action_just_pressed("move_left_player1"):
		emit_signal("LeftPressed")
		
	if Input.is_action_just_released("move_left_player1"):
		emit_signal("LeftReleased")
		
	if Input.is_action_just_pressed("move_right_player1"):
		emit_signal("RightPressed")
		
	if Input.is_action_just_released("move_right_player1"):
		emit_signal("RightReleased")
	
	if Input.is_action_just_pressed("jump_player1"):
		emit_signal("JumpPressed")
		
	if Input.is_action_just_released("jump_player1"):
		emit_signal("JumpReleased")
	
	if Input.is_action_just_pressed("action_player1"):
		emit_signal("ActionPressed")
		
	if Input.is_action_just_released("action_player1"):
		emit_signal("ActionReleased")

	if Input.is_action_just_pressed("layer_up_player1"):
		emit_signal("LayerUpPressed")
		
	if Input.is_action_just_released("layer_up_player1"):
		emit_signal("LayerUpReleased")
	
	if Input.is_action_just_pressed("layer_down_player1"):
		emit_signal("LayerDownPressed")
		
	if Input.is_action_just_released("layer_down_player1"):
		emit_signal("LayerDownReleased")