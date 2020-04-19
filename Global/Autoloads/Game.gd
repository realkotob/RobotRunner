extends Node2D

onready var gameover_timer_node = $GameoverTimer

export var progression : Resource

const level1 = preload("res://Scenes/Levels/Chapter1/Level1/A/Level1A.tscn")
const debug_level = preload("res://Scenes/Levels/Debug/LevelDebug.tscn")

var player1 = preload("res://Scenes/Characters/RobotIce/RobotIce.tscn")
var player2 = preload("res://Scenes/Characters/RobotHammer/RobotHammer.tscn")

var current_level = level1 setget set_current_level, get_current_level

func _ready():
	var _err = gameover_timer_node.connect("timeout",self, "on_gameover_timer_timeout")


func set_current_level(level : Node):
	current_level = load(level.get_filename())


func get_current_level():
	return current_level


func goto_level(level = current_level):
	var _err = get_tree().change_scene_to(level)


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
