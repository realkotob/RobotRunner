extends Camera2D

export var speed : float

onready var players_nodes_array = get_tree().get_nodes_in_group("Players")
onready var start_area_node = get_node("StartCameraArea")

func _ready():
	set_physics_process(false)
	start_area_node.connect("body_entered", self, "on_body_entered")

func _physics_process(_delta):
	position.x += speed

func on_body_entered(body):
	if body in players_nodes_array:

		set_physics_process(true)
