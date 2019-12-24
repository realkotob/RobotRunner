extends Node

var dirLeft : int = 0 
var dirRight : int = 0
var face_direction : int = 1

# Input Handler
func on_LeftPressed():
	dirLeft = 1
	face_direction = -1

func on_LeftReleased():
	dirLeft = 0

func on_RightPressed():
	dirRight = 1
	face_direction = 1

func on_RightReleased():
	dirRight = 0

func reset_direction():
	dirRight = 0
	dirLeft = 0

# Returns the direction of the robot
func get_move_direction() -> int:
	return dirRight - dirLeft

# Returns the direction of the robot
func get_face_direction() -> int:
	return face_direction