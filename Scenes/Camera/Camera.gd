extends Camera2D

export var speed : float

onready var players_nodes_array = get_tree().get_nodes_in_group("Players")
onready var checkpoints_nodes_array = get_tree().get_nodes_in_group("CHECKPOINTS")
onready var cp_children_array : Array = get_parent().get_children()
onready var start_area_node = get_node("StartCameraArea")
onready var play_area_zone = get_node("PlayZone")

signal loose_condition

#Define the direction of the camera when it moves ( 1 : right / 2 : left / 3 : up / 4 : down)
var cam_direction : int
var dir_index : int = 0
var previous_dir_index : int
var cp_node_array : Array

func _ready():
	var _err
	cam_direction = 1
	
	for children in cp_children_array:
		if children.get_index() != 0:
			cp_children_array[0].cp_node_array.append(children)
	
	# Set the camera play_area (the playable area, where the players need to stay in) to the size of the game window 
	var scr_size = Vector2(ProjectSettings.get("display/window/size/width"), ProjectSettings.get("display/window/size/width"))
	play_area_zone.get_node("CollisionShape2D").get_shape().set_extents(scr_size / 2)
	
	set_physics_process(false)
	start_area_node.connect("body_entered", self, "on_start_area_body_entered")
	play_area_zone.connect("body_exited", self, "on_play_area_zone_exited")
	for cps in checkpoints_nodes_array:
		cps.connect("camera_entered_into_checkpoint", self, "_on_checkpoint_reached")
	
func _physics_process(_delta):
	match(cam_direction):
		0:
			position.x += 0
			position.y += 0
		1:
			position.x += speed #Add speed to position.x each ticks. Mean the camera moves right
		2:
			position.x -= speed #Substract speed to position.x each ticks. Mean the camera moves left
		3:
			position.y -= speed #Add speed to position.x each ticks. Mean the camera  moves up
		4:
			position.y += speed #Add speed to position.x each ticks. Mean the camera moves down

func on_start_area_body_entered(body):
	if body in players_nodes_array:
		set_physics_process(true)

func on_play_area_zone_exited(body):
	if body in players_nodes_array:
		emit_signal("loose_condition")

#func on_checkpoint_trigger_zone_entered(area):
#	if area in checkpoints_nodes_array:
#		emit_signal("checkpoint_reached")

func _on_checkpoint_reached():
	if dir_index > (cp_node_array.size()-1):
		dir_index = 0

	print(cam_direction, " / ", dir_index)
	cam_direction = cp_node_array[dir_index].cp_dir
	print(cam_direction, " / ", dir_index)
	
	dir_index += 1