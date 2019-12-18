extends Node

onready var character_node = get_parent().get_parent()
onready var attributes_node = get_parent().get_parent().get_node("Attributes")
onready var states_node = get_parent()