extends Control

onready var title_screen = "res://Scenes/GUI/Menus/ScreenTitle/ScreenTitle.tscn"
onready var level1 = "res://Scenes/Levels/Level1.tscn"
onready var children_array = get_children()
onready var node_Timer = get_node("Timer")

var player_action_on_gameover : String

func _physics_process(_delta):
	if(Input.is_action_just_pressed("ui_cancel")):
		player_action_on_gameover = "MENU"
		node_Timer.wait_time = 1
		node_Timer.start_timer()
	if(Input.is_action_just_pressed("game_restart")):
		player_action_on_gameover = "RETRY"
		node_Timer.wait_time = 1
		node_Timer.start_timer()
func _ready():
	for child in children_array:
		if(child.has_method("on_ready")):
			child.on_ready()

func on_timer_started():
	print("Timer started!")

func on_timer_timeout():
	match(player_action_on_gameover):
		"MENU":
			var _err = get_tree().change_scene(title_screen)
		"RETRY":
			var _err = get_tree().reload_current_scene()
