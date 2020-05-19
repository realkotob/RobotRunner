extends Control

class_name MenuBase

onready var opt_container = get_node("HBoxContainer/V_OptContainer")
onready var choice_sound_node = get_node("OptionChoiceSound")
onready var buttons_array = opt_container.get_children()

var button_index : int = 0 # Get the index where the player aim
var prev_button_index : int = 0 # Get the index where the player aimed before changing
var count_not_clickable_options : int # Count how many options are not clickable

# Check the options when the scenes is ready, to get sure at least one of them is clickable
# Change the color of the option accordingly to their state
func _ready():
	if len(buttons_array) == 0:
		return
	
	check_clickable_options()
	update_menu_option()
	
	for button in buttons_array:
		if "menu_node" in button:
			button.menu_node = self
		
		if button.has_method("setup"):
			button.setup()


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


# Exit the game if there is no clickable option
# Also set the selected option to be the first not disabled
func check_clickable_options():
	var i : int = 0
	for button in buttons_array:
		if button.is_disabled():
			count_not_clickable_options += 1
			if button_index == i:
				button_index += 1
		i += 1
	
	if count_not_clickable_options == len(buttons_array):
		print("There are no clickable options. Exiting...")
		get_tree().quit()


# Navigate the menu up or down
func increment_button_index(value : int):
	button_index = wrapi(button_index + value, 0, len(buttons_array))
	if(buttons_array[button_index].is_disabled()):
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
