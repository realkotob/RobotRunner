extends CameraState

#### MOVE TO CAMERA STATE ####

# This state is called when you want to move the camera towards a destination
# It will move progressivly using linear interpolation until it reaches it

var destination := Vector2.ZERO 
var average_w_players : bool = false
var move_speed : float = 0.1
var current_speed : float = move_speed
var wait_time : float = 0.0

# If average_w_player is true, the camera compute the average position
# Between itself and the players
func enter_state(_host):
	if average_w_players == true:
		var players_array = get_tree().get_nodes_in_group("Players")
		destination += owner.compute_average_pos()
		destination /= 2


# Reset the bool value when leaving the state
func exit_state(_host):
	average_w_players = false
	current_speed = move_speed
	wait_time = 0.0


# Move the camera to its destination until its arrived
# Set to stop state if a wait time is specified
# Else : execute the next instruction of the camera
# If it was the last instruction: set back to the previous state
func update(_host, _delta):
	if move_to_destination() == true or destination == Vector2.ZERO:
		if wait_time != 0.0:
			owner.stop_state_node.wait_time = wait_time
			states_node.set_state("Stop")
		
		elif len(owner.instruction_stack) != 0:
			owner.execute_next_instruction()
		else:
			states_node.set_state(states_node.previous_state)


# Move to the current destination, return true when it's arrived, false otherwise
func move_to_destination():
	owner.start_moving(destination)
	return owner.global_position.distance_to(destination) < 3.0
