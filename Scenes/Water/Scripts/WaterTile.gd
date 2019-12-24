extends InteractBase

var M_IceBlocks_node : Node2D

onready var iceblock_scene = load("res://Scenes/BreakableObjects/IceBlock/M/MIceBlock.tscn")

var ice_block_instance

func _ready():
	interact_nodes_array = get_tree().get_nodes_in_group("Water")


# Give to the player, the reference to this current interactive object when it enters its area
func on_body_entered(body):
	var water_nodes_array = get_tree().get_nodes_in_group("IceBlock")
	
	if body in players_nodes_array and body.get_node("States/Action").interact_node != self:
		body.get_node("States/Action").interact_node = self
		body.set_in_water(true)
	elif body in water_nodes_array:
		body.set_rigid()

# Whenever a character exits the area of this interact object, set his interact reference to null
func on_body_exited(body):
	var water_nodes_array = get_tree().get_nodes_in_group("IceBlock")
	
	if body in players_nodes_array:
		var is_colliding = false
		
		# When the character get out of the area, check if it's because he left, or because he entered another one
		for interact_node in interact_nodes_array:
			if interact_node.get_node("Area2D").overlaps_body(body) == true and interact_node != self:
				is_colliding = true
		
		# If he left, set his teleport_node value to null
		if is_colliding == false:
			body.get_node("States/Action").interact_node = null
			body.set_in_water(false)
	elif body in water_nodes_array:
		body.set_static()

# Create an ice block on interaction
func interact(pos):
	ice_block_instance = iceblock_scene.instance()
	ice_block_instance.set_global_position(pos)
	M_IceBlocks_node.add_child(ice_block_instance)
