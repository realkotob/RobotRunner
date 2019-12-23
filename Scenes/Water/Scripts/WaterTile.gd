extends InteractBase

var S_IceBlocks_node : Node2D
var M_IceBlocks_node : Node2D

onready var iceblock_scene = load("res://Scenes/BreakableObjects/IceBlock/S (BASE)/IceBlockBase.tscn")

var ice_block_instance

# Create an ice block on interact
func interact():
	ice_block_instance = iceblock_scene.instance()
	ice_block_instance.set_global_position(self.global_position)
	S_IceBlocks_node.add_child(ice_block_instance)