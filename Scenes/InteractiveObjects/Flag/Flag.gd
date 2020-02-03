extends Node2D

onready var area2D_node = get_node("Area2D")
var players_node_array : Array

signal player_entered
signal player_exited

func _ready():
	add_to_group("InteractivesObjects")
	area2D_node.connect("body_entered", self, "on_body_entered")
	area2D_node.connect("body_exited", self, "on_body_exited")


# Notify the flag group when a player touch a flag
func on_body_entered(body):
	if body in players_node_array:
		emit_signal("player_entered")


# Notify the flag group when a player exit a flag
func on_body_exited(body):
	if body in players_node_array:
		emit_signal("player_exited")

func set_players_array():
	players_node_array = get_tree().get_nodes_in_group("Players")
