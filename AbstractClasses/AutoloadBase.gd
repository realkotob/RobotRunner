extends Node

class_name AutoloadBase

export var debug : bool = false

func print_notification(notif : String):
	if debug == true:
		print("AUTOLOAD " + name + " : " + notif)
