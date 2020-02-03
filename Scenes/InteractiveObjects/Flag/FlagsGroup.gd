extends Node2D

onready var you_win_scene = ("res://Scenes/GUI/YouWinScene/YouWinScreen.tscn")
onready var flag_node_array = get_children()
var player_counter : int = 0


func _ready():
	var _err
	for flag in flag_node_array:
		_err = flag.connect("player_entered", self, "on_player_entered")
		_err = flag.connect("player_exited", self, "on_player_exited")


func on_player_entered():
	player_counter += 1
	if player_counter == 2:
		var _err = get_tree().change_scene(you_win_scene)

func on_player_exited():
	player_counter -= 1
