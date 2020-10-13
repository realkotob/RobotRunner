extends Control

class_name MenuBase

onready var opt_container = get_node("HBoxContainer/V_OptContainer")
onready var choice_sound_node = get_node("OptionChoiceSound")
onready var buttons_array = opt_container.get_children()

var button_index : int = 0 # Get the index where the player aim
var prev_button_index : int = 0 # Get the index where the player aimed before changing
var count_not_clickable_options : int # Count how many options are not clickable

var default_button_state : Array = []

# Check the options when the scenes is ready, to get sure at least one of them is clickable
# Change the color of the option accordingly to their state
func _ready():
	var _err = RESOURCE_LOADER.connect("thread_finished", self, "on_thread_finished")
	
	if len(buttons_array) == 0:
		return
	
	update_menu_option()
	
	for button in buttons_array:
		if "menu_node" in button:
			button.menu_node = self
		
		if button.has_method("setup"):
			button.setup()
	
	load_default_buttons_state()
	set_buttons_disabled(true)


# Main Navigation handling
func _unhandled_input(event):
	if event is InputEventKey:
		# If the player hit confirm
		if Input.is_action_just_pressed("ui_accept"):
			buttons_array[button_index].on_pressed()
		
		# Play the sound and set the previous option to be the opti
		if Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down"):
			prev_button_index = button_index
			
			# If the player hit up -> Navigate up
			if Input.is_action_just_pressed("ui_up"):
				increment_button_index(-1)
				
			# If the player hit down -> Navigate down
			elif Input.is_action_just_pressed("ui_down"):
				increment_button_index(1)
			
			# Triggers the reponse of the button
			on_button_aimed(buttons_array[button_index], false)


# Stock the default state of every button
func load_default_buttons_state():
	for button in buttons_array:
		var button_state = button.is_disabled()
		default_button_state.append(button_state)


func set_buttons_disabled(value : bool):
	for button in buttons_array:
		button.set_disabled(value)


func set_buttons_default_state():
	for i in range(buttons_array.size()):
		buttons_array[i].set_disabled(default_button_state[i])


func are_all_options_disabled() -> bool:
	for button in buttons_array:
		if !button.is_disabled():
			return false
	return true

# Navigate the menu up or down
func increment_button_index(value : int):
	if are_all_options_disabled():
		return
	
	button_index = wrapi(button_index + value, 0, len(buttons_array))
	if buttons_array[button_index].is_disabled():
		increment_button_index(value)


# Change the color of menu option according if it is selected by a player or not
func update_menu_option():
	buttons_array[prev_button_index].set_selected(false)
	buttons_array[button_index].set_selected(true)


# When a button is aimed (with a mouse for exemple)
func on_button_aimed(button : Button, signal_call: bool):
	if signal_call:
		prev_button_index = button_index
		button_index = button.get_index()
	update_menu_option()
	choice_sound_node.play()


func on_thread_finished():
	set_buttons_default_state()
