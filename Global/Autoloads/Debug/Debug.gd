extends Node

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	LevelSaver.delete_all_level_temp_saves(false)

func _input(event):
	if OS.is_debug_build():
		if event.is_action_pressed("debug_fullscreen"):
			OS.window_fullscreen = !OS.window_fullscreen
			
		
		if event.is_action_pressed("debug_mute_sounds"):
			var master_bus_id = AudioServer.get_bus_index("Master")
			var is_master_muted = AudioServer.is_bus_mute(master_bus_id)
			AudioServer.set_bus_mute(master_bus_id, !is_master_muted)
