extends Node

var input_map = {
	"Action": "action_player",
	"Jump": "jump_player",
	"Teleport": "teleport_player",
	"MoveLeft": "move_left_player",
	"MoveRight": "move_right_player"
}


func get_input(input_name: String) -> String:
	var id = String(owner.get_player_id()) if !GAME.solo_mode else "1"
	
	if !input_map.has(input_name):
		print("input " + input_name + " Can't be found in the input dictonnary")
		return ""
	
	return input_map[input_name] + id
