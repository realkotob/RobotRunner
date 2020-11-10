extends Node2D

onready var gameover_timer_node = $GameoverTimer
onready var transition_timer_node = $TransitionTimer

export var debug : bool = false
export var progression : Resource

export var transition_time : float = 1.0

const TILE_SIZE := Vector2(24, 24)
const JUMP_MAX_DIST := Vector2(6, 2)

var chapters_array = []
var current_chapter : Resource = null

var player1 = preload("res://Scenes/Actor/Players/RobotIce/RobotIce.tscn")
var player2 = preload("res://Scenes/Actor/Players/RobotHammer/RobotHammer.tscn")

var level_array : Array
var last_level_name : String

#### BUILT-IN ####

func _ready():
	var _err = gameover_timer_node.connect("timeout",self, "on_gameover_timer_timeout")
	_err = transition_timer_node.connect("timeout",self, "on_transition_timer_timeout")


#### LOGIC ####

func new_chapter():
	progression.add_to_chapter(1)
	current_chapter = chapters_array[progression.get_chapter()]


# Reload the last level played
# If from_start is true, reload the native level scene, else load the saved level scene
func goto_last_level(from_start: bool = false):
	var level_to_load_path : String = ""
	var level_scene : PackedScene

	if previous_level == null:
		print("GAME.goto_last_level needs a previous_level. previous level is currently null")
		return

	var previous_level_name : String = previous_level.get_name()

	level_to_load_path = find_saved_level_path("res://Scenes/Levels/SavedLevel/", previous_level_name)

	if level_to_load_path != "" or from_start:
		level_scene = load(level_to_load_path)
	else:
		level_scene = current_chapter.load_level(0)

	update_collectable_progression()

	var _err = get_tree().change_scene_to(level_scene)


# Change scene to the next level scene
# If the last level was not in the list, set the progression to -1
# Which means the last level will be launched again
func goto_next_level():
	var next_level : PackedScene = null

	progression.set_checkpoint(0)
	update_collectable_progression()

	if last_level_name == "":
		next_level = current_chapter.load_level(0)
	else:
		next_level = current_chapter.load_next_level(last_level_name)

	var _err = get_tree().change_scene_to(next_level)

func save_level(_level : Node2D):
	var saved_level = PackedScene.new()
	saved_level.pack(get_tree().get_current_scene())
	var __ = ResourceSaver.save("res://Scenes/Levels/SavedLevel/saved_level.tscn", saved_level)
	progression.saved_level = saved_level

# Load the given level then returns it
func load_level(level_path : String) -> PackedScene:
	var level_to_load = load(level_path)
	return level_to_load


# Triggers the timer before the gameover is triggered
# Called when a player die
func gameover():
	gameover_timer_node.start()
	get_tree().get_current_scene().set_process(false)


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


# Set the camera in the follow state
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

# XION AND MATERIALS METHODS HANDLERS
# Save the players' <level>progression into the main game progression
# Find the saved level with the corresponding name, and returns its path
# Returns "" if nothing was found
func find_saved_level_path(dir_path: String, level_name: String) -> String:
	var dir = Directory.new()
	if dir.open(dir_path) == OK:
		dir.list_dir_begin(true)
		var current_file_name : String = dir.get_next()

		while current_file_name != "":
			if dir.current_is_dir():
				continue
			else:
				if level_name.is_subsequence_of(current_file_name):
					return dir_path + current_file_name
				else:
					current_file_name = dir.get_next()
	return ""


# Save the players' level progression into the main game progression
>>>>>>> f41f351 (refacto goto_last_level and goto_next_level)
func update_collectable_progression():
	progression.set_main_xion(SCORE.get_xion())
	progression.set_main_materials(SCORE.get_materials())


# Update the HUD when a player retry or go to the next level
func update_hud_collectable_progression():
	SCORE.set_xion(progression.get_main_xion())
	SCORE.set_materials(progression.get_main_materials())


# Discard progression and get the lastest data
func discard_collectable_progression():
	pass


# Check if the current level index is the right one when a new level is ready
# Usefull when testing a level standalone to keep track of the progression
func update_current_level_index(level : Level):
	var level_name = level.get_name()
	var level_index = current_chapter.find_level_id(level_name)
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

#Load the current level state
func save_current_level_state(level, dict : Dictionary):
	dict.clear()
	get_children_of_node([level.get_node('InteractivesObjects'), level.get_node('Events')], dict)
#	if(debug):
#		print_weakref(array)

# Get every children of a node
func get_children_of_node(nodes_to_scan_array : Array, dict_to_fill : Dictionary):
	var classes_to_scan_array = objects_datatype_storage.keys()
	for node in nodes_to_scan_array:
		for child in node.get_children():
			#print(child.name)
			for node_class in classes_to_scan_array:
				if child.is_class(node_class):
#					if(debug):
#						print("- "+child.get_name()) # DEBUG PURPOSE
					var object_properties = get_object_properties(child, node_class)

					dict_to_fill[child.get_path()] = object_properties
					continue
			if child.get_child_count() != 0:
#				if(debug):
#					print("["+child.get_name()+"]") # DEBUG PURPOSE
				get_children_of_node([child], dict_to_fill)

func get_object_properties(object : Object, classname : String) -> Dictionary:
	var property_list : Array = objects_datatype_storage[classname]
	var property_data_dict : Dictionary = {}
	property_data_dict['name'] = object.get_name()
	for property in property_list:
		if(property in object):
			property_data_dict[property] = object.get(property)
		else:
			print("Property : " + property + " could not be found in " + object.name)
	return property_data_dict

# Toggle the camera debug mode, and toggle the controls of the players
func toggle_camera_debug_mode():
	var level = get_tree().get_current_scene()
	if not level is Level:
		return

	var camera_node = level.find_node("Camera")
	var was_camera_debug_mode = camera_node.get_state_name() == "Debug"
	if was_camera_debug_mode:
		camera_node.set_to_previous_state()
	else:
		camera_node.set_state("Debug")

	for player in get_tree().get_nodes_in_group("Players"):
		player.set_active(was_camera_debug_mode)

#func print_weakref(array : Array):
#	for weakref_ref in array:
#		if(weakref_ref.get_ref() != null):
#			print('Weakref object : ', weakref_ref.get_ref().name)

#  Change scene to go to the gameover scene after the timer has finished
func on_gameover_timer_timeout():
	gameover_timer_node.stop()
	var _err = get_tree().change_scene_to(MENUS.game_over_scene)

#### INPUTS ####

func _input(_event):
	if Input.is_action_just_pressed("toggle_camera_debug_mode"):
		toggle_camera_debug_mode()

#### SIGNAL RESPONSES ####

# Called when a level is finished: wait for the transition to be finished
func on_level_finished():
	fade_out()
	transition_timer_node.start()


# When the transition is finished, go to the next level
func on_transition_timer_timeout():
	goto_next_level()


# Called when the level is ready, correct
func on_level_ready(level):
	last_level_name = level.get_name()
	if progression.level == 0:
		update_current_level_index(level)

	$LevelSaver.save_level(level, progression.main_stored_objects)
	fade_in()


# When a player reach a checkpoint
func on_checkpoint_reached(level: Level, checkpoint_id: int):
	if checkpoint_id > GAME.progression.checkpoint:
		GAME.progression.checkpoint = checkpoint_id

	GAME.progression.set_main_xion(SCORE.xion)
	GAME.progression.set_main_materials(SCORE.materials)
	$LevelSaver.save_level(level, progression.main_stored_objects)
