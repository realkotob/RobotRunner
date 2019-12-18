extends Node2D

onready var area2D_node = get_node("Area2D")
onready var iceblock_scene = preload("res://Scenes/OBJECTS/ICE_BLOCKS/S (BASE)/S_ICE_BLOCK_BASE.tscn")

var ice_block_instance

func _ready():
	ice_block_instance = iceblock_scene.instance()
	ice_block_instance.set_position(self.position)
	var _err = area2D_node.connect("area_entered", self, "on_area_entered")

func on_area_entered(_area):
	add_child(ice_block_instance)

