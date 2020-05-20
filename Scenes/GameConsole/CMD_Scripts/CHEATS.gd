extends Commands

func exec_cmd():
	console.cheats_enabled = !console.cheats_enabled
	console_cmdlog_node.add_item("CHEATS: " + String(console.cheats_enabled))
