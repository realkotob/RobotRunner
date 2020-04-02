extends Camera2D

onready var checkpoints_nodes_array = get_tree().get_nodes_in_group("CameraCheckpoint")
onready var start_area_node = get_node("StartMovingArea")

onready var new_cp_node = preload("res://Scenes/Camera/CheckpointBase.tscn")

onready var state_machine_node = $StateMachine
onready var follow_state_node = $StateMachine/Follow
onready var moveto_state_node = $StateMachine/MoveTo

export var camera_speed : float = 3.0

export var debug := false

func _ready():
	state_machine_node.setup()
	
	if debug:
		set_state("Follow")
		start_area_node.queue_free()

	var _err = start_area_node.connect("body_entered", self, "on_start_area_body_entered")

	for checkpoint in checkpoints_nodes_array:
		_err = checkpoint.connect("camera_reached_checkpoint", self, "_on_checkpoint_reached")


func move_to(dest: Vector2, average_w_players : bool = false):
	moveto_state_node.set_destination(dest)
	moveto_state_node.average_w_players = average_w_players
	state_machine_node.set_state("MoveTo")


func set_state(state_name: String):
	state_machine_node.set_state(state_name)


# Start to move the camera if a player enter the start area
func on_start_area_body_entered(body):
	if body.is_class("Player"):
		set_state("Follow")
		start_area_node.queue_free()


# Set the average_pos variable to be at the average of every players position
func compute_average_pos(players_array: Array) -> Vector2:
	var average_pos = Vector2.ZERO
	for player in players_array:
		average_pos += player.global_position

	average_pos /= len(players_array)
	
	return average_pos


# Get the camera direction from the current check point, and adapt area in response
func _on_checkpoint_reached(cp_dir : Vector2, Camera_Zoom : Vector2):
	
	# Manage zoom changement
	#### TO BE REFACTO ####
	if(Camera_Zoom > zoom):
		while(zoom <= Camera_Zoom):
			zoom += Vector2(0.1, 0.1)
	elif(Camera_Zoom < zoom):
		while(zoom >= Camera_Zoom):
			zoom -= Vector2(0.1, 0.1)
	
	# Give the follow state its direction
	if(abs(cp_dir.x) == 1):
		follow_state_node.cam_dir = 'leftright'
	elif(abs(cp_dir.y) == 1):
		follow_state_node.cam_dir = 'updown'
