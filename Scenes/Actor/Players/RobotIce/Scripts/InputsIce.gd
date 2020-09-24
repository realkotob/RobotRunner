extends Node

var input_map = {
	"Action": "action_player",
	"Jump": "jump_player",
	"Teleport": "teleport_player",
	"MoveLeft": "move_left_player",
	"MoveRight": "move_right_player"
}


func get_input(input_name: String) -> String:
	return input_map[input_name] + String(owner.player_control_id)
