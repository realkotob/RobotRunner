extends Node2D

onready var gameover_timer_node = $GameoverTimer
onready var transition_timer_node = $TransitionTimer

export var debug : bool = false
export var progression : Resource

export var transition_time : float = 1.0

var chapters_array = []
var current_chapter : Resource = null

var player1 = preload("res://Scenes/Actor/Players/RobotIce/RobotIce.tscn")
var player2 = preload("res://Scenes/Actor/Players/RobotHammer/RobotHammer.tscn")

var level_array : Array
var last_level_path : String


#### BUILT-IN ####


func _ready():
	var _err = gameover_timer_node.connect("timeout",self, "on_gameover_timer_timeout")
	_err = transition_timer_node.connect("timeout",self, "on_transition_timer_timeout")



#### LOGIC ####

func new_chapter():
	progression.add_to_chapter(1)
	current_chapter = chapters_array[progression.get_chapter()]


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
	var last_level_index = find_string(current_chapter.levels_scenes_array, last_level_path)
	progression.add_to_level(1)
	if debug:
		print("progression.level: " + String(progression.get_level()))
	progression.set_checkpoint(0)

	if last_level_index == -1:
		goto_last_level()
	else:
		goto_level(progression.get_level())


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


# Return the index of a given string in a given array
# Return -1 if the string wasn't found
func find_string(string_array: PoolStringArray, target_string : String):
	var index = 0
	for string in string_array:
		if target_string.is_subsequence_of(string) or target_string == string:
			return index
		else:
			index += 1
	return -1


# Check if the current level index is the right one when a new level is ready
# Usefull when testing a level standalone to keep track of the pro
func update_current_level_index(level):
	var level_filename = level.filename
	var level_index = find_string(current_chapter.levels_scenes_array, level_filename)
	GAME.progression.set_level(level_index)


func fade_in():
	$Tween.interpolate_property($CanvasLayer/ColorRect, "modulate",
		Color.black, Color.transparent, transition_time,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()


func fade_out():
	$Tween.interpolate_property($CanvasLayer/ColorRect, "modulate",
		Color.transparent, Color.black, transition_time,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

	MUSIC.fade_out()

#### SIGNAL RESPONSES ####

func on_level_start():
	fade_in()

# Called when a level is finished: wait for the transition to be finished
func on_level_finished():
	fade_out()
	transition_timer_node.start()

# When the transition is finished, go to the next level
func on_transition_timer_timeout():
	goto_next_level()

# Called when the level is ready, correct
func on_level_ready(level):
	last_level_path = level.filename
	if progression.level == 0:
		update_current_level_index(level)
