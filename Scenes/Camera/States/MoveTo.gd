extends StateBase

#### MOVE TO CAMERA STATE ####

# This state is called when you want to move the camera towards a destination
# It will move progressivly using linear interpolation until it reaches it

var destination := Vector2.ZERO setget set_destination, get_destination
var average_w_players : bool = false

func set_destination(value: Vector2):
	destination = value

func get_destination() -> Vector2:
	return destination


# If average_w_player is true, the camera compute the average position
# Between itself and the players
func enter_state(_host):
	if average_w_players == true:
		var players_array = get_tree().get_nodes_in_group("Players")
		destination += owner.compute_average_pos(players_array)
		destination /= 2


# Reset the bool value when leaving the state
func exit_state(_host):
	average_w_players = false


# Move the camera to its destination until its arrived
# Set back to stop state when its arrived
func update(_host, _delta):
	if move_to_destination() == true or destination == Vector2.ZERO:
		return "Stop"


# Move to the current destination, return true when it's arrived, false otherwise
func move_to_destination():
	owner.global_position = owner.global_position.linear_interpolate(destination, 0.1)
	
	return owner.global_position == destination