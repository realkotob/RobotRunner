extends Control

onready var title_screen = "res://Scenes/GUI/Menus/ScreenTitle/ScreenTitle.tscn"
onready var children_array = get_children()
onready var timer_node = get_node("Timer")

var game_node : Node

var player_action_on_gameover : String

func _ready():
	var _err = timer_node.connect("timeout", self, "on_timer_timeout")


func _input(_event):
	if(Input.is_action_just_pressed("ui_cancel")):
		player_action_on_gameover = "MENU"
		timer_node.start()
	if(Input.is_action_just_pressed("game_restart")):
		player_action_on_gameover = "RETRY"
		timer_node.start()


# Action to do when the timer is over
func on_timer_timeout():
	match(player_action_on_gameover):
		"MENU":
			var _err = get_tree().change_scene(title_screen)
		"RETRY":
			GAME.goto_current_level()
	
	queue_free()
