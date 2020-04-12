extends Node2D

onready var gameover_timer_node = $GameoverTimer

const level1 = preload("res://Scenes/Levels/Chapter1/Level1/Level1.tscn")
const debug_level = preload("res://Scenes/Levels/Debug/LevelDebug.tscn")

var player1 = preload("res://Scenes/Characters/RobotIce/RobotIce.tscn")
var player2 = preload("res://Scenes/Characters/RobotHammer/RobotHammer.tscn")

var current_level = level1


func _ready():
	var _err = gameover_timer_node.connect("timeout",self, "on_gameover_timer_timeout")

func goto_level(_level_name : String):
	pass

# Generate the current level
func goto_current_level():
	var _err = get_tree().change_scene_to(current_level)


# Triggers the timer before the gameover is triggered
# Called when a player die
func gameover():
	gameover_timer_node.start()
	get_tree().get_current_scene().set_process(false)


#  Change scene to go to the gameover scene after the timer has finished
func on_gameover_timer_timeout():
	gameover_timer_node.stop()
	var _err = get_tree().change_scene_to(MENUS.game_over_scene)


# Move the camera to the given position
func move_camera_to(dest: Vector2, average_w_players: bool = false):
	var camera_node = get_tree().get_current_scene().find_node("Camera")
	
	if camera_node != null:
		camera_node.move_to(dest, average_w_players)


func set_camera_on_follow():
	var camera_node = get_tree().get_current_scene().find_node("Camera")
	camera_node.set_state("Follow")
