extends Control

class_name GameConsoleScript

onready var console_input_node = get_node("Console Input/CMDInput")
onready var console_cmdlog_node = get_node("LOG/CMDLogs_container")
onready var cmdsendingsound_node = get_node("CMDSendingSound")
onready var console_quit_node = get_node("Console Quit/ConsoleQUIT")

onready var children_cmd = get_node("CommandsList").get_children()

const CONSOLE_CMDLOGS_FONTSIZE : int = 45

var cheats_enabled : bool = false
var console_cmdlog_itemcount = 1


#### BUILT-IN ####

# This function ready will initialize signals and init the console logs
## init_console_cmdlog : init font size of console's log
func _ready():
	self.set_visible(false)
	var _err
	_err = console_input_node.connect("text_entered", self, "_on_cmd_submitted")
	_err = console_quit_node.connect("pressed", self, "toggle_console")
	_err = console_input_node.connect("text_changed", self, "_on_text_changed")
	
	for child in children_cmd:
		if "console_cmdlog_node" in child:
			child.console_cmdlog_node = console_cmdlog_node
		if "console" in child:
			child.console = self
		if "all_cmd" in child:
			child.all_cmd = children_cmd
	
	init_console_cmdlog()


# Respond to the submition of a command, convert its arguments from string 
# to the correct type and execute it
func submit_command(cmd : String):
	if cmd == "": return
	cmdsendingsound_node.play() # Play a sound when a player enter a command
	
	var cmd_split : Array = cmd.to_upper().split(" ") # Separate every words in the commands by a space
	var node_cmd : Node = find_node(cmd_split[0])
	# Take the first index's value (commands)
	# and try to find the corresponding node
	
	if node_cmd != null:
		# If there is at least 1 required arguments for the cmd
		# If the user cmd was followed by at least 1 argument
		# (means his input is MAYBE correct)
		var arguments := Array()
		
		if node_cmd.args_number > 0 && cmd_split.size() > 1:
			for i in range (cmd_split.size()): # We go through the splitted array
				if i == 0:
					continue
				
				# We add every argument to the array of the command
				var arg = convert_argument_type(cmd_split[i])
				arguments.append(arg) 
	
		node_cmd.exec_cmd(arguments) #We execute the command
	
	console_input_node.clear() #clear the input field


# Take a string from the player input and return it correct converted type value
func convert_argument_type(arg: String):
	var cap_arg = arg.capitalize() 
	if cap_arg == "True":
		return true
	elif cap_arg == "False":
		return false
	elif arg.is_valid_integer():
		return arg.to_int()
	elif arg.is_valid_float():
		return arg.to_float()
	else:
		return arg


func toggle_console():
	self.set_visible(!self.visible)
	get_tree().set_pause(is_visible())
	console_cmdlog_node.clear()
	console_input_node.grab_focus()
	console_cmdlog_node.add_item("Type help to see the list of available commands !")


func init_console_cmdlog():
	console_cmdlog_node.get_font("font").set_size(CONSOLE_CMDLOGS_FONTSIZE)


#### INPUT ####


func _input(_e):
	if Input.is_action_just_pressed("display_console"):
		toggle_console()
	
	if Input.is_action_just_pressed("ui_cancel") && is_visible():
		toggle_console()
		get_tree().set_input_as_handled()


#### SIGNAL RESPONSES ####

# Detect when the player type in the console
# Change the color of his input if it corresponds 
# to any commands listed in the dictionnary
func _on_text_changed(text: String):
	var cmd_split : Array = text.to_upper().split(" ")
	if(find_node(cmd_split[0])):
		console_input_node.add_color_override("font_color", Color(1,0,1,1))
	else:
		console_input_node.add_color_override("font_color", Color(1,1,1,1))


func _on_cmd_submitted(cmd : String):
	submit_command(cmd)
