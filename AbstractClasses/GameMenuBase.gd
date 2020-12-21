extends Control
class_name MenuBase

onready var opt_container = get_node("HBoxContainer/V_OptContainer")
onready var choice_sound_node = get_node("OptionChoiceSound")
onready var buttons_array = opt_container.get_children()

var button_index : int = 0 # Get the index where the player aim
var prev_button_index : int = -1 # Get the index where the player aimed before changing
var count_not_clickable_options : int # Count how many options are not clickable

var default_button_state : Array = []

#### BUILT-IN ####

# Check the options when the scenes is ready, to get sure at least one of them is clickable
# Change the color of the option accordingly to their state
func _ready():
	if len(buttons_array) == 0:
		return
	
	update_menu_option()
	
	for button in buttons_array:
		if "menu_node" in button:
			button.menu_node = self
		
		if button.has_method("setup"):
			button.setup()
		
		var _err = button.connect("option_chose", self, "_on_menu_option_chose")
		_err = button.connect("focus_changed", self, "_on_menu_option_focus_changed")


#### LOGIC ####

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
func increment_button_index(value : int = 1):
	if are_all_options_disabled():
		return
	
	if !buttons_array[button_index].is_disabled():
		prev_button_index = button_index
	
	button_index = wrapi(button_index + value, 0, buttons_array.size())
	if buttons_array[button_index].is_disabled():
		increment_button_index(value)
	
	update_menu_option()


# Change the color of menu option according if it is selected by a player or not
func update_menu_option():
	buttons_array[button_index].set_focused(true)
	if prev_button_index != -1:
		buttons_array[prev_button_index].set_focused(false)


func navigate_sub_menu(menu: Control):
	get_parent().add_child(menu)
	queue_free()


#### VIRTUAL ####

func cancel():
	pass


#### INPUT ####

# Main Navigation handling
func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		cancel()
	
	if buttons_array.empty():
		return
	
	if event is InputEventKey:
		# If the player hit confirm
		if Input.is_action_just_pressed("ui_accept"):
			buttons_array[button_index].on_pressed()
		
		# Play the sound and set the previous option to be the opti
		if Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down"):
			# If the player hit up -> Navigate up
			if Input.is_action_just_pressed("ui_up"):
				increment_button_index(-1)
				
			# If the player hit down -> Navigate down
			elif Input.is_action_just_pressed("ui_down"):
				increment_button_index(1)


#### SIGNAL RESPONSES ####

# When a button is aimed (with a mouse for exemple)
func _on_menu_option_focus_changed(button : Button, focus: bool):
	if focus:
		choice_sound_node.play()
		
		if button.get_index() != button_index:
			prev_button_index = button_index
			button_index = button.get_index()
			update_menu_option()


func _on_menu_option_chose(_option):
	pass
