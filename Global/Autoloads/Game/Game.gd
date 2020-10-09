extends Node2D

onready var gameover_timer_node = $GameoverTimer
onready var transition_timer_node = $TransitionTimer

export var progression : Resource

var chapters_array = []
var current_chapter : Resource = null

var player1 = preload("res://Scenes/Actor/Players/RobotIce/RobotIce.tscn")
var player2 = preload("res://Scenes/Actor/Players/RobotHammer/RobotHammer.tscn")

var level_array : Array
var last_level_path : String


func _ready():
	var _err = gameover_timer_node.connect("timeout",self, "on_gameover_timer_timeout")
	_err = transition_timer_node.connect("timeout",self, "on_transition_timer_timeout")


func new_chapter():
	progression.chapter += 1
	current_chapter = chapters_array[progression.chapter]


func goto_level(index : int = 0):
	if index == -1:
		goto_last_level()
	else:
		var level = current_chapter.load_level(index)
		var _err = get_tree().change_scene_to(level)


func goto_last_level():
	var last_level = load(last_level_path)
	get_tree().current_scene.queue_free()
	var _err = get_tree().change_scene_to(last_level)


# Change scene to the next level scene
# If the last level was not in the list, set the progression to -1
# Which means the last level will be launched again
func goto_next_level():
#	var last_level_index = find_string(current_chapter.levels_scenes_array, last_level_path)
	progression.level += 1
	progression.checkpoint = 0
	
	goto_level(progression.level)


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
func move_camera_to(dest: Vector2, average_w_players: bool = false, speed : float = -1.0, duration : float = 0.0):
	var camera_node = get_tree().get_current_scene().find_node("Camera")

	if camera_node != null:
		var func_call_array : Array = ["move_to", dest, average_w_players, speed, duration]
		camera_node.stack_instruction(func_call_array)


# Give zoom the camera to the destination wanted zoom
func zoom_camera_to(dest_zoom: Vector2, zoom_speed : float = 1.0):
	var camera_node = get_tree().get_current_scene().find_node("Camera")
	if camera_node != null:
		camera_node.start_zooming(dest_zoom, zoom_speed)


func set_camera_on_follow():
	var camera_node = get_tree().get_current_scene().find_node("Camera")
	camera_node.set_state("Follow")


func on_player_level_exited(body: Node):
	get_tree().get_current_scene().on_player_exited(body)


# Called when a level is finished: wait for the transition to be finished
func on_level_finished():
	transition_timer_node.start()

# When the transition is finished, go to the next level
func on_transition_timer_timeout():
	goto_next_level()


# Return the index of a given string in a given array
# Return -1 if the string wasn't found
func find_string(string_array: PoolStringArray, target_string : String):
	var index = 0
	for string in string_array:
		if string == target_string:
			break
		else:
			index += 1
			if index == len(string_array):
				index = -1
	return index
