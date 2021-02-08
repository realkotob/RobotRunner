extends Node
class_name EventsBase

#### ACCESSORS ####

func is_class(value: String): return value == "EventsBase" or .is_class(value)
func get_class() -> String: return "EventsBase"

# warnings-disable

signal gameover()
signal win()

#### PATHFINDER ####

signal query_path(who, from, to)
signal send_path(who, path)


#### INTERACTIONS ####

signal interact()
signal collect(obj)


#### SFX ####
 
signal play_SFX(sfx_name, position)
signal scatter_object(obj, nb_debris, impulse_force)
