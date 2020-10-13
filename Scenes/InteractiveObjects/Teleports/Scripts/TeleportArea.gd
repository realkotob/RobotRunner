extends Area2D

onready var destination_teleport_node : Node

onready var teleport_master_node = get_parent()

var teleporters_array : Array
var player_on_top : bool

func _ready():
	var _err
	_err = connect("body_entered", self, "on_body_entered")
	_err = connect("body_exited", self, "on_body_exited")
	
	# Get all the teleporters in the group
	teleporters_array = teleport_master_node.get_children()
	var teleport_index = get_index()
	
	# Get the next teleportarea node in the teleporters_array array
	var suiv = teleport_index + 1
	# If the next teleporter's index is superior than the last index of the array, we set the index to 0 (first teleportarea in the array)
	if suiv > len(teleporters_array) - 1:
		suiv = 0
	
	destination_teleport_node = teleporters_array[suiv]


# Whenever a character enters the area of this teleport, this method gives him the referecence to this node
func on_body_entered(body):
	if body.is_class("Player") and body.teleport_node != self:
		body.teleport_node = self
		player_on_top = true


# Whenever a character exits the area of this teleport, set his teleport_node reference to null
func on_body_exited(body):
	if body.is_class("Player"):
		var is_colliding = false
		
		# When the character get out of the area, check if it's because he left, or because he did teleport
		for teleporter in teleporters_array:
			if teleporter.overlaps_body(body) == true and teleporter != self:
				is_colliding = true
				player_on_top = false
		
		# If he left, set his teleport_node value to null
		if is_colliding == false:
			body.teleport_node = null
			player_on_top = false


# Teleport the player the the right destination teleporter
func teleport_layer(character : Node):
	if destination_teleport_node.player_on_top:
		return
	
	# Get the size of the character's collision shape
	var y_offset = character.find_node("CollisionShape2D").get_shape().get_extents().y
	var teleport_pos : Vector2 = character.global_position
	
	### Tricks to fix the teleport bug when a player is on top of another when teleporting ###
	# Stock every other player's position
	var level = get_tree().get_current_scene()
	var other_players_array = level.players_array.duplicate()
	var id_to_erase := PoolIntArray()
	var other_players_pos_array : Array = []
	for i in range(other_players_array.size()):
		if other_players_array[i] == character:
			id_to_erase.append(i)
		else:
			other_players_pos_array.append(other_players_array[i].get_global_position())
	
	for i in id_to_erase.size():
		other_players_array.remove(id_to_erase[i] - i)
	
	# Check if one player is already on the teleport or not
	teleport_pos = destination_teleport_node.global_position
	teleport_pos.y -= y_offset / 10
	character.set_position(teleport_pos)
	
	### Tricks to fix the teleport bug when a player is on top of another when teleporting ###
	# Teleport back every other players on their original position
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	for i in range(other_players_array.size()):
		if other_players_pos_array.size() == 0 : break
		other_players_array[i].set_global_position(other_players_pos_array[i])
