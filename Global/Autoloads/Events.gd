extends EventsBase

# warnings-disable

signal level_entered_tree(level)
signal level_ready(level)
signal level_finished(level)

signal seed_change_query(new_seed)


#### INFINITE MODE ####

signal automata_room_crossed(automata, room, entry, exit)
