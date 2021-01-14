extends Node2D

onready var gameover_timer_node = $GameoverTimer
onready var transition_timer_node = $TransitionTimer

export var debug : bool = false
export var progression : Resource

export var transition_time : float = 1.0

const TILE_SIZE := Vector2(24, 24)
const JUMP_MAX_DIST := Vector2(6, 2)

var window_width = ProjectSettings.get_setting("display/window/size/width")
var window_height = ProjectSettings.get_setting("display/window/size/height")
var window_size = Vector2(window_width, window_height)

var chapters_array = []
var current_chapter : Resource = null

var player1 = preload("res://Scenes/Actor/Players/MrCold/MrCold.tscn")
var player2 = preload("res://Scenes/Actor/Players/MrStonks/MrStonks.tscn")

var level_array : Array
var last_level_name : String

var current_seed : int = 0 setget _set_current_seed, get_current_seed


#### ACCESSORS ####

func _set_current_seed(value: int): 
	current_seed = value
	seed(current_seed)

func get_current_seed() -> int: return current_seed


#### BUILT-IN ####

func _ready():
	var _err = gameover_timer_node.connect("timeout",self, "on_gameover_timer_timeout")
	_err = transition_timer_node.connect("timeout",self, "on_transition_timer_timeout")
	_err = EVENTS.connect("level_ready", self, "on_level_ready")
	_err = EVENTS.connect("level_finished", self, "on_level_finished")
	_err = EVENTS.connect("seed_change_query", self, "on_seed_change_query")

	GameSaver.create_dirs(GameSaver.SAVEGAME_DIR, [])
	GameSaver.create_dirs(GameSaver.SAVEDLEVEL_DIR, ["json", "tscn"])
	
#### LOGIC ####

func new_chapter():
	progression.add_to_chapter(1)
	current_chapter = chapters_array[progression.get_chapter()]


# Try to find a save of the level to load it, if no save exits, reload the native level
func goto_last_level():
	if last_level_name == "":
		print("GAME.goto_last_level needs a previous_level. previous level is currently null")
		return

	var loaded_from_save : bool = false
	var level_scene : PackedScene
	var dir = GameSaver.SAVEDLEVEL_DIR + GameSaver.SAVEDLEVEL_TSCN_DIR
	var level_to_load_path : String = find_saved_level_path(dir, last_level_name)

	# If no save of the current level exists, reload the same scene
	if level_to_load_path != "":
		level_scene = load(level_to_load_path)
		loaded_from_save = true

	# If a save exists, load it
	else:
		level_scene = load(current_chapter.find_level_path(last_level_name))
	
	var __ = get_tree().change_scene_to(level_scene)

	if loaded_from_save:
		yield(EVENTS, "level_entered_tree")
		var level : Level = get_tree().get_current_scene()
		level.is_loaded_from_save = loaded_from_save
		GameSaver.build_level_from_loaded_properties(level)


# Change scene to the next level scene
# If the last level was not in the list, set the progression to -1
# Which means the last level will be launched again
func goto_next_level():
	var next_level : PackedScene = null
	var next_level_id : int = 0

	progression.set_checkpoint(-1)
	update_collectable_progression()

	if last_level_name == "":
		next_level = current_chapter.load_level(0)
	else:
		next_level = current_chapter.load_next_level(last_level_name)
		next_level_id = current_chapter.find_level_id(last_level_name) + 1

	var next_level_name = current_chapter.get_level_name(next_level_id)
	GameSaver.delete_level_temp_saves(next_level_name)

	var _err = get_tree().change_scene_to(next_level)

	yield(EVENTS, "level_ready")
	var level = get_tree().get_current_scene()
	GameSaver.save_level_properties_as_json(level)


func goto_level(level_index : int):
	var level : PackedScene = null
	var level_id : int = 0

	progression.set_checkpoint(-1)
	update_collectable_progression()

	level = current_chapter.load_level(level_index-1)
	var level_name = current_chapter.get_level_name(level_id)
	GameSaver.delete_level_temp_saves(level_name)

	var _err = get_tree().change_scene_to(level)
	yield(EVENTS, "level_ready")
	var current_level = get_tree().get_current_scene()
	GameSaver.save_level_properties_as_json(current_level)

# Triggers the timer before the gameover is triggered
# Called when a player die
func gameover():
	gameover_timer_node.start()

	var current_scene = get_tree().get_current_scene()
	if !current_scene is Level:
		return

	current_scene.set_process(false)


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


func set_screen_fade_visible(value: bool):
	$CanvasLayer/ColorRect.set_visible(value)


# Check if the current level index is the right one when a new level is ready
# Usefull when testing a level standalone to keep track of the progression
func update_current_level_index(level : Level):
	var level_name = level.get_name()
	var level_index = current_chapter.find_level_id(level_name)
	GAME.progression.set_level(level_index)


func toggle_free_camera_mode():
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


#### SIGNAL RESPONSES ####

#  Change scene to go to the gameover scene after the timer has finished
func on_gameover_timer_timeout():
	gameover_timer_node.stop()
	var _err = get_tree().change_scene_to(MENUS.game_over_scene)

#### INPUTS ####

func _input(_event):
	if Input.is_action_just_pressed("toggle_free_camera_mode"):
		toggle_free_camera_mode()

#### SIGNAL RESPONSES ####

# Called when a level is finished: wait for the transition to be finished
func on_level_finished(_level : Level):
	fade_out()
	transition_timer_node.start()


# When the transition is finished, go to the next level
func on_transition_timer_timeout():
	goto_next_level()


# Called when the level is ready, correct
func on_level_ready(level : Level):
	last_level_name = level.get_name()
	if progression.level == 0:
		update_current_level_index(level)
	fade_in()
	
	if level is InfiniteLevel:
		GameSaver.save_level(level, progression.main_stored_objects)
		GameSaver.save_level_properties_as_json(level)


# When a player reach a checkpoint
func on_checkpoint_reached(level: Level, checkpoint_id: int):
	if checkpoint_id + 1 > GAME.progression.checkpoint:
		progression.checkpoint = checkpoint_id + 1

	progression.set_main_xion(SCORE.xion)
	progression.set_main_materials(SCORE.materials)
	GameSaver.save_level(level, progression.main_stored_objects)


func on_seed_change_query(new_seed: int):
	_set_current_seed(new_seed)
