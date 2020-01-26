extends Node

var hit_box_node : Area2D
var animation_node : Node

var dirLeft : int = 0 
var dirRight : int = 0
var face_direction : int = 1

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

# Returns the direction of the robot
func get_move_direction() -> int:
	return dirRight - dirLeft


# Returns the direction of the robot
func get_face_direction() -> int:
	if animation_node.is_flipped_h():
		return -1
	else:
		return 1


# Flip he hit box shape
func flip_character():
	var hit_box_shape_x_pos = hit_box_node.get_child(0).position.x
	hit_box_node.get_child(0).position.x = abs(hit_box_shape_x_pos) * face_direction