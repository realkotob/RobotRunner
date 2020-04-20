extends Node2D

onready var gameover_timer_node = $GameoverTimer

export var progression : Resource
export var current_chapter : Resource

var player1 = preload("res://Scenes/Characters/RobotIce/RobotIce.tscn")
var player2 = preload("res://Scenes/Characters/RobotHammer/RobotHammer.tscn")

var level_array : Array

func _ready():
	var _err = gameover_timer_node.connect("timeout",self, "on_gameover_timer_timeout")
	level_array = current_chapter.load_levels()


#### TO BE ENHENCED -- HAVE TO TAKE CHARGE OF THE CHECKPOINTS SITUATION ####
func goto_level(index : int = progression.level):
	var _err = get_tree().change_scene_to(level_array[index])


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


func on_player_level_exited(body: Node):
	get_tree().get_current_scene().on_player_exited(body)


# Called when a level is finished, change scene to the next level scene
func on_level_finished():
	progression.level += 1
	progression.checkpoint = 0 
	var current_level_index = progression.level
	goto_level(current_level_index)
