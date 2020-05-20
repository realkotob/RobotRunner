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

# This function ready will initialize signals and init the console logs
## init_console_cmdlog : init font size of console's log
func _ready():
	self.set_visible(false)
	var _err
	_err = console_input_node.connect("text_entered", self, "_on_cmd_submitted")
	_err = console_quit_node.connect("pressed", self, "_on_consolequit_button_toggled")
	_err = console_input_node.connect("text_changed", self, "_on_cmd_changed")
	
	for child in children_cmd:
		if "console_cmdlog_node" in child:
			child.console_cmdlog_node = console_cmdlog_node
		if "console" in child:
			child.console = self
		if "all_cmd" in child:
			child.all_cmd = children_cmd
	
	init_console_cmdlog()

# Check when a player press "display_console" input (Default: F3).
## Display the console and pause the game
func _input(_e):
	if Input.is_action_just_pressed("display_console"):
		open_console()

# Detect when the player type in the console
## Change the color of his input if it corresponds to any commands listed in the dictionnary
func _on_cmd_changed(_text):
	var cmd_split : Array = _text.to_upper().split(" ")
	if(find_node(cmd_split[0])):
		console_input_node.add_color_override("font_color", Color(1,0,1,1))
	else:
		console_input_node.add_color_override("font_color", Color(1,1,1,1))

# When the player submit a command
## Check if it's valid
### Action it
#### !!! REFACTORY NEEDED !!!
func _on_cmd_submitted(cmd : String):
	if cmd:
		cmdsendingsound_node.play() #Play a sound when a player enter a command
		
		var cmd_split : Array = cmd.to_upper().split(" ") # Separate every words in the commands by a space
		var node_cmd : Node = find_node(cmd_split[0])
		# Take the first index's value (commands)
		# and try to find the corresponding node
		
		if(node_cmd): # If the node exist
			node_cmd.cmd_args.clear()
			if(node_cmd.args_number > 0): # If there is at least 1 required arguments for the cmd
				if(cmd_split.size() > 1): 	# If the user cmd was followed by at least 1 argument
											# (means his input is MAYBE correct)
					for i in range (cmd_split.size()): # We go through the splitted array
						node_cmd.cmd_args.append(cmd_split[i].to_int()) # We add every argument to the array of the command
																		# (Even the cmd_name, but it will be handled and ignored later)

			node_cmd.exec_cmd() #We execute the command

		console_input_node.clear() #clear the input field

func open_console():
	get_tree().paused = !get_tree().paused
	self.set_visible(!self.visible)
	console_cmdlog_node.clear()
	console_input_node.grab_focus()
	console_cmdlog_node.add_item("Type help to see the list of available commands !")

func _on_consolequit_button_toggled():
	get_tree().paused = !get_tree().paused
	self.set_visible(!self.visible)
	
func init_console_cmdlog():
	console_cmdlog_node.get_font("font").set_size(CONSOLE_CMDLOGS_FONTSIZE)
