extends Camera2D

onready var checkpoints_nodes_array = get_tree().get_nodes_in_group("CameraCheckpoint")
onready var start_area_node = get_node("StartMovingArea")

onready var new_cp_node = preload("res://Scenes/Camera/CheckpointBase.tscn")

export var camera_speed : float = 3.0

var players_array : Array = []
var cam_dir : String

func _ready():
	set_physics_process(false)


func setup():
	var _err = start_area_node.connect("body_entered", self, "on_start_area_body_entered")
	
	for checkpoint in checkpoints_nodes_array:
		_err = checkpoint.connect("camera_reached_checkpoint", self, "_on_checkpoint_reached")
	
	# Put all the players in an array
	players_array = get_tree().get_nodes_in_group("Players") 


func _physics_process(delta):
	adapt_camera_position(delta)


# Change the position of the camera according to the position of the players
func adapt_camera_position(delta: float):
	# Update the players array
	players_array = get_tree().get_nodes_in_group("Players")
	
	# Compute the average position of every players
	var average_pos := Vector2.ZERO
	for player in players_array:
		average_pos += player.position
	average_pos /= len(players_array)
	
	# Compute the camera speed
	var real_camera_speed = clamp(camera_speed * delta, 0.0, 1.0)
	
	# Move the camera speed towards the average postion
	# with a horiziontal/vertical restriction
	if(cam_dir == 'leftright'):
		position.x = lerp(position.x, average_pos.x, real_camera_speed)
	if(cam_dir == 'updown'):
		position.y = lerp(position.y, average_pos.y, real_camera_speed)


# Start to move the camera if a player enter the start area
func on_start_area_body_entered(body):
	if body in players_array:
		cam_dir = 'leftright'
		set_physics_process(true)
		start_area_node.queue_free()


# Get the camera direction from the current check point, and adapt area in response
func _on_checkpoint_reached(cp_dir : Vector2, Camera_Zoom : Vector2):
	if(Camera_Zoom > self.zoom):
		while(self.zoom <= Camera_Zoom):
			self.zoom += Vector2(0.1,0.1)
	elif(Camera_Zoom < self.zoom):
		while(self.zoom >= Camera_Zoom):
			self.zoom -= Vector2(0.1,0.1)
	if(abs(cp_dir.x) == 1):
		cam_dir = 'leftright'
	elif(abs(cp_dir.y) == 1):
		cam_dir = 'updown'
