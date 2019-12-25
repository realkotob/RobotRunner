extends Node

var hit_box_node

var dirLeft : int = 0 
var dirRight : int = 0
var face_direction : int = 1 setget set_face_direction, get_face_direction

# Input Handler
func on_LeftPressed():
	dirLeft = 1
	set_face_direction(-1)

func on_LeftReleased():
	dirLeft = 0

func on_RightPressed():
	dirRight = 1
	set_face_direction(1)

func on_RightReleased():
	dirRight = 0

func reset_direction():
	dirRight = 0
	dirLeft = 0

# Returns the direction of the robot
func get_move_direction() -> int:
	return dirRight - dirLeft

# Set face direction
func set_face_direction(value : int):
	face_direction = sign(value) as int
	flip_character()

# Returns the direction of the robot
func get_face_direction() -> int:
	return face_direction

# Flip he hit box shape
func flip_character():
	var hit_box_shape_x_pos = hit_box_node.get_child(0).position.x
	hit_box_node.get_child(0).position.x = abs(hit_box_shape_x_pos) * face_direction