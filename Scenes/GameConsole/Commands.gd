extends Node

class_name Commands

var console : Node
var console_cmdlog_node : Node

export var cmd_name : String = "" #command name
export var args_number : int #number of required argument
export var cmd_args : Array = [] #array of all argument gave by the player (=> Filled from GameConsole.gd)
export var cmd_description : String = "" #command description
export var cheats_required : bool = false #cheats will have to be ON to execute the command

export var target : String = "" #node target
export var target_as_group : bool = false #is the target a group of target ?
export var target_method : String = "" #target method

# This function will execute the command
func exec_cmd():
	if(console.cheats_enabled or cheats_required == console.cheats_enabled):
		if target == "" or target_method == "":
			console_cmdlog_node.add_item(" > Can't find the target or target method.")
			return
			
		var target_array : Array = []
		if target_as_group:
			target_array = get_tree().get_nodes_in_group(target)
		else:
			target_array.append(get_tree().get_current_scene().find_node(target))
			
		for target_name in target_array:
			if (target_name and target_name.has_method(target_method)):
				var call_def_funcref := funcref(target_name, "call_deferred")
				cmd_args.push_front(target_method)
				if(cmd_args.size() > 1):
					cmd_args.remove(1)
				call_def_funcref.call_funcv(cmd_args)
