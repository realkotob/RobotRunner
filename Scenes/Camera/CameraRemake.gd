extends Camera2D

#var _timer = null

onready var checkpoints_nodes_array = get_tree().get_nodes_in_group("CameraCheckpoint")
onready var start_area_node = get_node("StartMovingArea")

onready var new_cp_node = preload("res://Scenes/Camera/CheckpointBase.tscn")

signal player_outside_screen
signal player_inside_screen

var players_pos = []
var players = []
var cam_dir : String
var _err

func _ready():
	set_physics_process(false)

func setup():
	_err = start_area_node.connect("body_entered", self, "on_start_area_body_entered")
	
	for checkpoint in checkpoints_nodes_array:
		_err = checkpoint.connect("camera_reached_checkpoint", self, "_on_checkpoint_reached")
	
	players = get_tree().get_nodes_in_group("Players") #Put all the players in an array
	
func _physics_process(_delta):
	calculate_players_position()
	adapt_camera_position(cam_dir)

func calculate_players_position():
	#Put the all the players positions in an array players_pos
	players_pos = [players[0].position, players[1].position]

func adapt_camera_position(cam_dir : String):
	#Change the position of the camera according to the position of the players
	if(cam_dir == 'leftright'):
		self.position.x = ((players_pos[0].x + players_pos[1].x) / 2)
	if(cam_dir == 'updown'):
		self.position.y = ((players_pos[0].y + players_pos[1].y) / 2)
		
# Start to move the camera if a player enter the start area
func on_start_area_body_entered(body):
	if body in players:
		cam_dir = 'leftright'
		set_physics_process(true)
		start_area_node.queue_free()

# Get the camera direction from the current check point, and adapt area in response
func _on_checkpoint_reached(cp_dir : Vector2):
	if(abs(cp_dir.x) == 1):
		cam_dir = 'leftright'
	elif(abs(cp_dir.y) == 1):
		cam_dir = 'updown'
