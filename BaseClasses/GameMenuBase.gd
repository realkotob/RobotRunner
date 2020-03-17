extends Control

class_name MenuBase

onready var opt_container = get_node("HBoxContainer/V_OptContainer")
onready var choice_sound_node = get_node("OptionChoiceSound")
onready var buttons_array = opt_container.get_children()

var button_index : int = 0 # Get the index where the player aim
var prev_button_index : int = 0 # Get the index where the player aimed before changing
var count_not_clickable_options : int # Count how many options are not clickable

const NORMAL := Color(1, 1, 1, 1)
const DISABLED := Color(0.25, 0.25, 0.25, 1)
const SELECTED := Color(1, 0, 0, 1)

# Check the options when the scenes is ready, to get sure at least one of them is clickable
# Change the color of the option accordingly to their state
func _ready():
	check_clickable_options()
	highlight_menuopt()
	
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
			choice_sound_node.play()
			prev_button_index = button_index
			
			# If the player hit up -> Navigate up
			if Input.is_action_just_pressed("ui_up"):
				options_up()
				while(buttons_array[button_index].is_disabled()):
					options_up()
				
			# If the player hit down -> Navigate down
			elif Input.is_action_just_pressed("ui_down"):
				options_down()
				while(buttons_array[button_index].is_disabled()):
					options_down()
			
			# Change the color of the options
			highlight_menuopt()


# Exit the game if there is no clickable option
func check_clickable_options():
	for opt in buttons_array:
		if opt.is_disabled():
			count_not_clickable_options += 1
	
	if count_not_clickable_options == len(buttons_array):
		print("There are no clickable options. Exiting...")
		get_tree().quit()
	
	for n in range(len(buttons_array)):
		if(buttons_array[n].is_disabled()):
			buttons_array[n].set_self_modulate(DISABLED)


# Navigate the menu up
func options_up():
	button_index -= 1
	if button_index < 0:
		button_index = len(buttons_array) -1 


# Navigate the menu down
func options_down():
	button_index += 1
	if button_index > len(buttons_array) -1:
		button_index = 0


# Change the color of menu option according if it is selected by a player or not
func highlight_menuopt():
	buttons_array[prev_button_index].set_self_modulate(NORMAL)
	buttons_array[button_index].set_self_modulate(SELECTED)
	
	if buttons_array[prev_button_index].has_method("on_option_unselected"):
		buttons_array[prev_button_index].on_option_unselected()
	
	if buttons_array[button_index].has_method("on_option_selected"):
		buttons_array[button_index].on_option_selected()


# When a button is aimed (with a mouse for exemple)
func on_button_aimed(button : Button):
	prev_button_index = button_index
	button_index = button.get_index()
	highlight_menuopt()
	choice_sound_node.play()
