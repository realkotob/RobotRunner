extends Camera2D

export var speed : float

onready var players_nodes_array = get_tree().get_nodes_in_group("Players")
onready var start_area_node = get_node("StartCameraArea")
onready var play_area_zone = get_node("PlayZone")

signal loose_condition

func _ready():
	# Set the camera play_area (the playable area, where the players need to stay in) to the size of the game window 
	var scr_size = Vector2(ProjectSettings.get("display/window/size/width"), ProjectSettings.get("display/window/size/width"))
	play_area_zone.get_node("CollisionShape2D").get_shape().set_extents(scr_size / 2)
	
	set_physics_process(false)
	start_area_node.connect("body_entered", self, "on_start_area_body_entered")
	play_area_zone.connect("body_exited", self, "on_play_area_zone_exited")
	
func _physics_process(_delta):
	position.x += speed

func on_start_area_body_entered(body):
	if body in players_nodes_array:
		set_physics_process(true)

func on_play_area_zone_exited(body):
	if body in players_nodes_array:
		emit_signal("loose_condition")