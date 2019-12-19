extends Camera2D

export var speed : float

onready var players_nodes_array : Array = get_tree().get_nodes_in_group("Players")
onready var start_area_node = get_node("StartCameraArea")
onready var play_zone_node = get_node("PlayZone")


func _ready():
	var scr_size = Vector2(ProjectSettings.get("display/window/size/width"), ProjectSettings.get("display/window/size/height"))
	set_process(false)
	start_area_node.connect("body_entered", self, "on_start_area_body_entered")
	play_zone_node.connect("body_exited", self, "on_play_zone_body_exited")
	play_zone_node.get_node("CollisionShape2D").get_shape().set_extents(scr_size / 2)

func _process(_delta):
	position.x += speed

func on_start_area_body_entered(body):
	if body in players_nodes_array:
		set_process(true)

func on_play_zone_body_exited(body):
	if body in players_nodes_array:
		pass
		