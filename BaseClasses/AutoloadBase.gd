extends Node

class_name AutoloadBase

var notification : bool = false

func print_notification(notif : String):
	if notification == true:
		print(name + " : " + notif)
