extends Node2D

onready var gameover_timer_node = $GameoverTimer

export var progression : Resource
export var current_chapter : Resource

var player1 = preload("res://Scenes/Characters/RobotIce/RobotIce.tscn")
var player2 = preload("res://Scenes/Characters/RobotHammer/RobotHammer.tscn")

var level_array : Array
var last_level_path : String

func _ready():
	var _err = gameover_timer_node.connect("timeout",self, "on_gameover_timer_timeout")
	level_array = current_chapter.load_levels()


func goto_level(index : int = 0):
	if index == -1:
		goto_last_level()
	else:
		var _err = get_tree().change_scene_to(level_array[index])


func goto_last_level():
	var last_level = load(last_level_path)
	var _err = get_tree().change_scene_to(last_level)


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
func move_camera_to(dest: Vector2, average_w_players: bool = false, speed : float = -1.0):
	var camera_node = get_tree().get_current_scene().find_node("Camera")
	
	if camera_node != null:
		camera_node.move_to(dest, average_w_players, speed)


# Give zoom the camera to the destination wanted zoom
func zoom_camera_to(dest_zoom: Vector2, zoom_speed : float = -1.0):
	var camera_node = get_tree().get_current_scene().find_node("Camera")
	
	if camera_node != null:
		camera_node.set_destination_zoom(dest_zoom)
		if zoom_speed != -1.0:
			camera_node.current_zoom_speed = zoom_speed


func set_camera_on_follow():
	var camera_node = get_tree().get_current_scene().find_node("Camera")
	camera_node.set_state("Follow")


func on_player_level_exited(body: Node):
	get_tree().get_current_scene().on_player_exited(body)


# Called when a level is finished, change scene to the next level scene
# If the last level was not in the list, set the progression to -1
# Which means the last level will be launched again
func on_level_finished():
	var last_level_index = find_string(current_chapter.levels_scenes_array, last_level_path)
	
	progression.level += 1
	progression.checkpoint = 0
	
	if last_level_index == -1:
		goto_last_level()
	else:
		goto_level(progression.level)


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
