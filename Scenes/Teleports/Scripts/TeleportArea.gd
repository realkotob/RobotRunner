extends Area2D

onready var layer_up_teleport_node: Node
onready var layer_down_teleport_node: Node

onready var players_nodes_array : Array = get_tree().get_nodes_in_group("Players")

onready var teleport_master_node = get_parent()

func _ready():
	var _err
	_err = connect("body_entered", self, "on_body_entered")
	_err = connect("body_exited", self, "on_body_exited")
	var children_array = teleport_master_node.get_children()
	var i = get_index()
	
	var prec = i - 1
	if prec < 0:
		prec = len(children_array) - 1
	var suiv = i + 1
	if suiv > len(children_array) - 1:
		suiv = 0
	
	layer_up_teleport_node = children_array[prec]
	layer_down_teleport_node = children_array[suiv]

func on_body_entered(body):
	if body in players_nodes_array:
#		body.get_node("LayerChange").teleport_node = self
		pass
	
func on_body_exited(body):
	if body in players_nodes_array:
#		body.get_node("LayerChange").teleport_node = null
		pass

func teleport_layer_up(character):
	character.set_position(layer_up_teleport_node.position)

func teleport_layer_down(character):
	character.set_position(layer_down_teleport_node.position)