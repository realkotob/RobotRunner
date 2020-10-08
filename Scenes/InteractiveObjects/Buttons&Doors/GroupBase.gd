extends Node2D
class_name GroupBase

onready var children_array : Array = get_children()
var buttons_to_trigger : Array
var doors_to_open : Array

var nb_buttons : int
var nb_button_triggered : int

func _ready():
	for buttons in children_array:
		if buttons.is_class("DoorButton"):
			buttons.setup()
			nb_buttons += 1


func button_triggered():
	nb_button_triggered += 1
	if nb_button_triggered == nb_buttons:
		for doors in children_array:
			if doors.is_class("Door"):
				doors.open_door()
