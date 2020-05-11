extends Commands

var all_cmd : Array

func exec_cmd():
	for cmd in all_cmd:
		if(cmd.cheats_required == console.cheats_enabled):
			console_cmdlog_node.add_item(cmd.cmd_name)
