extends Node

class_name InputMapper

signal profile_changed(new_profile, is_customizable)

const CUSTOM_PROFILE : int = 2

var current_profile_id = 0

var profiles = {
	0: 'profile_azerty',
	1: 'profile_qwerty',
	2: 'profile_custom',
}

var profile_azerty = {
	'jump_player1': KEY_Z,
	'move_left_player1': KEY_Q,
	'move_right_player1': KEY_D,
	'teleport_player1': KEY_S,
	'action_player1': KEY_E,
	
	'jump_player2': KEY_UP,
	'move_left_player2': KEY_LEFT,
	'move_right_player2': KEY_RIGHT,
	'teleport_player2': KEY_DOWN,
	'action_player2': KEY_SHIFT,
	
	'game_restart': KEY_F1,
	'HUD_switch_state': KEY_F2,
	'display_console': KEY_F3
}

var profile_qwerty = {
	'jump_player1': KEY_W,
	'move_left_player1': KEY_A,
	'move_right_player1': KEY_D,
	'teleport_player1': KEY_S,
	'action_player1': KEY_E,
	
	'jump_player2': KEY_UP,
	'move_left_player2': KEY_LEFT,
	'move_right_player2': KEY_RIGHT,
	'teleport_player2': KEY_DOWN,
	'action_player2': KEY_SHIFT,
	
	'game_restart': KEY_F1,
	'HUD_switch_state': KEY_F2,
	'display_console': KEY_F3
}

var profile_custom = {
	'jump_player1': InputMap.get_action_list("jump_player1")[0].scancode,
	'move_left_player1': InputMap.get_action_list("move_left_player1")[0].scancode,
	'move_right_player1': InputMap.get_action_list("move_right_player1")[0].scancode,
	'teleport_player1': InputMap.get_action_list("teleport_player1")[0].scancode,
	'action_player1': InputMap.get_action_list("action_player1")[0].scancode,
	
	'jump_player2': InputMap.get_action_list("jump_player2")[0].scancode,
	'move_left_player2': InputMap.get_action_list("move_left_player2")[0].scancode,
	'move_right_player2': InputMap.get_action_list("move_right_player2")[0].scancode,
	'teleport_player2': InputMap.get_action_list("teleport_player2")[0].scancode,
	'action_player2': InputMap.get_action_list("action_player2")[0].scancode,
	
	'game_restart': InputMap.get_action_list("game_restart")[0].scancode,
	'HUD_switch_state': InputMap.get_action_list("HUD_switch_state")[0].scancode,
	'display_console': InputMap.get_action_list("display_console")[0].scancode
}

#Get the selected profile id to change it. Ref to profile var for more information
func change_profile(id):
	current_profile_id = id #set the current profile to the selected one
	var profile = get(profiles[id]) #get the profile's input according to the id
	var is_customizable = true if id == 2 else false #Currently, the customizable profile is the 3rd one, so ID(2).
	#Otherwise, if we chose to add one more profile, the customizable profile would be ID(3), ID(4), etc...
	
	emit_signal('profile_changed', profile, is_customizable) #Emit the signal 'profile changed'

	return profile #return the profile to display it / use it later.


# This function will remove the current action from the settings and add a new key as an event
func change_action_key(action_name, key_scancode):
	erase_action_events(action_name) #remove the action from the settings

	var new_event = InputEventKey.new() # Create a new inputevenkey event
	new_event.set_scancode(key_scancode) # Set the scancode to the variable previously declared
	new_event.set_scancode(key_scancode) # Set the scancode to the variable previously declared
	InputMap.action_add_event(action_name, new_event) # Add the action(with the key) to the InputMap of the system so that it can be recognized
	get_selected_profile()[action_name] = key_scancode # Get the current profile's changed action scancode


# This function will remove the selected action from the settings (InputMap)
func erase_action_events(action_name):
	var input_events = InputMap.get_action_list(action_name)
	for event in input_events:
		InputMap.action_erase_event(action_name, event)

func get_selected_profile():
	return get(profiles[current_profile_id])

func _on_ProfilesMenu_item_selected(ID):
	change_profile(ID)
