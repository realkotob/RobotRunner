extends Node

var dirLeft : int = 0 
var dirRight : int = 0 

# Input Handler
func on_LeftPressed():
	dirLeft = 1

func on_LeftReleased():
	dirLeft = 0

func on_RightPressed():
	dirRight = 1

func on_RightReleased():
	dirRight = 0

func reset_direction():
	dirRight = 0
	dirLeft = 0

func get_direction() -> int:
	return dirRight - dirLeft