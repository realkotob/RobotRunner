extends EventsBase

# warnings-disable

signal level_entered_tree(level)
signal level_ready(level)
signal level_finished(level)

signal seed_change_query(new_seed)

#### INFINITE MODE ####

signal automata_room_crossed(automata, room, entry, exit)


#### CAMERA ####

signal move_camera_to_query(dest, average_w_plyrs, speed, duration)
signal zoom_camera_to_query(dest_zoom, zoom_speed)
signal camera_state_change_query(state)
signal camera_toggle_free_mode_query()
