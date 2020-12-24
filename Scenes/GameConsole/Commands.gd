extends Node
class_name Commands

var console : Node
var console_cmdlog_node : Node

export var cmd_name : String = "" #command name
export var args_number : int # number of required arguments

export var cmd_description : String = "" # command description
export var cheats_required : bool = false # cheats will have to be ON to execute the command

export var target : String = "" # node target
export var target_as_group : bool = false # is the target a group of target ?
export var target_method : String = "" # target method


# This function will execute the command
func exec_cmd(cmd_args: Array):
	if(console.cheats_enabled or cheats_required == console.cheats_enabled):
		
		var error : bool = false
		
		if target == "":
			console_cmdlog_node.add_item(" > The target object field is empty.")
			error = true
		
		if target_method == "":
			console_cmdlog_node.add_item(" > The target method field is empty.")
			error = true
		
		if cmd_args.size() != args_number:
			console_cmdlog_node.add_item(" > The number of arguments passed is wrong: expected"
										 + String(args_number) + ".")
			error = true
		
		if error:
			return
		
		var target_array : Array = []
		if target_as_group:
			target_array = get_tree().get_nodes_in_group(target)
		else:
			# Find the target in the scene tree, by searching first in the autoloads
			# Then in the scene itself
			var tar = find_autoload(target)
			if tar == null:
				tar = get_tree().get_current_scene().find_node(target)
			if tar != null:
				target_array.append(tar)
			else:
				console_cmdlog_node.add_item(" > No target can be found with the name " + target)
		
		if target_array.empty():
			console_cmdlog_node.add_item(" > : The target can't be found")
			return
		
		# Execute the command
		for target_name in target_array:
			if (target_name and target_name.has_method(target_method)):
				var call_def_funcref := funcref(target_name, "call_deferred")
				cmd_args.push_front(target_method)
				
				call_def_funcref.call_funcv(cmd_args)
				
				# WE COULD ADD TO THE MESSAGE THE ARGUMENTS PASSED?
				console_cmdlog_node.add_item(" > : " + target_method + " called in " + target)
				return
		
		console_cmdlog_node.add_item(" > : The target method can't be found in the target node")


# Find an autoload with the given name, return null if none where find
func find_autoload(autoload_name: String) -> Node:
	for node in get_tree().get_root().get_children():
		if node.name == autoload_name:
			return node
	return null
