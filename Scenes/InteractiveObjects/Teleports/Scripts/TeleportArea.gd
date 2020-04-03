extends Area2D

onready var layer_change_teleport_node : Node

onready var teleport_master_node = get_parent()

var teleporters_array : Array
var players_node_array : Array
var player_already_on_teleportarea : bool

func _ready():
	add_to_group("InteractivesObjects")
	var _err
	_err = connect("body_entered", self, "on_body_entered")
	_err = connect("body_exited", self, "on_body_exited")
	
	#Get all the teleporters in the group
	teleporters_array = teleport_master_node.get_children()
	var teleport_index = get_index()
	
	#get the next teleportarea node in the teleporters_array array
	var suiv = teleport_index + 1
	#if the next teleporter's index is superior than the last index of the array, we set the index to 0 (first teleportarea in the array)
	if suiv > len(teleporters_array) - 1:
		suiv = 0
	
	layer_change_teleport_node = teleporters_array[suiv]

# Whenever a character enters the area of this teleport, this method gives him the referecence to this node
func on_body_entered(body):
	if body in players_node_array and body.get_node("LayerChange").teleport_node != self:
		body.get_node("LayerChange").teleport_node = self
		player_already_on_teleportarea = true


# Whenever a character exits the area of this teleport, set his teleport_node reference to null
func on_body_exited(body):
	if body in players_node_array:
		var is_colliding = false
		
		# When the character get out of the area, check if it's because he left, or because he did teleport
		for teleporter in teleporters_array:
			if teleporter.overlaps_body(body) == true and teleporter != self:
				is_colliding = true
				player_already_on_teleportarea = false
		
		# If he left, set his teleport_node value to null
		if is_colliding == false:
			body.get_node("LayerChange").teleport_node = null
			player_already_on_teleportarea = false


# Teleport the player the the right destination teleporter
func teleport_layer(character : Node):
	
	# Get the size of the character's collision shape
	var y_offset = character.find_node("CollisionShape2D").get_shape().get_extents().y
	var teleport_pos : Vector2 = character.global_position
	
	# Check if one player is already on the teleport or not
	if(!layer_change_teleport_node.player_already_on_teleportarea):
		teleport_pos = layer_change_teleport_node.global_position
	
	teleport_pos.y -= y_offset/10
	character.set_position(teleport_pos)
