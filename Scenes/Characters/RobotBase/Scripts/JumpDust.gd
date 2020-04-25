extends Node2D

var JumpDustScene = preload("res://Scenes/Characters/RobotBase/SFX/JumpDust.tscn")

func set_play(value : bool, global_pos : Vector2 = Vector2.ZERO):
	if value == true:
		var jumpdust_node = JumpDustScene.instance()
		SFX.add_child(jumpdust_node)
		jumpdust_node.set_global_position(global_pos)
		jumpdust_node.play()
