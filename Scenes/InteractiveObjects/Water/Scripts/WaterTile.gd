extends InteractBase

var M_IceBlocks_node : Node2D

onready var iceblock_scene = load("res://Scenes/InteractiveObjects/BreakableObjects/IceBlock/M/MIceBlock.tscn")
onready var floating_line_node = get_node("FloatingLine")

var ice_block_instance

func _ready():
	interact_nodes_array = get_tree().get_nodes_in_group("Water")


# Give to the player, the reference to this current interactive object when it enters its area
func on_body_entered(body):
	var iceblocks_array = get_tree().get_nodes_in_group("IceBlock")
	
	if body in players_nodes_array and body.get_node("States/Action").interact_node != self:
		body.get_node("States/Action").interact_node = self
	elif body in iceblocks_array:
		body_floating(body, true)


# Whenever a body exits the area of this interact object, set his interact reference to null
func on_body_exited(body):
	var iceblocks_array = get_tree().get_nodes_in_group("IceBlock")
	
	if body in players_nodes_array:
		var is_colliding = false
		
		# When the character get out of the area, check if it's because he left, or because he entered another one
		for interact_node in interact_nodes_array:
			if interact_node.get_node("Area2D").overlaps_body(body) == true and interact_node != self:
				is_colliding = true
		
		# If he left, set his teleport_node value to null
		if is_colliding == false:
			body.get_node("States/Action").interact_node = null
			
	elif body in iceblocks_array:
		var is_colliding = false
		
		# When the character get out of the area, check if it's because he left, or because he entered another one
		for interact_node in interact_nodes_array:
			if interact_node.get_node("Area2D").overlaps_body(body) == true and interact_node != self:
				is_colliding = true
		
		# If he left, set his teleport_node value to null
		if is_colliding == false:
			body_floating(body, false)


# Create an ice block on interaction
func interact(pos):
	ice_block_instance = iceblock_scene.instance()
	ice_block_instance.set_global_position(pos)
	M_IceBlocks_node.add_child(ice_block_instance)
	body_floating(ice_block_instance, true)
	ice_block_instance.set_rigid()


# Setup the floating on the given body
func body_floating(body : PhysicsBody2D, float_or_not : bool):
	body.is_floating = float_or_not
	
	if float_or_not == true:
		body.floating_line_y = floating_line_node.global_position.y
