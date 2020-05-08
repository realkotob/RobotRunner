extends Node

class_name AttributesBase

onready var stress_jauge_node = get_node("../Jauges/Stress")
onready var productivity_jauge_node = get_node("../Jauges/Productivity")
onready var states_node = get_node("../States")

signal stress_change
signal productivity_change
signal burning_out

var max_stress : int = 6
var max_productivity : int = 6
var stress : int = 1 setget set_stress, get_stress
var productivity : int = 3 setget set_productivity, get_productivity

var burnout : bool = false setget set_burnout, get_burnout

# Connect the signals to the stress and productivity jauges
func _ready():
	var _err
	_err = connect("stress_change", stress_jauge_node, "on_stress_change")
	_err = connect("productivity_change", productivity_jauge_node, "on_productivity_change")
	_err = connect("burning_out", states_node, "on_burning_out")

func set_stress(value : int):
	if value >= 0 && value <= max_stress:
		stress = value
		if stress == max_stress:
			set_burnout(true)
		emit_signal("stress_change")

func get_stress() -> int:
	return stress

func set_productivity(value : int):
	if value >= 0 && value <= max_productivity:
		productivity = value
		emit_signal("productivity_change")

func get_productivity() -> int:
	return productivity

func set_burnout(value : bool):
	burnout = value
	if value == true:
		emit_signal("burning_out")

func get_burnout() -> bool:
	return burnout