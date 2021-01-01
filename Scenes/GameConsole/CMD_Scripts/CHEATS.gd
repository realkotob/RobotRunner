extends Commands

func exec_cmd(_arg: Array):
	console.cheats_enabled = !console.cheats_enabled
	console_cmdlog_node.add_item("CHEATS: " + String(console.cheats_enabled))
