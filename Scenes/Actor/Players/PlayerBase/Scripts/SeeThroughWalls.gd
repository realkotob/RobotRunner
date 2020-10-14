extends Light2D

onready var area_node = $Area2D
var monitoring_overlaps : bool = false setget set_monitoring_overlaps, is_monitoring_overlaps

func _ready():
	area_node.connect("body_entered", self, "on_body_entered")
	area_node.connect("area_entered", self, "on_area_entered")


func set_monitoring_overlaps(value: bool):
	monitoring_overlaps = value
	set_physics_process(value)


func is_monitoring_overlaps() -> bool:
	return monitoring_overlaps


func on_body_entered(body):
	if body.name == "HiddenWalls":
		set_monitoring_overlaps(true)
		set_enabled(true)


func on_area_entered(area):
	if area.name == "XionCloud":
		set_monitoring_overlaps(true)
		set_enabled(true)


func find_element(element_array: Array, element_name : String):
	var found = false
	
	for element in element_array:
		if element.name == element_name:
			found = true
	
	return found


func _physics_process(_delta):
	if is_monitoring_overlaps():
		if !find_element(area_node.get_overlapping_bodies(), "HiddenWalls"):
			if !find_element(area_node.get_overlapping_areas(), "XionCloud"):
				set_monitoring_overlaps(false)
				set_enabled(false)
