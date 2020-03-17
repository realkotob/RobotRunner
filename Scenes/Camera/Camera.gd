	extends Camera2D

export var speed : float = 50
export var max_acceleration : float = 500
var current_acceleration : float = 1

onready var checkpoints_nodes_array = get_tree().get_nodes_in_group("CameraCheckpoint")
onready var start_area_node = get_node("StartMovingArea")
onready var play_zone_node = get_node("PlayZone")
onready var fast_forward_zone_node = get_node("FastForwardArea")
onready var safe_area_node = get_node("SafeArea")

onready var original_forward_shape_ext = fast_forward_zone_node.get_node("CollisionShape2D").get_shape().get_extents()
onready var original_safe_area_shape_ext = safe_area_node.get_node("CollisionShape2D").get_shape().get_extents()

var players_node_array : Array

signal player_outside_screen
signal player_inside_screen

export var cam_direction := Vector2(1, 0)

var screen_width : float = ProjectSettings.get("display/window/size/width")
var screen_height : float = ProjectSettings.get("display/window/size/height")
var screen_size := Vector2(screen_width, screen_height)

func _ready():
	add_to_group("InteractivesObjects")
	
	# Set the camera play_area (the playable area, where the players need to stay in) to the size of the game window 
	play_zone_node.get_node("CollisionShape2D").get_shape().set_extents(screen_size / 2)
	
	set_physics_process(false)
	
	# Connect signals
	var _err
	_err = start_area_node.connect("body_entered", self, "on_start_area_body_entered")
	_err = play_zone_node.connect("body_exited", self, "on_play_area_zone_exited")
	_err = play_zone_node.connect("body_entered", self, "on_play_area_zone_entered")
	for checkpoint in checkpoints_nodes_array:
		_err = checkpoint.connect("camera_reached_checkpoint", self, "_on_checkpoint_reached")


# Move the camera given by the last checkpoint
func _physics_process(_delta):
	if is_forwarding():
		var players_forwarding = get_players_forwarding()
		var most_forw_player = get_most_forward_player(players_forwarding)
		current_acceleration = calculate_camera_acceleration(most_forw_player)
	else:
		current_acceleration = 1
	position += (speed / 100) * cam_direction * current_acceleration


# Start to move the camera if a player enter the start area
func on_start_area_body_entered(body):
	if body in players_node_array:
		set_physics_process(true)


# When a player exits the camera zone
func on_play_area_zone_exited(body):
	if body in players_node_array:
		emit_signal("player_outside_screen", body)


# When a player enter back the camera zone
func on_play_area_zone_entered(body):
	if body in players_node_array:
		emit_signal("player_inside_screen", body)


# Get the camera direction from the current check point, and adapt area in response
func _on_checkpoint_reached(cp_dir):
	cam_direction = cp_dir
	adapt_area(fast_forward_zone_node, original_forward_shape_ext)
	adapt_area(safe_area_node, original_safe_area_shape_ext)


# Check if the players are inside/outise an area, depending on the value of the argument ouside (set to false by default)
# Return true is they are inside/ouside, false if not
# If the argument all is true, they all have to be inside/ouside for the method to return true
# If the argument all is false, check if a least one player is inside/outside
func players_in_area(area : Area2D, all : bool):
	var bodies_in_area = area.get_overlapping_bodies()
	
	for player in players_node_array:
		if(player in bodies_in_area) == (!all):
			return !all
	
	return all


# Check if one player or more is in the forward zone while all players are in the safe zone, return true if it is, false if not
func is_forwarding() -> bool:
	# Check if one of the players is inside the fast forward area
	if players_in_area(fast_forward_zone_node, false):
		# Check if all the players are in the safe area
		if players_in_area(safe_area_node, true):
			return true
	return false


# Returns an array of players in the forward area
func get_players_forwarding() -> Array:
	var forward_bodies_array = fast_forward_zone_node.get_overlapping_bodies()
	var players_forwarding : Array = []
	for body in forward_bodies_array:
		if body.is_in_group("Players"):
			players_forwarding.append(body)
	
	return players_forwarding


# Returns the most forward player
func get_most_forward_player(players_array):
	if len(players_array) > 1:
		var dist_player_array : PoolIntArray = []
		for player in players_array:
			var dist_to_border = calculate_distance_to_border(player)
			dist_player_array.append(dist_to_border)
		var most_forw_index = get_max_array_value_index(dist_player_array)
		
		return players_array[most_forw_index]
	
	else:
		return players_array[0]


# Returns the index of the maximum value of all the value in the given array of integers
func get_max_array_value_index(arr : PoolIntArray):
	var max_val = arr[0]
	var i : int = 0
	
	for i in range(1, arr.size()):
		max_val = max(max_val, arr[i])
	
	return i


# Calculate the acceleration of the camera
func calculate_camera_acceleration(most_forw_player : KinematicBody2D) -> float:
	var dist_to_border = calculate_distance_to_border(most_forw_player)
	return max_acceleration * (1 / dist_to_border)


# Returns the distance to the border of the camera
func calculate_distance_to_border(player : KinematicBody2D) -> float:
	var ply_global_pos = player.get_global_position()
	
	var dist_to_border : float = 0.0
	if cam_direction.x != 0:
		dist_to_border = abs((global_position.x + ((screen_width / 2) * cam_direction.x)) - ply_global_pos.x)
	elif cam_direction.y != 0:
		dist_to_border = abs((global_position.y + ((screen_height / 2) * cam_direction.y)) - ply_global_pos.y)
	
	return dist_to_border


# Compute the size and the direction of safe/forward area based on the direction of the camera
func adapt_area(area : Area2D, original_ext : Vector2):
	var collision_shape = area.get_node("CollisionShape2D")
	var shape = collision_shape.get_shape()
	
	### TO SET AS DYNAMIC LATER ###
	# Compute the size of the given shape
	if cam_direction.x != 0:
		shape.extents = original_ext
	if cam_direction.y != 0:
		if area == fast_forward_zone_node:
			shape.extents.x = screen_width / 2
			shape.extents.y = original_ext.x
		else:
			shape.extents.x = screen_width / 2
			shape.extents.y = ((screen_height/2) * 2/3)
	
	# Compute the position of the given area
	collision_shape.position.x = ((screen_width / 2) - shape.extents.x) * sign(cam_direction.x)
	collision_shape.position.y = ((screen_height / 2) - shape.extents.y) * sign(cam_direction.y)
