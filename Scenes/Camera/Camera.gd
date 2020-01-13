extends Camera2D

export var speed : float

onready var players_nodes_array = get_tree().get_nodes_in_group("Players")
onready var checkpoints_nodes_array = get_tree().get_nodes_in_group("CameraCheckpoint")
onready var start_area_node = get_node("StartCameraArea")
onready var play_area_zone = get_node("PlayZone")

signal loose_condition

var cam_direction := Vector2(1, 0)

func _ready():
	# Set the camera play_area (the playable area, where the players need to stay in) to the size of the game window 
	var scr_size = Vector2(ProjectSettings.get("display/window/size/width"), ProjectSettings.get("display/window/size/height"))
	play_area_zone.get_node("CollisionShape2D").get_shape().set_extents(scr_size / 2)
	
	set_physics_process(false)
	
	# Connect signals
	var _err
	_err = start_area_node.connect("body_entered", self, "on_start_area_body_entered")
	_err = play_area_zone.connect("body_exited", self, "on_play_area_zone_exited")
	for checkpoint in checkpoints_nodes_array:
		_err = checkpoint.connect("camera_reached_checkpoint", self, "_on_checkpoint_reached")


# Move the camera in the direction it knows
func _physics_process(_delta):
	position += speed * cam_direction


# Start to move the camera if a player enter the start area
func on_start_area_body_entered(body):
	if body in players_nodes_array:
		set_physics_process(true)


# When a player exits the camera zone
func on_play_area_zone_exited(body):
	if body in players_nodes_array:
		emit_signal("loose_condition")


# Get the camera direction from the current check point
func _on_checkpoint_reached(cp_dir):
	cam_direction = cp_dir
