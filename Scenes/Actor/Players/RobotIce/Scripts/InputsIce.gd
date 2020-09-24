extends Node

var input_map = {
	"Action": "action_player",
	"Jump": "jump_player",
	"Teleport": "teleport_player",
	"MoveLeft": "move_left_player",
	"MoveRight": "move_right_player"
}


func get_input(input_name: String) -> String:
	var id = String(owner.get_player_id()) if !SOLO_CONTROL.solo_mode else "1"
	return input_map[input_name] + id
