extends Node2D

onready var S_IceBlocks_node = get_node("IceBlocks/S")
onready var M_IceBlocks_node = get_node("IceBlocks/M")

onready var WaterTile_node = get_node("WaterTiles")

func _ready():
	WaterTile_node.S_IceBlocks_node = S_IceBlocks_node
	WaterTile_node.M_IceBlocks_node = M_IceBlocks_node
	WaterTile_node.setup()